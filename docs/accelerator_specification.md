# Matrix Multiplication Accelerator Specification

## 1. Overview
Custom RISC-V ISA extension for accelerating matrix multiplication in neural network inference.

## 2. Custom Instructions

### 2.1 MMUL (Matrix Multiply)
- **Opcode:** `0x0B` (custom-0 space)
- **Format:** R-type
- **Syntax:** `mmul rd, rs1, rs2`
- **Function:** Triggers matrix multiply: rd ← [rs1] × [rs2]

**Encoding:**
```
 31        25 24    20 19    15 14  12 11     7 6      0
┌───────────┬────────┬────────┬──────┬────────┬────────┐
│  funct7   │  rs2   │  rs1   │funct3│   rd   │ opcode │
│  0000001  │ addr2  │ addr1  │ 000  │  dest  │ 0001011│
└───────────┴────────┴────────┴──────┴────────┴────────┘
```

### 2.2 MCFG (Matrix Configure)
- **Opcode:** `0x0B` (custom-0 space)
- **Format:** I-type
- **Syntax:** `mcfg rs1, imm`
- **Function:** Configure matrix dimensions

## 3. Hardware Architecture

```
┌─────────────────────────────────────────────────────┐
│                  RISC-V Core (RV64GC)                │
│  ┌────────────────────────────────────────────────┐ │
│  │         Instruction Decode Unit                 │ │
│  │  ┌──────────────────────────────────────────┐  │ │
│  │  │    Custom Instruction Decoder             │  │ │
│  │  │    (Detects 0x0B opcode)                  │  │ │
│  │  └──────────────┬───────────────────────────┘  │ │
│  └─────────────────┼──────────────────────────────┘ │
└────────────────────┼────────────────────────────────┘
                     │
                     ↓
┌────────────────────────────────────────────────────┐
│     Matrix Multiplication Accelerator (MMU)        │
│  ┌──────────────────────────────────────────────┐ │
│  │           Control Unit                        │ │
│  │  • Dimension registers (M, N, K)              │ │
│  │  • State machine (IDLE → FETCH → COMPUTE)     │ │
│  └──────────────────────────────────────────────┘ │
│                                                    │
│  ┌──────────────────────────────────────────────┐ │
│  │      Processing Element Array (8×8)          │ │
│  │   ┌────┬────┬────┬────┬────┬────┬────┬────┐ │ │
│  │   │ PE │ PE │ PE │ PE │ PE │ PE │ PE │ PE │ │ │
│  │   ├────┼────┼────┼────┼────┼────┼────┼────┤ │ │
│  │   │MAC │MAC │MAC │MAC │MAC │MAC │MAC │MAC │ │ │
│  │   │unit│unit│unit│unit│unit│unit│unit│unit│ │ │
│  │   └────┴────┴────┴────┴────┴────┴────┴────┘ │ │
│  │   Each PE: Multiply-Accumulate (FP32)        │ │
│  └──────────────────────────────────────────────┘ │
│                                                    │
│  ┌──────────────────────────────────────────────┐ │
│  │      Local Buffer Memory (4KB SRAM)          │ │
│  │  • Input buffer (2KB)                         │ │
│  │  • Weight buffer (2KB)                        │ │
│  └──────────────────────────────────────────────┘ │
└────────────────┬───────────────────────────────────┘
                 │
                 ↓
          ┌─────────────┐
          │  Memory Bus │
          │   (AXI-4)   │
          └─────────────┘
```

## 4. Operation Flow

1. **Configuration Phase:**
   - CPU executes `mcfg` to set dimensions (M×N, N×K)
   - MMU stores dimensions in internal registers

2. **Execution Phase:**
   - CPU executes `mmul rd, rs1, rs2`
   - MMU reads matrix data from addresses in rs1, rs2
   - 8×8 PE array processes tiles in parallel
   - Results written to address in rd
   - Status returned to CPU

3. **Timing:**
   - Setup: 10 cycles
   - Per 8×8 tile: 64 cycles (pipelined)
   - For 128×128 matrix: 10 + (16 × 16 × 64) = 16,394 cycles

## 5. Performance Model

### Baseline (Software):
- Matrix multiply C = A × B (M×N × N×K)
- Operations: M × N × K multiply-adds
- RISC-V instructions per MAC: ~8-12
- Example (784×128): 784 × 128 × 128 × 10 ≈ 12.8M instructions

### With Accelerator:
- Setup: 10 cycles
- Compute: (M/8) × (N/8) × (K/8) × 64 cycles
- Example (784×128): 10 + (98 × 16 × 16 × 64) ≈ 1.6M cycles

**Speedup: ~8x for matrix operations**

## 6. Integration with Spike

### Files to Modify:
1. `riscv-isa-sim/riscv/encoding.h`
   - Add custom opcode definitions

2. `riscv-isa-sim/riscv/insns/mmul.h`
   - Implement matrix multiply logic

3. `riscv-isa-sim/riscv/processor.cc`
   - Add MMU state and registers

### Example Implementation:
```cpp
// insns/mmul.h
reg_t addr_a = RS1;
reg_t addr_b = RS2;
reg_t addr_c = RD;

// Simulate accelerated matrix multiply
for (int i = 0; i < cfg_m; i++) {
  for (int j = 0; j < cfg_k; j++) {
    float sum = 0;
    for (int k = 0; k < cfg_n; k++) {
      sum += MEM_FLOAT(addr_a + (i*cfg_n + k)*4) * 
             MEM_FLOAT(addr_b + (k*cfg_k + j)*4);
    }
    MEM_FLOAT(addr_c + (i*cfg_k + j)*4) = sum;
  }
}

// Increment cycle count by accelerated amount
STATE.cycle_count += 10 + (cfg_m * cfg_n * cfg_k / 64);
```

## 7. Software Library

```c
// accel_lib.c
void accel_matmul(float *A, float *B, float *C, int M, int N, int K) {
    #ifdef USE_ACCELERATOR
        // Configure dimensions
        asm volatile (
            "mcfg %0, %1" 
            : : "r"((M << 16) | (N << 8) | K)
        );
        
        // Execute matrix multiply
        asm volatile (
            "mmul %0, %1, %2"
            : : "r"(C), "r"(A), "r"(B)
        );
    #else
        // Software fallback
        for (int i = 0; i < M; i++) {
            for (int j = 0; j < K; j++) {
                C[i*K + j] = 0;
                for (int k = 0; k < N; k++) {
                    C[i*K + j] += A[i*N + k] * B[k*K + j];
                }
            }
        }
    #endif
}
```

## 8. Area and Power Estimates

### Hardware Cost:
- Processing Elements (64 MACs): ~15K gates each = 960K gates
- Control logic: ~50K gates
- Local buffers (4KB SRAM): ~40K gates
- **Total: ~1.05M gates (~0.5mm² in 7nm)**

### Power Analysis:
- Active power: ~200mW @ 1GHz
- Idle power: ~5mW
- Power per operation: 0.1 nJ/MAC
- **Compared to CPU: 10x more efficient**

## 9. Trade-offs

### Advantages:
✓ 8-10x speedup for matrix operations
✓ 10x better power efficiency
✓ Reduced memory bandwidth (local buffers)
✓ Scalable to larger arrays

### Disadvantages:
✗ Fixed-function hardware (not programmable)
✗ Requires compiler/toolchain modifications
✗ Additional silicon area cost
✗ Limited to FP32 (no INT8 quantization)

## 10. Future Enhancements
- Support for INT8/INT16 quantized inference
- Configurable PE array size (4×4, 16×16)
- Double buffering for overlap compute/memory
- Direct DMA access to DRAM
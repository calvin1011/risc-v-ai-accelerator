#!/bin/bash
clear
echo "=== RISC-V AI Accelerator Demo ==="
echo ""
echo "1. Toolchain:"
riscv64-unknown-elf-gcc --version | head -1
echo ""
echo "2. Compilation:"
cd src/workload && make clean && make
file mnist_baseline
echo ""
echo "3. Results: See docs/accelerator_specification.md"
echo "4. Performance: See results/performance_analysis.md"
echo ""
echo "Key Achievement: 4.79x speedup, 8.52x efficiency"

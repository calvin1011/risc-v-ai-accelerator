# Environment Setup Documentation

## System Information
- Host OS: Windows
- WSL Distribution: Ubuntu
- IDE: VS Code with WSL extension
- Project Location: ~/projects/risc-v-ai-accelerator

## Installation Log

### RISC-V GNU Toolchain - INSTALLED
**Installation Date:** October 19, 2025
**Method:** Pre-built Ubuntu package
**Version:** riscv64-unknown-elf-gcc 13.2.0

**Installation Command:**
```bash
sudo apt install -y gcc-riscv64-unknown-elf
```

**Verification:**
```bash
riscv64-unknown-elf-gcc --version
# Output: riscv64-unknown-elf-gcc (13.2.0-11ubuntu1+12) 13.2.0
```

**Status:** Successfully installed and verified

#### Tools To Install:
- [ ] RISC-V GNU Toolchain
- [ ] Spike RISC-V ISA Simulator
- [ ] RISC-V Proxy Kernel (pk)
- [ ] DRAMsim3 Memory Simulator

#### Tests To Complete:
- [ ] TC-100: Hello World RISC-V compilation and execution
- [ ] TC-101: Memory simulator integration test

---

## Installation Steps

### Prerequisites Installed
```bash
sudo apt update
sudo apt upgrade -y
sudo apt install -y build-essential git curl wget vim tree autoconf automake \
    autotools-dev python3 libmpc-dev libmpfr-dev libgmp-dev gawk bison flex \
    texinfo gperf libtool patchutils bc zlib1g-dev libexpat-dev ninja-build cmake
```

### RISC-V GNU Toolchain


### Spike ISA Simulator


### DRAMsim3


---

## Issues Encountered


## Version Information

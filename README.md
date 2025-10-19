# RISC-V AI Accelerator Simulation

Hardware-Software Co-Design for AI on RISC-V with Memory Simulation

## Project Overview
This project simulates a RISC-V processor with a custom AI hardware accelerator (DSA) for matrix multiplication, benchmarking MNIST image classification performance.

## Directory Structure
- `docs/` - Project documentation and setup guides
- `src/` - Source code
  - `workload/` - MNIST AI workload code
  - `accelerator/` - DSA simulation code  
  - `library/` - Co-design software library
- `scripts/` - Build and simulation automation scripts
- `tests/` - Test cases and validation
- `results/` - Benchmark data and performance logs

## Tools & Technologies
- RISC-V GNU Toolchain - Cross-compiler for RISC-V
- Spike - RISC-V ISA Simulator
- DRAMsim3 - Memory System Simulator
- C/C++ - Implementation languages
- Linux/WSL2 - Development environment

## Setup Instructions
See [docs/SETUP.md](docs/SETUP.md) for detailed installation steps.
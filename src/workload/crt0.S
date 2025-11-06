# Bare-metal C startup file - CORRECTED VERSION
.section .text
.globl _start

_start:
    # Load stack pointer with ABSOLUTE address calculation
    # Stack top is at: RAM_BASE (0x80000000) + RAM_SIZE (0x10000000) = 0x90000000
    li t0, 0x80000000      # Load RAM base
    li t1, 0x10000000      # Load RAM size (256MB)
    add sp, t0, t1         # sp = 0x80000000 + 0x10000000 = 0x90000000
    
    # Alternative method (more efficient):
    # lui sp, 0x90000       # Load 0x90000000 directly
    
    # Clear frame pointer
    mv s0, zero
    
    # Call main
    call main
    
    # Save return value (prediction)
    mv s1, a0
    
    # Try to exit via ecall
    mv a1, s1
    li a0, 93
    ecall
    
    # Fallback: infinite low-power loop
.L_hang:
    wfi
    j .L_hang
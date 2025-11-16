.section .text
.globl _start

_start:
    # Simple direct load of stack pointer
    li sp, 0x90000000
    
    # Call main
    call main
    
    # Exit with return value from main (in a0)
    # Use tohost mechanism for Spike
    la t0, tohost
    sd a0, 0(t0)
    
    # Loop forever waiting for Spike to notice
1:  j 1b

# Add tohost/fromhost symbols for Spike
.section .tohost,"aw",@progbits
.align 6
.globl tohost
tohost: .dword 0
.globl fromhost
fromhost: .dword 0
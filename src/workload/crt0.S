.section .text
.globl _start

_start:
    # Simple direct load of stack pointer
    li sp, 0x90000000
    
    # Call main
    call main
    
    # Loop forever
1:  wfi
    j 1b
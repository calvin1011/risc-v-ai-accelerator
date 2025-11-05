# Bare-metal C startup file

.section .text
.globl _start
.extern main
.extern _stack_top  /* Import the stack top symbol from the linker script */

_start:
    # Set the stack pointer to the top of our RAM region
    la sp, _stack_top

    # Jump to the main C function
    call main

# After main returns, hang forever in a loop.
# There is no OS to exit to.
loop:
    j loop
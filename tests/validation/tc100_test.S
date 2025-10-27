.section .text
.globl _start

_start:
    li a0, 42       # Load immediate value 42
    li a7, 93       # Exit syscall
    ecall           # Make syscall

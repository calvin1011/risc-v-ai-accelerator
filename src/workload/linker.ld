/* Linker script for a bare-metal RISC-V program */
OUTPUT_ARCH(riscv)
ENTRY(_start)

/* Define the memory layout of our simulated machine */
MEMORY
{
  ram (rwx) : ORIGIN = 0x80000000, LENGTH = 256M
}

SECTIONS
{
  . = 0x80000000;
  
  .text : {
    *(.text.init)     
    *(.text .text.*)
  } > ram
  
  .rodata : { *(.rodata .rodata.*) } > ram
  .data : { *(.data .data.*) } > ram
  .bss : { *(.bss .bss.*) } > ram
  
  _stack_top = ORIGIN(ram) + LENGTH(ram);
}
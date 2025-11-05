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
  /* Place the executable code in the 'ram' region */
  .text : {
    *(.text .text.*)
  } > ram

  /* Place other sections after the code */
  .rodata : { *(.rodata .rodata.*) } > ram
  .data : { *(.data .data.*) } > ram
  
  /* Place the giant neural network global variable here */
  .bss : { *(.bss .bss.*) } > ram

  /* Define a symbol that points to the top of our RAM for the stack */
  _stack_top = ORIGIN(ram) + LENGTH(ram);
}
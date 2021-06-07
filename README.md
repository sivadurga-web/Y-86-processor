# Y-86-processor
Y-86 processor that executes  Y-86 instruction set.

In this project, I designed y-86 sequential architecture and y-86 pipeline architecture. The
Y-86 sequential architecture will work for all the Y-86 instructions.

# Y-86 Instructions

The Y-86-64 instruction set architecture (ISA) is a subset of the x86-64 instruction set. This
instruction set architecture will process 8-byte integer operations. A total of 12 instructions
are included in this Y86-64 ISA. It includes arithmetic operations like addition, subtraction,
and bitwise operations like AND, XOR. Other than that it also includes move instructions to
move data to registers and memory, it also includes nop, halt, call, ret, push, pop,
conditional and unconditional jump, move instructions.

Y86-64 processor is implemented in sequential, where each instruction a single instruction is executed in one clock cycle and 
pipeline, where multiple instruction are executed parallely in different stages at the same clock cycle.

For detailed information about the Y-86 instructions and its implementation and how to execut, refer to **_Y86 processor.pdf_**.

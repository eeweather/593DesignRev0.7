// ECE593 Project 2023wi
//  Victoria Van Gaasbeck <vvan@pdx.edu>
//  Julia Filipchuk <bfilipc2@pdx.edu>
//  Emily Weatherford <ew22@pdx.edu>
//  Daniel Keller <dk27@pdx.edu>
//
// TinyALU pkg
// Adapted from "The UVM Primer" by Ray Salemi

package tinyalu_pkg;

    typedef enum logic [3:0] {
		op_nop    = 4'b0000,
		op_add    = 4'b0001, // Add A, B
		op_and    = 4'b0010, // And A, B
		op_xor    = 4'b0011, // Xor  A, B
		op_mul    = 4'b0100, // Multiply A, B      (3 cycle)
		op_sp0    = 4'b0101, // Function A + 2 * B (3+1 cycle)
		op_sp1    = 4'b0110, // Function 2 * A     (3 cycle)
		op_sp2    = 4'b0111, // Function 3 * A     (3 cycle)
		op_load   = 4'b1000, // Load Memory to Register
		op_store  = 4'b1001, // Store Register to Memory
		op_shl    = 4'b1010, // shift left 3 bits
		op_shr    = 4'b1011, //shift right 3 bits
		op_res1   = 4'b1100,
		op_res2   = 4'b1101,
		op_res3   = 4'b1110, 
		op_nop1   = 4'b1111
	} alu_opcode_t;




endpackage : tinyalu_pkg
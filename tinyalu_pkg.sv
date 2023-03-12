// ECE593 Project 2023wi
//  Victoria Van Gaasbeck <vvan@pdx.edu>
//  Julia Filipchuk <bfilipc2@pdx.edu>
//  Emily Weatherford <ew22@pdx.edu>
//  Daniel Keller <dk27@pdx.edu>
//
// TinyALU pkg
// Adapted from "The UVM Primer" by Ray Salemi

package tinyalu_pkg;
	`include "uvm_macros.svh"
	import uvm_pkg::*;

	parameter INSTR_WIDTH = 19; // Width of Instruction

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
		op_shl    = 4'b1010, // shift regA left 3 bits
		op_shr    = 4'b1011, //shift regA right 3 bits
		op_res1   = 4'b1100,
		op_res2   = 4'b1101,
		op_res3   = 4'b1110, 
		op_nop1   = 4'b1111
	} alu_opcode_t;

	typedef logic [INSTR_WIDTH-1:0] instruction_t;

//	typedef class agent_config;
	typedef class agent;
	typedef class coverage_collector;
	typedef class driver;
	typedef class env_config;
	typedef class env;
	typedef class evaluator;
	typedef class item_base;
	typedef class monitor;
	typedef class predictor;
	typedef class scoreboard;
	typedef class sequence_base;
	typedef class test_base;
	typedef class item_alu;
	typedef class item_multi;
	typedef class item_single;
	typedef class item_load;
	typedef class item_store;
	typedef class item_valid;
	typedef class sequence_alu;
	typedef class test_alu;

//	`include "tb/agent_config.svh"
	`include "tb/agent.svh"
	`include "tb/coverage_collector.svh"
	`include "tb/driver.svh"
	`include "tb/env_config.svh"
	`include "tb/env.svh"
	`include "tb/evaluator.svh"
	`include "tb/item_base.svh"
	`include "tb/monitor.svh"
	`include "tb/predictor.svh"
	`include "tb/scoreboard.svh"
	`include "tb/sequence_base.svh"
	`include "tb/test_base.svh"
	`include "tb/test_alu.svh"
	`include "tb/sequence_alu.svh"
	`include "tb/item_alu.svh"
	`include "tb/item_load.svh"
	`include "tb/item_store.svh"
	`include "tb/item_multi.svh"
	`include "tb/item_single.svh"
	`include "tb/item_valid.svh"



endpackage : tinyalu_pkg

/*  ECE593 Project 2023wi
*   Victoria Van Gaasbeck <vvan@pdx.edu>
*   Julia Filipchuk <bfilipc2@pdx.edu>
*   Emily Weatherford <ew22@pdx.edu>
*   Daniel Keller <dk27@pdx.edu>
*
*   ALU sequence for generating ALU sequences 
*/

class sequence_alu extends sequence_base;// #(item_base);
	`uvm_object_utils(sequence_alu)

    item_base tx;

	function new(string name="sequence_alu");
		super.new(name);
	endfunction

	task init_start(input uvm_sequencer #(item_base) sqr);
		this.start(sqr);
	endtask: init_start


	item_alu alu;
	item_load load;
	item_store store;

	//generate a sequence of ALU transactions
	task body();

		alu = item_alu::type_id::create("alu");
		store = item_store::type_id::create("store");
		load = item_load::type_id::create("load");
			
		//all_alu_ops();
		repeat(5) get_alu_tx();
	
	
	endtask: body

	//iterate through all of the valid ALU operations
	task all_alu_ops();
		for (int i = 1; i < 8; i++) begin			
			get_alu_tx(0, alu_opcode_t'(i));					
		end
		get_alu_tx(0, op_shl);
		get_alu_tx(0, op_shr);
	endtask

endclass: sequence_alu


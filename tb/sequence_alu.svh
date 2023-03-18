/*  ECE593 Project 2023wi
*   Victoria Van Gaasbeck <vvan@pdx.edu>
*   Julia Filipchuk <bfilipc2@pdx.edu>
*   Emily Weatherford <ew22@pdx.edu>
*   Daniel Keller <dk27@pdx.edu>
*
*   ALU sequence for generating ALU sequence items
*/

class sequence_alu extends sequence_base;
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
	item_multi multiOp;
	item_single singleOp;

	//generate a sequence of ALU transactions
	task body();

		alu = item_alu::type_id::create("alu");
		store = item_store::type_id::create("store");
		load = item_load::type_id::create("load");
		multiOp = item_multi::type_id::create("multiOp");
		singleOp = item_single::type_id::create("singleOp");
			
		all_alu_ops();
		repeat(1000) get_alu_tx();
	
	endtask: body

	//iterate through all of the valid ALU operations
	task all_alu_ops();
		for (int i = 1; i < 8; i++) begin			
			get_alu_tx(0, alu_opcode_t'(i));					
		end
		get_alu_tx(0, op_shl);
		get_alu_tx(0, op_shr);
	endtask

	//get a randomized multicyle tx 
	task multicycle_tx;
		load_data();
		if(!multiOp.randomize()) `uvm_fatal(get_type_name(), "multiOp.randomize failed")
		start_item(multiOp);
		finish_item(multiOp);
		store_data();
	endtask

	//get a randomized single cycle tx 
	task singlecycle_tx;
		load_data();
		if(!singleOp.randomize()) `uvm_fatal(get_type_name(), "singleOp.randomize failed")
		start_item(singleOp);
		finish_item(singleOp);
		store_data();
	endtask

endclass: sequence_alu


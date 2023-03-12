/*  ECE593 Project 2023wi
*   Victoria Van Gaasbeck <vvan@pdx.edu>
*   Julia Filipchuk <bfilipc2@pdx.edu>
*   Emily Weatherford <ew22@pdx.edu>
*   Daniel Keller <dk27@pdx.edu>
*
*   ALU sequence for generating ALU sequences 
*/

class sequence_alu extends uvm_sequence #(item_base);
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
			
		all_alu_ops();

		load_data();
		get_alu_op();
		store_data();
	
	endtask: body

	//iterate through all of the valid ALU operations
	task all_alu_ops();

		for (int i = 1; i < 8; i++) begin			
			load_data(); 

			if(!alu.randomize()) `uvm_fatal(get_type_name(), "alu.randomize failed")
			alu.inst[INSTR_WIDTH-1:INSTR_WIDTH-4] = i;
			start_item(alu);
			finish_item(alu);
			
			if(!store.randomize()) `uvm_fatal(get_type_name(), "store.randomize failed")
			start_item(store);
			finish_item(store);								
		end

		load_data(); 

		if(!alu.randomize()) `uvm_fatal(get_type_name(), "alu.randomize failed")
		alu.inst[INSTR_WIDTH-1:INSTR_WIDTH-4] = op_shl;
		start_item(alu);
		finish_item(alu);

		store_data();	
		load_data(); 

		if(!alu.randomize()) `uvm_fatal(get_type_name(), "alu.randomize failed")
		alu.inst[INSTR_WIDTH-1:INSTR_WIDTH-4] = op_shr;
		start_item(alu);
		finish_item(alu);

		store_data();
	endtask

	task load_data();
		repeat(2) begin
			if(!load.randomize()) `uvm_fatal(get_type_name(), "load.randomize failed")
			start_item(load);
			finish_item(load);
			end
	endtask

	task store_data();
		if(!store.randomize()) `uvm_fatal(get_type_name(), "store.randomize failed")
		start_item(store);
		finish_item(store);
	endtask

	task get_alu_op();
		if(!alu.randomize()) `uvm_fatal(get_type_name(), "alu.randomize failed")
		start_item(alu);
		finish_item(alu);
	endtask;


endclass: sequence_alu


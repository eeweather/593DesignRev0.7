/*  ECE593 Project 2023wi
*   Victoria Van Gaasbeck <vvan@pdx.edu>
*   Julia Filipchuk <bfilipc2@pdx.edu>
*   Emily Weatherford <ew22@pdx.edu>
*   Daniel Keller <dk27@pdx.edu>
*
*   Base sequence for generating sequence item(s) 
*/

class sequence_base extends uvm_sequence #(item_base);
	`uvm_object_utils(sequence_base)

	function new(string name="sequence_base");
		super.new(name);
	endfunction

	agent_config agent_cfg;
	
	item_base tx;	
	item_alu alu;
	item_load load;
	item_store store;



	task init_start(input uvm_sequencer #(item_base) sqr, input agent_config agent_cfg);
		this.agent_cfg = agent_cfg;
		this.start(sqr);
	endtask: init_start

	//the body task is where transactions (or sequence items, or whatever) are created, randomized, and started/finished
	task body();
		tx = item_base::type_id::create("tx");
		alu = item_alu::type_id::create("alu");
		load = item_load::type_id::create("load");
		store = item_store::type_id::create("store");
	
		repeat(2) begin
			if(!load.randomize()) `uvm_fatal(get_type_name(), "load.randomize failed")
			start_item(load);
			finish_item(load);
		end
		if(!alu.randomize()) `uvm_fatal(get_type_name(), "alu.randomize failed")
		start_item(alu);
		finish_item(alu);

		if(!store.randomize()) `uvm_fatal(get_type_name(), "fml.randomize failed")
		start_item(store);
		finish_item(store);

	endtask: body


endclass: sequence_base

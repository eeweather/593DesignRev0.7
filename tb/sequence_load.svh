/*  ECE593 Project 2023wi
*   Victoria Van Gaasbeck <vvan@pdx.edu>
*   Julia Filipchuk <bfilipc2@pdx.edu>
*   Emily Weatherford <ew22@pdx.edu>
*   Daniel Keller <dk27@pdx.edu>
*
*   Load sequence 
*/

class sequence_load extends sequence_base;// #(item_base);
	`uvm_object_utils(sequence_load)

    item_base tx;

	function new(string name="sequence_load");
		super.new(name);
	endfunction

	task init_start(input uvm_sequencer #(item_base) sqr);
		this.start(sqr);
	endtask: init_start

	item_load load;
	
	//generate a sequence of ALU transactions
	task body();
			
		all_load_ops();
		
	
	endtask: body

	//load from all the places
	task all_load_ops();
		load = item_load::type_id::create("load");
		for (int i = 0; i <= 16; i++) begin			
		    if(!load.randomize()) `uvm_fatal(get_type_name(), "load.randomize failed");
            load.inst[14:1] = i;
			start_item(load);
			finish_item(load);				
		end
	endtask


endclass: sequence_load


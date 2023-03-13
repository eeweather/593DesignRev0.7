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
	item_alu alu;
	item_load load;
	item_store store;

	function new(string name="sequence_load");
		super.new(name);
	endfunction

	task init_start(input uvm_sequencer #(item_base) sqr);
		this.start(sqr);
	endtask: init_start

	
	
	//generate a sequence of ALU transactions
	task body();
		
		load = item_load::type_id::create("load");
        store = item_store::type_id::create("store");
		alu = item_alu::type_id::create("alu");
		
		//all_load_ops();
		load_store_load(3);
		
	
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

	//all procs store to same location and then load from it
	task load_store_load(logic [13:0] addr = 'x);

		if(addr === 'x) 
			addr = $urandom_range(0,16);
			
		//load register A in all 4 procs
		if(!load.randomize()) `uvm_fatal(get_type_name(), "load.randomize failed");
        load.inst[0] = 0;
        start_item(load);
        finish_item(load);	

		//Perorm and add operation
		if(!alu.randomize()) `uvm_fatal(get_type_name(), "alu.randomize failed")
		alu.inst[INSTR_WIDTH-1:INSTR_WIDTH-4] = op_add;			
		start_item(alu);
		finish_item(alu);
        
		//store to the same memory location
		if(!store.randomize()) `uvm_fatal(get_type_name(), "store.randomize failed")
        store.inst[14:1] = addr;
		start_item(store);
		finish_item(store);
        
		//load from the same memory location
        if(!load.randomize()) `uvm_fatal(get_type_name(), "load.randomize failed");
        load.inst[14:1] = addr;
		load.inst[0] = 1;
	    start_item(load);
    	finish_item(load);	 

        
	endtask


endclass: sequence_load


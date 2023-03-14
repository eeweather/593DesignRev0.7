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

	
	
	//generate a sequence of load/store transaction
	task body();
		
		load = item_load::type_id::create("load");
        store = item_store::type_id::create("store");
		alu = item_alu::type_id::create("alu");
		
		//all_load_ops();
		load_store_load(3);
		//all_load_store();
		
	
	endtask: body


	//load from all the places
	task all_load_ops();
		for (int i = 0; i < MAX_ADDR; i++) begin			
		   load_addr(i);		
		end
	endtask

	//load, random alu op, then store to all the places
	task all_load_store();
		for (int i = 0; i < MAX_ADDR; i++) begin			
			load_addr(i);	
			get_alu();
			store_data(i);
		end
	endtask

	//all procs store to same location and then load from it
	task load_store_load(logic [13:0] addr = 'x);
		if(addr === 'x) 
			addr = $urandom();		
		//load a random address on all 4 procs
		load_addr();	
		//Perform and add operation
		get_alu(0, op_add);
		store_data(addr);
		//4 procs load from the same memory location that was just stored
		load_addr(addr);
      
	endtask


endclass: sequence_load


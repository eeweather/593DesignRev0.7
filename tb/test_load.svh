/*  ECE593 Project 2023wi
*   Victoria Van Gaasbeck <vvan@pdx.edu>
*   Julia Filipchuk <bfilipc2@pdx.edu>
*   Emily Weatherford <ew22@pdx.edu>
*   Daniel Keller <dk27@pdx.edu>
*
*   test_alu for testing alu sequence
*/


class test_load extends test_base;
	`uvm_component_utils(test_load)

	function new(string name, uvm_component parent);
		super.new (name, parent);
	endfunction

	virtual task run_phase(uvm_phase phase);
		
		sequence_load load_0;
		sequence_load load_1;
		sequence_load load_2;
		sequence_load load_3;
		load_0 = new("load_0");
		load_1 = new("load_1");
		load_2 = new("load_2");
		load_3 = new("load_3");

		//set_drain_time gives the test a period of time after stimulus is
		//finished to be processed
		phase.phase_done.set_drain_time(this, 1000);

		phase.raise_objection(this, get_full_name());
		`uvm_info("TEST", "\n\n\n ***LOAD TEST***\n\n\n", UVM_NONE)

		//create the sequence 
		load_0 = sequence_load::type_id::create("load_0");
		load_1 = sequence_load::type_id::create("load_1");
		load_2 = sequence_load::type_id::create("load_2");
		load_3 = sequence_load::type_id::create("load_3");
		fork
			load_0.init_start(envt.agt_0.sqr);
			load_1.init_start(envt.agt_1.sqr);
			load_2.init_start(envt.agt_2.sqr);
			load_3.init_start(envt.agt_3.sqr);
		join
		phase.drop_objection(this, get_full_name());
	endtask: run_phase

endclass: test_load

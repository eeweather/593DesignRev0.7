/*  ECE593 Project 2023wi
*   Victoria Van Gaasbeck <vvan@pdx.edu>
*   Julia Filipchuk <bfilipc2@pdx.edu>
*   Emily Weatherford <ew22@pdx.edu>
*   Daniel Keller <dk27@pdx.edu>
*
*   test add ops
*/


class test_add extends test_base;
	`uvm_component_utils(test_add)

	function new(string name, uvm_component parent);
		super.new (name, parent);
	endfunction

	virtual task run_phase(uvm_phase phase);
		
		sequence_add add_0;
		sequence_add add_1;
		sequence_add add_2;
		sequence_add add_3;
		add_0 = new("add_0");
		add_1 = new("add_1");
		add_2 = new("add_2");
		add_3 = new("add_3");

		//set_drain_time gives the test a period of time after stimulus is
		//finished to be processed
		phase.phase_done.set_drain_time(this, 1000);

		phase.raise_objection(this, get_full_name());
		`uvm_info("TEST", "\n\n\n ***ADD TEST***\n\n\n", UVM_NONE)

		//create the sequence 
		add_0 = sequence_add::type_id::create("add_0");
		add_1 = sequence_add::type_id::create("add_1");
		add_2 = sequence_add::type_id::create("add_2");
		add_3 = sequence_add::type_id::create("add_3");
		fork
			add_0.init_start(envt.agt_0.sqr);
			add_1.init_start(envt.agt_1.sqr);
			add_2.init_start(envt.agt_2.sqr);
			add_3.init_start(envt.agt_3.sqr);
		join
		phase.drop_objection(this, get_full_name());
	endtask: run_phase

endclass: test_add

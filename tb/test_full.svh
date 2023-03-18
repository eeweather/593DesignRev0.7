/*  ECE593 Project 2023wi
*   Victoria Van Gaasbeck <vvan@pdx.edu>
*   Julia Filipchuk <bfilipc2@pdx.edu>
*   Emily Weatherford <ew22@pdx.edu>
*   Daniel Keller <dk27@pdx.edu>
*
*   test_full for running all major sequences and their tasks 
*/


class test_full extends test_base;
	`uvm_component_utils(test_full)

	function new(string name, uvm_component parent);
		super.new (name, parent);
	endfunction

	virtual task run_phase(uvm_phase phase);
		
		sequence_alu alu_0;
		sequence_alu alu_1;
		sequence_alu alu_2;
		sequence_alu alu_3;
		sequence_add add_0;
		sequence_add add_1;
		sequence_add add_2;
		sequence_add add_3;
		sequence_load load_0;
		sequence_load load_1;
		sequence_load load_2;
		sequence_load load_3;
		
		alu_0 = new("alu_0");
		alu_1 = new("alu_1");
		alu_2 = new("alu_2");
		alu_3 = new("alu_3");
		add_0 = new("add_0");
		add_1 = new("add_1");
		add_2 = new("add_2");
		add_3 = new("add_3");
		load_0 = new("load_0");
		load_1 = new("load_1");
		load_2 = new("load_2");
		load_3 = new("load_3");



		//set_drain_time gives the test a period of time after stimulus is
		//finished to be processed
		phase.phase_done.set_drain_time(this, 1000);

		phase.raise_objection(this, get_full_name());
		`uvm_info("TEST", "\n\n\n ***FULL TEST***\n\n\n", UVM_NONE)

		//create the sequences
		alu_0 = sequence_alu::type_id::create("alu_0");
		alu_1 = sequence_alu::type_id::create("alu_1");
		alu_2 = sequence_alu::type_id::create("alu_2");
		alu_3 = sequence_alu::type_id::create("alu_3");
		add_0 = sequence_add::type_id::create("add_0");
		add_1 = sequence_add::type_id::create("add_1");
		add_2 = sequence_add::type_id::create("add_2");
		add_3 = sequence_add::type_id::create("add_3");
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
		fork
			alu_0.init_start(envt.agt_0.sqr);
			alu_1.init_start(envt.agt_1.sqr);
			alu_2.init_start(envt.agt_2.sqr);
			alu_3.init_start(envt.agt_3.sqr);
		join
		fork
			add_0.init_start(envt.agt_0.sqr);
			add_1.init_start(envt.agt_1.sqr);
			add_2.init_start(envt.agt_2.sqr);
			add_3.init_start(envt.agt_3.sqr);
		join



		phase.drop_objection(this, get_full_name());
	endtask: run_phase

endclass: test_full

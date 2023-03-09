/*  ECE593 Project 2023wi
*   Victoria Van Gaasbeck <vvan@pdx.edu>
*   Julia Filipchuk <bfilipc2@pdx.edu>
*   Emily Weatherford <ew22@pdx.edu>
*   Daniel Keller <dk27@pdx.edu>
*
*   Driver gets a sequence_item from the sequencer, and places it onto the
*   virtual interface to wiggle the pins of the DUT
*/
 
class driver extends uvm_driver #(item_base);
	`uvm_component_utils(driver)

function new(string name, uvm_component parent);
	super.new(name, parent);
endfunction


virtual processor_if vif_0;
virtual processor_if vif_1;
virtual processor_if vif_2;
virtual processor_if vif_3;

virtual function void build_phase(uvm_phase phase);
	agent_config agent_cfg;

	//if there isn't an agent_config, it's time to throw a fit (or end simulation, whichever comes first)
	if (!uvm_config_db #(agent_config)::get(this, "", "agent_cfg", agent_cfg)) `uvm_fatal(get_type_name(), "no agent_cfg in uvm_config_db")
	
	//get the virtual interface (tinycpu_bfm) from the agent_config
	vif_0 = agent_cfg.vif_0;
	vif_1 = agent_cfg.vif_1;
	vif_2 = agent_cfg.vif_2;
	vif_3 = agent_cfg.vif_3;

endfunction: build_phase

virtual task run_phase(uvm_phase phase);
	item_base inst;

	vif_0.reset_alu();

	
	forever begin
		//get the next item from the sequencer (through the port) and send it to the DUT using the virtual interface
		seq_item_port.get_next_item(inst);		
		vif_0.send_instruction(inst.inst); 
		seq_item_port.item_done();

	end
endtask: run_phase

endclass: driver

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

virtual tinycpu_bfm vif;

virtual function void build_phase(uvm_phase phase);
	agent_config agent_cfg;

	//if there isn't an agent_config, it's time to throw a fit (or end simulation, whichever comes first)
	if (!uvm_config_db #(agent_config)::get(this, "", "agent_cfg", agent_cfg)) `uvm_fatal(get_type_name(), "no agent_cfg in uvm_config_db")
	
	//get the virtual interface (tinycpu_bfm) from the agent_config
	vif = agent_cfg.vif;

endfunction: build_phase

virtual task run_phase(uvm_phase phase);
	item_base tx;
	int dump;

	//vif.preload_memory(8'hFF, 4'b0); 						//testing preload memory
	//vif.preload_registers(1'b1, 2'b10, 2'b11, 3'b100);		//testing preload registers
	forever begin
		//get the next item from the sequencer (through the port) and send it to the DUT using the virtual interface
		seq_item_port.get_next_item(tx);		
		vif.send_instruction(tx.inst, tx.addr, dump); 
		seq_item_port.item_done();

	end
endtask: run_phase

endclass: driver
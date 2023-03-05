/*  ECE593 Project 2023wi
*   Victoria Van Gaasbeck <vvan@pdx.edu>
*   Julia Filipchuk <bfilipc2@pdx.edu>
*   Emily Weatherford <ew22@pdx.edu>
*   Daniel Keller <dk27@pdx.edu>
*
*   Monitor collects the transactions from the virtual interface
*   (tinycpu_bfm) and places them on the ports for the scoreboard,
*   evaluator, coverage_collector, etc.
*/

class monitor extends uvm_monitor;
	`uvm_component_utils(monitor)

function new(string name, uvm_component parent);
	super.new(name, parent);
endfunction

agent_config agent_cfg;
virtual tinyalu_bfm vif;

uvm_analysis_port #(item_base) dut_in_tx_port;
uvm_analysis_port #(item_base) dut_out_tx_port;

function void build_phase(uvm_phase phase);
	
	//create ports, get virtual interface from agent_config if it exists
	dut_in_tx_port = new("dut_in_tx_port", this);
	dut_out_tx_port = new("dut_out_tx_port", this);
	if (!uvm_config_db #(agent_config)::get(this, "", "agent_cfg", agent_cfg)) `uvm_fatal(get_type_name(), "no agent_cfg in uvm_config_db")
	vif = agent_cfg.vif;

endfunction: build_phase

virtual task run_phase(uvm_phase phase);
//	fork
//		get_inputs();
//		get_outputs();
//	join
endtask: run_phase

virtual task get_inputs();
	item_base tx;
	forever begin
		tx = item_base::type_id::create("tx");
		vif.get_an_input(tx);
		`uvm_info("TX_IN", tx.convert2string(), UVM_DEBUG)
		dut_in_tx_port.write(tx);
	end
endtask: get_inputs

virtual task get_outputs();
	item_base tx;
	forever begin
		tx = item_base::type_id::create("tx");
		vif.get_an_output(tx);
		`uvm_info("TX_OUT", tx.convert2string(), UVM_DEBUG)
		dut_out_tx_port.write(tx);
	end
endtask: get_outputs

virtual function void end_of_elaboration_phase(uvm_phase phase);
	set_report_verbosity_level(agent_cfg.monitor_verbosity);
endfunction: end_of_elaboration_phase

endclass: monitor
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
virtual processor_if vif_0;
virtual processor_if vif_1;
virtual processor_if vif_2;
virtual processor_if vif_3;

uvm_analysis_port #(item_base) dut_in_tx_port;
uvm_analysis_port #(item_base) dut_out_tx_port;

function void build_phase(uvm_phase phase);
	
	//create ports, get virtual interface from agent_config if it exists
	dut_in_tx_port = new("dut_in_tx_port", this);
	dut_out_tx_port = new("dut_out_tx_port", this);
	if (!uvm_config_db #(agent_config)::get(this, "", "agent_cfg", agent_cfg)) `uvm_fatal(get_type_name(), "no agent_cfg in uvm_config_db");
	vif_0 = agent_cfg.vif_0;
	vif_1 = agent_cfg.vif_1;
	vif_2 = agent_cfg.vif_2;
	vif_3 = agent_cfg.vif_3;

endfunction: build_phase

virtual task run_phase(uvm_phase phase);
       get_sample();
endtask: run_phase

virtual task get_sample();
	item_base tx;
	forever begin
		@(posedge vif_0.done) begin
		//@(negedge vif_0.done);
		//@(negedge vif_0.clk);
		tx = item_base::type_id::create("tx");
		vif_0.sample_instruction(tx);
//		`uvm_info("TX_IN", tx.convert2string(), UVM_DEBUG)
	
		//load hack, fix later!
		//it is later, ew 
		// if(tx.inst[INSTR_WIDTH-1:INSTR_WIDTH-4] == op_load) begin
		// 	tx.result = 1'b1;
		// 	tx.A = 1'b0;
		// 	tx.B = 1'b0;
		// end
			
		dut_in_tx_port.write(tx);
		dut_out_tx_port.write(tx);
		end
	end

endtask: get_sample

/*dk3/8
virtual function void end_of_elaboration_phase(uvm_phase phase);
	set_report_verbosity_level(agent_cfg.monitor_verbosity);
endfunction: end_of_elaboration_phase
*/
endclass: monitor

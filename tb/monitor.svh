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

virtual processor_if vif;

//uvm_analysis_port #(item_base) dut_in_tx_port;
uvm_analysis_port #(item_base) dut_out_tx_port;

function void build_phase(uvm_phase phase);
	
	//create ports, get virtual interface from agent_config if it exists
//	dut_in_tx_port = new("dut_in_tx_port", this);
	dut_out_tx_port = new("dut_out_tx_port", this);

endfunction: build_phase

virtual task run_phase(uvm_phase phase);
       get_sample();
endtask: run_phase

virtual task get_sample();
	item_base tx;
	forever begin
		@(posedge vif.done) begin
		tx = item_base::type_id::create("tx");
		vif.sample_instruction(tx);
//		`uvm_info("TX_IN", tx.convert2string(), UVM_DEBUG)
	
		//load hack, fix later!
		// if(tx.inst[INSTR_WIDTH-1:INSTR_WIDTH-4] == op_load) begin
		// 	tx.result = 1'b1;
		// 	tx.A = 1'b0;
		// 	tx.B = 1'b0;
		// end
			
//		dut_in_tx_port.write(tx);
		dut_out_tx_port.write(tx);
		end
	end

endtask: get_sample

endclass: monitor

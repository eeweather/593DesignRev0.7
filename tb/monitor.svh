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

uvm_analysis_port #(item_base) dut_out_tx_port;

function void build_phase(uvm_phase phase);
	
	//create ports, get virtual interface from agent_config if it exists
	dut_out_tx_port = new("dut_out_tx_port", this);

endfunction: build_phase

virtual task run_phase(uvm_phase phase);
       get_sample();
endtask: run_phase

virtual task get_sample();
	item_base tx;
	item_base memtx;
	forever begin
		tx = item_base::type_id::create("tx");
		memtx = item_base::type_id::create("memtx");
		@(posedge vif.mem_resp) begin
			if(get_full_name() == "uvm_test_top.envt.agt_0.mon") memtx.mon_num = 0;
			else if(get_full_name() == "uvm_test_top.envt.agt_1.mon") memtx.mon_num = 1;
			else if(get_full_name() == "uvm_test_top.envt.agt_2.mon") memtx.mon_num = 2;
			else if(get_full_name() == "uvm_test_top.envt.agt_3.mon") memtx.mon_num = 3;
			else tx.mon_num = 99;
			vif.sample_instruction(memtx);
			//memtx.loadlog = 0;
		end
		if(memtx.inst[18:15] == 4'b1001 || memtx.inst[18:15] == 4'b1000) begin
		dut_out_tx_port.write(memtx);
		end
	 else begin
		@(posedge vif.done) begin
		if(get_full_name() == "uvm_test_top.envt.agt_0.mon") tx.mon_num = 0;
		else if(get_full_name() == "uvm_test_top.envt.agt_1.mon") tx.mon_num = 1;
		else if(get_full_name() == "uvm_test_top.envt.agt_2.mon") tx.mon_num = 2;
		else if(get_full_name() == "uvm_test_top.envt.agt_3.mon") tx.mon_num = 3;
		else tx.mon_num = 99;
		vif.sample_instruction(tx);
//		`uvm_info("TX_IN", tx.convert2string(), UVM_DEBUG)

        // if(tx.inst[18:15] == 4'b1001) begin
		// 	tx=memtx;
		// end
	    //tx.loadlog = 1;
		dut_out_tx_port.write(tx);
		end
	end
	end

endtask: get_sample

endclass: monitor

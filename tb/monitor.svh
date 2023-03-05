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

   virtual tinyalu_bfm bfm;
   uvm_analysis_port #(result_transaction) ap;

function void build_phase(uvm_phase phase);
	
      if(!uvm_config_db #(virtual tinyalu_bfm)::get(null, "*","bfm", bfm))
        `uvm_fatal("DRIVER", "Failed to get BFM");
      ap  = new("ap",this);

endfunction: build_phase

virtual task run_phase(uvm_phase phase);
//	fork
//		get_inputs();
//		get_outputs();
//	join
endtask: run_phase


   function void connect_phase(uvm_phase phase);
      bfm.monitor_h = this;
   endfunction : connect_phase

   function void write_to_monitor(instruction_t instr);
   
      sequence_item instr;
      `uvm_info ("COMMAND MONITOR", $sformatf("MONITOR: instr: %19b",
                instr), UVM_HIGH);
      instr = new("instr");

      ap.write(instr);
   endfunction : write_to_monitor


endclass: monitor
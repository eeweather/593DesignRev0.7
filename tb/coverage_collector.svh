/*  ECE593 Project 2023wi
*   Victoria Van Gaasbeck <vvan@pdx.edu>
*   Julia Filipchuk <bfilipc2@pdx.edu>
*   Emily Weatherford <ew22@pdx.edu>
*   Daniel Keller <dk27@pdx.edu>
*
*   coverage_collector collects functional coverage numbers based on the
*   covergroup cg. the report_phase prints the percentage.
*/
 
class coverage_collector extends uvm_subscriber #(item_base);
	`uvm_component_utils(coverage_collector)

	item_base tx, pv;
	covergroup cg; 
		ops: coverpoint tx.inst[INSTR_WIDTH-1:INSTR_WIDTH-4] { 
			bins b_nop = {op_nop};
			bins b_add = {op_add};
			bins b_and = {op_and};
			bins b_xor = {op_xor};
			bins b_mul = {op_mul};
			bins b_sp0 = {op_sp0};
			bins b_sp1 = {op_sp1};
			bins b_sp2 = {op_sp2};
			bins b_load = {op_load};
			bins b_store = {op_store};
			bins b_shl = {op_shl};
			bins b_shr = {op_shr};
			ignore_bins b_res1 = {op_res1};
			ignore_bins b_res2 = {op_res2};
			ignore_bins b_res3 = {op_res3};
			bins nop1 = {op_nop1};
			}

		procs: coverpoint tx.mon_num {
			bins b_proc0 = {0};
			bins b_proc1 = {1};
			bins b_proc2 = {2};
			bins b_proc3 = {3};
			bins b_error = default;
		}


      		ALU_A: coverpoint tx.A {
         		bins b_zero = {'h00};
			bins b_single_dig = {['h01:'hF]};
			bins b_double_dig = {['h10:'hFE]};
		        bins b_max = {'hFF};
      		}

     		ALU_B: coverpoint tx.B {
         		bins b_zero = {'h00};
			bins b_single_dig = {['h01:'hF]};
			bins b_double_dig = {['h10:'hFE]};
		        bins b_max = {'hFF};
      		}


		io: coverpoint tx.inst[14:1] {
			bins b_addrs[] = {[0:$]};
		}

		mem_prio_0: coverpoint((pv.mon_num == 0 && pv.inst[INSTR_WIDTH-1:INSTR_WIDTH-4] == op_load 
				   &&   tx.mon_num != 0 && tx.inst[INSTR_WIDTH-1:INSTR_WIDTH-4] == op_load
				   &&   tx.inst[14:1] == pv.inst[14:1])
				   ||  (pv.mon_num == 0 && pv.inst[INSTR_WIDTH-1:INSTR_WIDTH-4] == op_store 
				   &&   tx.mon_num != 0 && tx.inst[INSTR_WIDTH-1:INSTR_WIDTH-4] == op_store
				   &&   tx.inst[14:1] == pv.inst[14:1])){
			bins caught = {'h1};	
      			ignore_bins ignore = {'h0};		
		}	

		mem_prio_1: coverpoint((pv.mon_num == 1 && pv.inst[INSTR_WIDTH-1:INSTR_WIDTH-4] == op_load 
				   &&   tx.mon_num != 1 && tx.inst[INSTR_WIDTH-1:INSTR_WIDTH-4] == op_load
				   &&   tx.inst[14:1] == pv.inst[14:1])
				   ||  (pv.mon_num == 1 && pv.inst[INSTR_WIDTH-1:INSTR_WIDTH-4] == op_store 
				   &&   tx.mon_num != 1 && tx.inst[INSTR_WIDTH-1:INSTR_WIDTH-4] == op_store
				   &&   tx.inst[14:1] == pv.inst[14:1])){
			bins caught = {'h1};	
      			ignore_bins ignore = {'h0};		
		}

		mem_prio_2: coverpoint((pv.mon_num == 2 && pv.inst[INSTR_WIDTH-1:INSTR_WIDTH-4] == op_load 
				   &&   tx.mon_num != 2 && tx.inst[INSTR_WIDTH-1:INSTR_WIDTH-4] == op_load
				   &&   tx.inst[14:1] == pv.inst[14:1])
				   ||  (pv.mon_num == 2 && pv.inst[INSTR_WIDTH-1:INSTR_WIDTH-4] == op_store 
				   &&   tx.mon_num != 2 && tx.inst[INSTR_WIDTH-1:INSTR_WIDTH-4] == op_store
				   &&   tx.inst[14:1] == pv.inst[14:1])){
			bins caught = {'h1};	
      			ignore_bins ignore = {'h0};		
		}	

		mem_prio_3: coverpoint((pv.mon_num == 3 && pv.inst[INSTR_WIDTH-1:INSTR_WIDTH-4] == op_load 
				   &&   tx.mon_num != 3 && tx.inst[INSTR_WIDTH-1:INSTR_WIDTH-4] == op_load
				   &&   tx.inst[14:1] == pv.inst[14:1])
				   ||  (pv.mon_num == 3 && pv.inst[INSTR_WIDTH-1:INSTR_WIDTH-4] == op_store 
				   &&   tx.mon_num != 3 && tx.inst[INSTR_WIDTH-1:INSTR_WIDTH-4] == op_store
				   &&   tx.inst[14:1] == pv.inst[14:1])){
			bins caught = {'h1};	
      			ignore_bins ignore = {'h0};		
		}	
		
	endgroup : cg

function new(string name, uvm_component parent);
	super.new(name, parent);
	cg = new();
endfunction

virtual function void write(input item_base t);
	this.tx = t;
	pv = tx;
	cg.sample();
endfunction: write

virtual function void report_phase(uvm_phase phase);
	`uvm_info("COVERAGE", $sformatf("\n\nFUNCTIONAL COVERAGE: = %2.2f%%\n", cg.get_coverage()), UVM_NONE)
endfunction: report_phase

endclass : coverage_collector

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

	item_base tx, pv_0, pv_1, pv_2, pv_3;
	covergroup cg;
	        //coverpoint for opcodes	
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
		//coverpoint for processors
		procs: coverpoint tx.mon_num {
			bins b_proc0 = {0};
			bins b_proc1 = {1};
			bins b_proc2 = {2};
			bins b_proc3 = {3};
			bins b_error = default;
		}

		//coverpoints for operand variety
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

		//coverpoint for addresses
		io: coverpoint tx.inst[14:1] {
			bins b_addrs[] = {[0:$]};
		}
		
		//four coverpoints for memory accesses to same addresses,
		//ensuring memory priority is tested
		mem_prio_0: coverpoint(
				          (tx.inst[INSTR_WIDTH-1:INSTR_WIDTH-4] == op_load
				      && pv_1.inst[INSTR_WIDTH-1:INSTR_WIDTH-4] == op_load
				      && tx.inst[14:1] == pv_1.inst[14:1]) 
				    
				      ||  (tx.inst[INSTR_WIDTH-1:INSTR_WIDTH-4] == op_load
				      && pv_2.inst[INSTR_WIDTH-1:INSTR_WIDTH-4] == op_load
				      && tx.inst[14:1] == pv_2.inst[14:1]) 
				      
				      ||  (tx.inst[INSTR_WIDTH-1:INSTR_WIDTH-4] == op_load
				      && pv_3.inst[INSTR_WIDTH-1:INSTR_WIDTH-4] == op_load
				      && tx.inst[14:1] == pv_3.inst[14:1]) 
				       ){
				       bins caught = {1'h1};
				       ignore_bins ignore = {1'h0};
	       }

		mem_prio_1: coverpoint(
				          (tx.inst[INSTR_WIDTH-1:INSTR_WIDTH-4] == op_load
				      && pv_0.inst[INSTR_WIDTH-1:INSTR_WIDTH-4] == op_load
				      && tx.inst[14:1] == pv_0.inst[14:1]) 
				    
				      ||  (tx.inst[INSTR_WIDTH-1:INSTR_WIDTH-4] == op_load
				      && pv_2.inst[INSTR_WIDTH-1:INSTR_WIDTH-4] == op_load
				      && tx.inst[14:1] == pv_2.inst[14:1]) 
				      
				      ||  (tx.inst[INSTR_WIDTH-1:INSTR_WIDTH-4] == op_load
				      && pv_3.inst[INSTR_WIDTH-1:INSTR_WIDTH-4] == op_load
				      && tx.inst[14:1] == pv_3.inst[14:1]) 
				       ){
				       bins caught = {1'h1};
				       ignore_bins ignore = {1'h0};
	       }

		mem_prio_2: coverpoint(
				          (tx.inst[INSTR_WIDTH-1:INSTR_WIDTH-4] == op_load
				      && pv_0.inst[INSTR_WIDTH-1:INSTR_WIDTH-4] == op_load
				      && tx.inst[14:1] == pv_0.inst[14:1]) 
				    
				      ||  (tx.inst[INSTR_WIDTH-1:INSTR_WIDTH-4] == op_load
				      && pv_1.inst[INSTR_WIDTH-1:INSTR_WIDTH-4] == op_load
				      && tx.inst[14:1] == pv_1.inst[14:1]) 
				      
				      ||  (tx.inst[INSTR_WIDTH-1:INSTR_WIDTH-4] == op_load
				      && pv_3.inst[INSTR_WIDTH-1:INSTR_WIDTH-4] == op_load
				      && tx.inst[14:1] == pv_3.inst[14:1]) 
				       ){
				       bins caught = {1'h1};
				       ignore_bins ignore = {1'h0};
	       }

		mem_prio_3: coverpoint(
				          (tx.inst[INSTR_WIDTH-1:INSTR_WIDTH-4] == op_load
				      && pv_0.inst[INSTR_WIDTH-1:INSTR_WIDTH-4] == op_load
				      && tx.inst[14:1] == pv_0.inst[14:1]) 
				    
				      ||  (tx.inst[INSTR_WIDTH-1:INSTR_WIDTH-4] == op_load
				      && pv_1.inst[INSTR_WIDTH-1:INSTR_WIDTH-4] == op_load
				      && tx.inst[14:1] == pv_1.inst[14:1]) 
				      
				      ||  (tx.inst[INSTR_WIDTH-1:INSTR_WIDTH-4] == op_load
				      && pv_2.inst[INSTR_WIDTH-1:INSTR_WIDTH-4] == op_load
				      && tx.inst[14:1] == pv_2.inst[14:1]) 
				       ){
				       bins caught = {1'h1};
				       ignore_bins ignore = {1'h0};
	       }


	endgroup : cg

function new(string name, uvm_component parent);
	super.new(name, parent);
	cg = new();
	//create the pv items so no segfault when comparing first few
	pv_0 = item_base::type_id::create("pv_0");
	pv_1 = item_base::type_id::create("pv_1");
	pv_2 = item_base::type_id::create("pv_2");
	pv_3 = item_base::type_id::create("pv_3");
endfunction

virtual function void write(input item_base t);
	this.tx = t;
	//set previous transactions for mem_prio coverpoints
	case(tx.mon_num)
		0: pv_0 = tx;
		1: pv_1 = tx;
		2: pv_2 = tx;
		3: pv_3 = tx;
	endcase
	cg.sample();
endfunction: write

virtual function void report_phase(uvm_phase phase);
	`uvm_info(get_type_name(), $sformatf("\n\nFUNCTIONAL COVERAGE: = %2.2f%%\n", cg.get_coverage()), UVM_NONE)
endfunction: report_phase

endclass : coverage_collector

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

	item_base tx;
	covergroup op_cov; 
		coverpoint tx.inst[15:12] { 
			bins single_cycle[] = {[op_add:op_xor], op_nop, op_nop1, op_shl, op_shr};
       			bins multi_cycle[] = {[op_mul:op_sp2]};
         		bins io_cycle[] = {op_load, op_store};
         		bins illegal_cycle[] = {[op_res1:op_res3]};

         		bins opn_rst[] = ([op_add:op_res3] => (op_res1 || op_res2 || op_res3));
         		bins rst_opn[] = (op_res1 || op_res2 || op_res3 => [op_nop:op_shr]);

         		bins twoops[] = ([op_add:op_nop1] [* 2]);
         		bins manyillegal = ([op_res1:op_res3] [* 3:5]);

         		bins wr[] = (op_load,op_store => op_load,op_store);
         		bins wwr[] = (op_store[* 2] => op_load);
         		bins rrw[] = (op_load[* 2] => op_store);
  
			}
	endgroup : op_cov

	covergroup zero_or_ones_on_ops;
		all_ops : coverpoint tx.inst[15:12] {
         	 	ignore_bins null_ops = {op_nop, op_nop1, op_res1, op_res2, op_res3};
		}

      		a_leg: coverpoint tx.A {
         		bins zeros = {'h00};
		        bins others= {['h01:'hFE]};
         		bins ones  = {'hFF};
      		}

     		b_leg: coverpoint tx.B {
         		bins zeros = {'h00};
         		bins others= {['h01:'hFE]};
         		bins ones  = {'hFF};
      		}

      		op_00_FF:  cross a_leg, b_leg, all_ops {
         		bins add_00 = binsof (all_ops) intersect {op_add} &&
                       (binsof (a_leg.zeros) || binsof (b_leg.zeros));

         		bins add_FF = binsof (all_ops) intersect {op_add} &&
                       (binsof (a_leg.ones) || binsof (b_leg.ones));

         		bins and_00 = binsof (all_ops) intersect {op_and} &&
                       (binsof (a_leg.zeros) || binsof (b_leg.zeros));

         		bins and_FF = binsof (all_ops) intersect {op_and} &&
                       (binsof (a_leg.ones) || binsof (b_leg.ones));

         		bins xor_00 = binsof (all_ops) intersect {op_xor} &&
                       (binsof (a_leg.zeros) || binsof (b_leg.zeros));

         		bins xor_FF = binsof (all_ops) intersect {op_xor} &&
                       (binsof (a_leg.ones) || binsof (b_leg.ones));

         		bins mul_00 = binsof (all_ops) intersect {op_mul} &&
                       (binsof (a_leg.zeros) || binsof (b_leg.zeros));

         		bins mul_FF = binsof (all_ops) intersect {op_mul} &&
                       (binsof (a_leg.ones) || binsof (b_leg.ones));

         		bins sp0_00 = binsof (all_ops) intersect {op_sp0} &&
                       (binsof (a_leg.zeros) || binsof (b_leg.zeros));

         		bins sp0_FF = binsof (all_ops) intersect {op_sp0} &&
                       (binsof (a_leg.ones) || binsof (b_leg.ones));

         		bins sp1_00 = binsof (all_ops) intersect {op_sp1} &&
                        binsof (a_leg.zeros);

         		bins sp1_FF = binsof (all_ops) intersect {op_sp1} &&
                        binsof (a_leg.ones);

         		bins sp2_00 = binsof (all_ops) intersect {op_sp2} &&
                        binsof (a_leg.zeros);

         		bins sp2_FF = binsof (all_ops) intersect {op_sp2} &&
                        binsof (a_leg.ones);
         		
	       		bins shl_00 = binsof (all_ops) intersect {op_shl} &&
                        binsof (a_leg.zeros);

         		bins shl_FF = binsof (all_ops) intersect {op_shl} &&
                        binsof (a_leg.ones);
	       		
			bins shr_00 = binsof (all_ops) intersect {op_shr} &&
                        binsof (a_leg.zeros);

         		bins shr_FF = binsof (all_ops) intersect {op_shr} &&
                        binsof (a_leg.ones);
		
			ignore_bins others_only = binsof(a_leg.others) && binsof(b_leg.others);

      }
	endgroup : zero_or_ones_on_ops


function new(string name, uvm_component parent);
	super.new(name, parent);
	op_cov = new();
	zero_or_ones_on_ops = new();
endfunction

virtual function void write(input item_base t);
	this.tx = t;
	op_cov.sample();
	zero_or_ones_on_ops.sample();
endfunction: write

virtual function void report_phase(uvm_phase phase);
	`uvm_info("COVERAGE", $sformatf("\n\nFUNCTIONAL COVERAGE:\n  op_cov = %2.2f%%\tzero_or_ones_on_ops = %2.2f%%\n", op_cov.get_coverage, zero_or_ones_on_ops.get_coverage()), UVM_NONE)
endfunction: report_phase

endclass : coverage_collector

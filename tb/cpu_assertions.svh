/*  ECE593 Project 2023wi
*   Victoria Van Gaasbeck <vvan@pdx.edu>
*   Julia Filipchuk <bfilipc2@pdx.edu>
*   Emily Weatherford <ew22@pdx.edu>
*   Daniel Keller <dk27@pdx.edu>
*
*   system assertions
*/
 

//TODO: these assertions will need to change as the design progresses!


//three assertions for ensuring timing requirements
one_cycle_assert : assert property(
	@(posedge bfm.clk) disable iff(!bfm.reset_n || bfm.alu.done || !bfm.alu.start || !(bfm.op_set inside {op_nop, op_add, op_and, op_xor, op_or, op_nop1, op_res1, op_res2, op_res3, op_rst}))
        bfm.alu.start |-> ##1 bfm.alu.done
	) else $error ("one cycle timing violation with op_set = %s", bfm.op_set);	

three_cycle_assert : assert property(
	@(posedge bfm.clk) disable iff(!bfm.reset_n || bfm.alu.done || !bfm.alu.start || !(bfm.op_set inside {op_mul, op_sp1, op_sp2, op_load, op_store}))
        bfm.alu.start |-> ##3 bfm.alu.done
	) else $error ("three cycle timing violation with op_set = %s", bfm.op_set);	

four_cycle_assert : assert property(
	@(posedge bfm.clk) disable iff(!bfm.reset_n || bfm.alu.done || !bfm.alu.start || !(bfm.op_set == op_sp0))
        bfm.alu.start |-> ##4 bfm.alu.done
	) else $error ("four cycle timing violation with op_set = %s", bfm.op_set);
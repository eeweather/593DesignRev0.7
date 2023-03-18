/*  ECE593 Project 2023wi
*   Victoria Van Gaasbeck <vvan@pdx.edu>
*   Julia Filipchuk <bfilipc2@pdx.edu>
*   Emily Weatherford <ew22@pdx.edu>
*   Daniel Keller <dk27@pdx.edu>
*
*   predictor with access to C code predictor through DPI-C to send expected
*   results to evaluator
*/

import "DPI-C" function shortint c_predictor(byte unsigned a, byte unsigned b, instruction_t instruction, logic [15:0] resultInput, logic [15:0] mem_data);


class predictor extends uvm_subscriber #(item_base);
	`uvm_component_utils(predictor)

function new(string name, uvm_component parent);
	super.new(name, parent);
endfunction


uvm_analysis_port #(item_base) expected_port;
int resultpre;


virtual function void build_phase(uvm_phase phase);
	expected_port = new("expected_port", this);
endfunction: build_phase

virtual function void write(input item_base t);
	item_base predicted;
	predicted = item_base::type_id::create("predicted");
	
	predicted.inst = t.inst;
	predicted.A = t.A;
	predicted.B = t.B;
	predicted.mem_data = t.mem_data;

	if(t.inst[18:15]==op_load) begin
		predicted.mem_data= c_predictor(t.A, t.B, t.inst, t.result, t.mem_data);
		predicted.result = t.result;
	
	end 
	else if(t.inst[18:15]==op_store) begin
		//need to call function so store is logged in tb memory
		resultpre = c_predictor(t.A, t.B, t.inst, t.result, t.mem_data);
		//only way to check store is with a load, so dont trigger mismatch
		if(resultpre != -1) predicted = t;
	end 
	else if(t.inst[18:15] == op_nop || t.inst[18:15] == op_nop1 || t.inst[18:15] == op_res1 || t.inst[18:15] == op_res2 || t.inst[18:15] == op_res3) begin
	    	//nothing happens on nop, nothing to check
		predicted = t;
	end
	else predicted.result = c_predictor(t.A, t.B, t.inst, t.result, t.mem_data);
          expected_port.write(predicted);
endfunction: write


endclass: predictor

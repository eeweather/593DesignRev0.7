/*UVM predictor (predictor.svh)
 */

import "DPI-C" function shortint c_predictor(byte unsigned a, byte unsigned b, instruction_t instruction, logic [15:0] resultInput);


class predictor extends uvm_subscriber #(item_base);
	`uvm_component_utils(predictor)

function new(string name, uvm_component parent);
	super.new(name, parent);
endfunction


uvm_analysis_port #(item_base) expected_port;


virtual function void build_phase(uvm_phase phase);
	expected_port = new("expected_port", this);
endfunction: build_phase

virtual function void write(input item_base t);
//need to recreate predictor functionality
	item_base predicted;
	predicted = item_base::type_id::create("predicted");
	
	predicted.inst = t.inst;
	predicted.A = t.A;
	predicted.B = t.B;


	if(t.inst[18:15]==op_load) begin
	    if(t.inst[0]==0) predicted.A = c_predictor(t.A, t.B, t.inst, t.result);
		else predicted.B = c_predictor(t.A, t.B, t.inst, t.result);
		predicted.result = t.result;
	end 
	else if(t.inst[18:15]==op_store) begin
		//need to call function so store is logged in tb memory
		predicted.result = c_predictor(t.A, t.B, t.inst, t.result);
		//only way to check store is with a load, so dont trigger mismatch
		predicted = t;
	end 
	else predicted.result = c_predictor(t.A, t.B, t.inst, t.result);


/*
	case (t.inst[18:15]) 
	// //this is largely placeholder and needs to be finished. def implementation questions here
                op_add: predicted.result = t.A + t.B;  //to do need to get data in the specified register, this implentation is not correct
                op_and: predicted.result = t.A & t.B;
                op_xor: predicted.result = t.A ^ t.B;
                op_mul: predicted.result = t.A * t.B;
	            op_sp0: predicted.result = t.A + (2 * t.B);	
	            op_sp1: predicted.result = t.A * 2;
	            op_sp2: predicted.result = t.A * 3;
	            op_shl: predicted.result = t.A << 3;
				op_shr: predicted.result = t.A >> 3;
		    op_load: begin 
		    	predicted.result = 1'b1; //hack, fix later!
			predicted.A = 1'b0;
			predicted.B = 1'b0;
		end
	 	        op_res1, op_res2, op_res3: predicted.result = 1'b1;
             endcase
*/
          expected_port.write(predicted);
endfunction: write


endclass: predictor

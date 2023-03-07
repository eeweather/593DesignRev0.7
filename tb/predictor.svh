/*UVM predictor (predictor.svh)
 */

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
	 	        op_res1, op_res2, op_res3: predicted.result = 1'b1;
             endcase
	expected_port.write(predicted);
endfunction: write


endclass: predictor

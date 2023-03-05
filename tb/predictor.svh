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
	// case (t.inst[15:12]) 
	// //this is largely placeholder and needs to be finished. def implementation questions here
    //             op_add: predicted.inst[11:10] = t.inst[9:8] + t.inst[7:6];  //to do need to get data in the specified register, this implentation is not correct
    //             op_and: predicted.inst[11:10] = t.inst[9:8] & t.inst[7:6];
    //             op_xor: predicted.inst[11:10] = t.inst[9:8] ^ t.inst[7:6];
    //             op_mul: predicted.inst[11:10] = t.inst[9:8] * t.inst[7:6];
	//             op_sp0: predicted.result = t.inst[9:8] + (2 * t.inst[7:6]);	
	//             op_sp1: predicted.result = t.inst[9:8] * 2;
	//             op_sp2: predicted.result = t.inst[9:8] * 3;
	// 	        op_res1, op_res2, op_res3: predicted.result = 1'b1;
    //         endcase
	expected_port.write(predicted);
endfunction: write


endclass: predictor

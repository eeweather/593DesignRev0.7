import tinyalu_pkg::*;

module ALU593 (
    input clk, reset_n,
	input logic [7:0] A, B,
	input alu_opcode_t op,
	input bit start,
	output logic [15:0] result,
	output bit done,
	output bit error   	
);


	logic [15:0] result_single, result_multi;
	bit        start_single, start_multi;
	bit 		 done_single, done_multi;


	single_cycle alu_single (.A(A), .B(B), .op(op), .clk(clk), .reset_n(reset_n), .start(start_single), .done(done_single), .result(result_single));
	multi_cycle  alu_multi  (.A(A), .B(B), .op(op), .clk(clk), .reset_n(reset_n), .start(start_multi), .done(done_multi), .result(result_multi));
	
	always_comb begin
		case(op)
			op_mul, op_sp0, op_sp1, op_sp2: begin
				start_multi = start;
				done = done_multi;
				result = result_multi;
				error = '0;
			end
			op_res1, op_res2, op_res3: begin
				error = '1;
				done = '1;
			end
			default : begin
				start_single = start;
				done = done_single;
				result = result_single;
				error = '0;
				start_multi = '0;
			end
		endcase

	end 


endmodule : ALU593


module single_cycle (input [7:0] A,
			input [7:0] B,
			input alu_opcode_t  op,
			input clk,
			input reset_n,
			input start,
			output bit done,
			output logic [15:0] result);

  	always_ff @(posedge clk) begin
		if (!reset_n) begin
			result <= 0;
		end
		else
			case(op)
				op_add : result <= A + B;
				op_and : result <= A & B;
				op_xor : result <= A ^ B;
				op_shl : result <= A << 3;
				op_shr : result <= A >> 3;
//				op_nop : //do nothing
				default : result <= 'x;
			endcase // case (op)
	end
   	
	always_ff @(posedge clk) begin
    	if (!reset_n)
       		done <= 0;
     	else
      		// done =  ((start == 1'b1) && (op != op_nop) && (op != op_nop1));
      		done =  ((start == 1'b1));
	end
endmodule : single_cycle

module multi_cycle (input [7:0] A,
			input [7:0] B,
			input alu_opcode_t  op,
			input clk,
			input reset_n,
			input start,
			output bit done,
			output logic [15:0] result);

	logic [ 7:0] a_int, b_int;
	logic [15:0] mult1, mult2;
	bit        done1, done2, done3;
	logic        is_4cycle;
	
	assign is_4cycle = (op == op_sp0);

	always_ff @(posedge clk) begin 
    	if (!reset_n) begin
			done  <= 0;
			done3 <= 0;
			done2 <= 0;
			done1 <= 0;
			a_int <= 0;
			b_int <= 0;
			mult1 <= 0;
			mult2 <= 0;
			result <= 0;
		end 
		else begin // Pipeline Stage 1
			a_int  <= A;
			b_int  <= B;
			done3  <= start & !done;
			// Pipeline Stage 2
			case (op)
				op_mul:
					mult1  <= a_int * b_int;
				op_sp0:
					mult1  <= 2 * b_int;
				op_sp1:
					mult1  <= 2 * a_int;
				op_sp2:
					mult1  <= 3 * a_int;
				default:
					mult1  <= mult1;
			endcase
			done2  <= done3 & !done;
			// Pipeline Stage 3
			case (op)
				op_sp0:
					mult2  <= a_int + mult1;
				default:
					mult2  <= mult1;
			endcase
			done1  <= done2 & ~done;		
			if (~is_4cycle) begin
				result <= mult1;
				done   <= done2 & !done;
			end
			// Pipeline Stage 4
			if (is_4cycle) begin
				result <= mult2;
				done <= done1 & !done;
			end
		end 
	end

endmodule : multi_cycle



   

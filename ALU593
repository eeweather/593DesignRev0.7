
module tinyalu (
    input clk, reset_n,
	alu_if alu,
    io_if io
);

    reg overflow; // Stores overflow state for last instruction.

    alu_inp_if inp(.op(alu.op), .A(alu.A), .B(alu.B));

	logic [15:0] result_aax, result_multi, result_io;
	logic        start_aax, start_multi, start_io;

	single_cycle sub_alu_single (.clk, .reset_n, .inp(inp.ALU), .start(start_aax),   .done(done_aax),   .result(result_aax));
	multi_cycle  sub_alu_multi  (.clk, .reset_n, .inp(inp.ALU), .start(start_multi), .done(done_multi), .result(result_multi));
	io_cycle     sub_alu_io     (.clk, .reset_n, .inp(inp.ALU), .start(start_io),    .done(done_io),    .result(result_io), .io);
        
    always_ff @(posedge clk) begin
        if (reset_n) begin
            overflow <= '0;
        end
        else if (alu.error) begin
            overflow <= '0;
        end
        else if (alu.done) begin // Update on done.
            overflow <= (alu.result[15:8] == 0);
        end
    end

	always_comb begin
		{alu.done, alu.result, alu.error} = '0;
		{start_aax, start_multi, start_io} = '0;

        alu.overflow = overflow; // Overflow set from local state value.

		unique case (inp.op)
			op_res1, op_res2, op_res3: begin
				alu.error = 1;
				// $display("ERROR: Illegal opcode detected");
			end
			op_nop, op_nop1, op_rst: begin
				alu.done = 0; // Don't signal done for NOP opearations.
				alu.result = '0;
			end
			op_mul, op_sp0, op_sp1, op_sp2: begin
				start_multi = alu.start;
				alu.done = done_multi;
				alu.result = result_multi;
			end
			op_load, op_store: begin
				start_io = alu.start;
				alu.done = done_io;
				alu.result = result_io;
			end
			default: begin
				start_aax = alu.start;
				alu.done = done_aax;
				alu.result = result_aax;
			end
		endcase
	end
endmodule : tinyalu

module io_cycle(
    input clk, reset_n,
	alu_inp_if inp,
	input logic start,
	output logic done,
	output logic [15:0] result,
	io_if io
);

	assign io.addr = inp.A;
	assign io.data = io.wr ? inp.B : 'z;

	always_ff @(posedge clk) if (!reset_n) begin
		{done, io.rd, io.wr} <= '0;
	end
	else begin
		io.rd <= 0;
		io.wr <= 0;

		if (start && inp.op == op_store) begin
			// Write value at B into address at A. By connection to 'mem'.
			io.wr <= start & ~io.wr & ~io.ack;
		end
		else if (start && inp.op == op_load) begin
			// Write memory at addr A into Result.
			io.rd <= start & ~io.rd & ~io.ack;
			result <= (io.ack) ? io.data : '0;
			//$display("io_cycle op: %s, rd: %b, wr: %b, ack: %b, data %2h", op, io.rd, io.wr, io.ack, io.data);
		end

		done <= io.ack;

	end
	
endmodule


module single_cycle(
    input clk, reset_n,
	alu_inp_if inp,
	input logic start,
	output logic done,
	output logic [15:0] result
);

	always_ff @(posedge clk) if (!reset_n) begin
		result <= 0;
		done <= 0;
	end
	else begin
		case(inp.op)
			op_add : result <= inp.A + inp.B;
			op_and : result <= inp.A & inp.B;
			op_xor : result <= inp.A ^ inp.B;
			op_or  : result <= inp.A | inp.B;
			op_rst : result <= '0;
			default : result <= '0;
		endcase // case (op)
		done <= start;
	end

endmodule : single_cycle


module multi_cycle(
    input clk, reset_n,
	alu_inp_if inp,
	input logic start,
	output logic done,
	output logic [15:0] result
);

	logic [ 7:0] a_int, b_int;
	logic [15:0] mult1, mult2;
	logic        done1, done2, done3;
	logic        is_4cycle;

	assign is_4cycle = (inp.op == op_sp0);

	always_ff @(posedge clk) if (!reset_n) begin
		{a_int, b_int} <= '0;
		{done3, done2, done1, done} <= '0;
		{mult1, mult2, result} <= '0;
	end else begin // if (!reset_n)
		// Pipeline Stage 1
		a_int  <= inp.A;
		b_int  <= inp.B;
		done3  <= start & !done;

		// Pipeline Stage 2
		case (inp.op)
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
		case (inp.op)
			op_sp0:
				mult2  <= a_int + mult1;
			default:
				mult2  <= mult1;
		endcase
		done1  <= done2 & !done;

		if (~is_4cycle) begin
			result <= mult1;
			done   <= done2 & !done;
		end

		// Pipeline Stage 4
		if (is_4cycle) begin
			result <= mult2;
			done   <= done1 & !done;
		end
	end

endmodule : multi_cycle

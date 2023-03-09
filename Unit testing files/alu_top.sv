import tinyalu_pkg::*;

module alu_top();


   byte         unsigned        A;
   byte         unsigned        B;
   bit          clk;
   bit          reset_n;
   alu_opcode_t  op;
   bit          start;
   bit         done;
   logic [15:0]  result;
   alu_opcode_t  op_set;
   bit error;

   assign op = op_set;

 
   ALU593 DUT (.clk(clk), .reset_n(reset_n), .A(A), .B(B), .op(op), .start(start), .done(done), .result(result), .error(error));


   initial begin
      clk = 0;
      forever begin
         #10;
         clk = ~clk;
      end
   end
  

   function alu_opcode_t get_op();
      bit [3:0] op_choice;
      op_choice = $urandom;
      case (op_choice)
        4'b0000 : return op_nop;
        4'b0001 : return op_add; // Add A, B
        4'b0010 : return op_and; // And A, B
        4'b0011 : return op_xor;  // Or  A, B
        4'b0100 : return op_mul; // Multiply A, B      (multicycle)
        4'b0101 : return op_sp0; // Function A + 2 * B (multicycle)
        4'b0110 : return op_sp1; // Function 2 * A     (multicycle)
        4'b0111 : return op_sp2; // Function 3 * A     (multicycle)
        4'b1000 : return op_load; //load memory to register
        4'b1001 : return op_store; //store register to memory
        4'b1010 : return op_shl; //reserved 'illegal state' op_codes
        4'b1011 : return op_shr; //for the sake of memory not being erased every random reset, replacing with op_nop
        4'b1100 : return op_res1;
        4'b1101 : return op_res2;
        4'b1110 : return op_res3; // use on reserved op code as a reset
        4'b1111 : return op_nop1;
        default : return op_add;
      endcase // case (op_choice)
   endfunction : get_op

   function byte get_data();
      bit [1:0] zero_ones;
      zero_ones = $random;
      if (zero_ones == 2'b00)
        return 8'h00;
      else if (zero_ones == 2'b11)
        return 8'hFF;
      else
        return $random;
   endfunction : get_data

   always @(posedge done) begin : scoreboard
      shortint predicted_result;
      #1;
      case (op_set)
        op_add: predicted_result = A + B;
        op_and: predicted_result = A & B;
        op_xor: predicted_result = A ^ B;	//need to clarify if or/xor
        op_mul: predicted_result = A * B;
        op_sp0: predicted_result = A + (2 * B);	//added the special functions
        op_sp1: predicted_result = A * 2;
        op_sp2: predicted_result = A * 3;
        op_shl: predicted_result = A << 3;
        op_shr: predicted_result = A >> 3;
        op_res1, op_res2, op_res3 : predicted_result = 1'b1;
        op_load, op_store : predicted_result = 'x;
      endcase // case (op_set)
    
    if ((op_set == op_res1) || (op_set == op_res2) || (op_set == op_res3)) begin
	   	        if (predicted_result != error)
		             $error ("FAILED: Illegal opcode used and no error flag raised");
    end
    else if ((op_set != op_nop) && (op_set != op_nop1)) begin
        if (predicted_result != result) begin
             $error ("FAILED: A: %0h  B: %0h  op: %s result: %0h predicted result: %0h",
                A, B, op_set.name(), result, predicted_result);
        end else begin
            $display("Results: A: %0h  B: %0h  op: %s result: %0h predicted result: %0h",
               A, B, op_set.name(), result, predicted_result);
        end
    end

   end : scoreboard
   

   
   
   initial begin : tester
      reset_n = 1'b0;
      @(negedge clk);
      @(negedge clk);
      #10;
      reset_n = 1'b1;
      start = 1'b0;
      repeat (100) begin
         @(negedge clk);
         op_set = get_op();
         A = get_data();
         B = get_data();
         start = 1'b1;
         case (op_set) // handle the start signal
           op_nop, op_nop1: begin 
              @(posedge clk);
              start = 1'b0;
           end
           default: begin 
              wait(done);
              start = 1'b0;
           end
         endcase // case (op_set)
      end
      $finish;
   end : tester
endmodule : alu_top
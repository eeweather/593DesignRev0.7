/*
   Copyright 2013 Ray Salemi

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*/
interface tinyalu_bfm;
   import tinyalu_pkg::*;

   wire [7:0]        A;
   wire [7:0]        B;
   bit          clk;
   bit          reset_n;
   wire [2:0]   op;
   bit          start;
   wire         done;
   wire [15:0]  result;
   instruction_t  instr;

   //
   bit reset_start;


   task reset_alu();
      reset_n = 1'b0;
      reset_start =1'b1;
      @(negedge clk);
      @(negedge clk);
      reset_n = 1'b1;
      start = 1'b0;
   endtask : reset_alu
   
   task send_instruction (input instruction_t i_instr);
        @(negedge clk);
        wait(done || reset_start);
        wait(!done || reset_start);
	instr = i_instr;
	reset_start = 1'b0;

   endtask : send_instruction


//    function operation_t op2enum();
//       case(op)
//         3'b000 : return no_op;
//         3'b001 : return add_op;
//         3'b010 : return and_op;
//         3'b011 : return xor_op;
//         3'b100 : return mul_op;
//         default : $fatal("Illegal operation on op bus");
//       endcase // case (op)
//    endfunction : op2enum


//    always @(posedge clk) begin : op_monitor
//       static bit in_command = 0;
//       if (start) begin : start_high
//         if (!in_command) begin : new_command
//            command_monitor_h.write_to_monitor(A, B, op2enum());
//            in_command = (op2enum() != no_op);
//         end : new_command
//       end : start_high
//       else // start low
//         in_command = 0;
//    end : op_monitor

//    always @(negedge reset_n) begin : rst_monitor
//       if (command_monitor_h != null) //guard against VCS time 0 negedge
//         command_monitor_h.write_to_monitor($random,0,rst_op);
//    end : rst_monitor
   
//    result_monitor  result_monitor_h;

//    initial begin : result_monitor_thread
//       forever begin : result_monitor_block
//          @(posedge clk) ;
//          if (done) 
//            result_monitor_h.write_to_monitor(result);
//       end : result_monitor_block
//    end : result_monitor_thread
   
task get_an_input(tinyalu_pkg::item_base tx);
	  //  tx.inst = inst.inst;
    endtask : get_an_input

    
    task get_an_output(tinyalu_pkg::item_base tx);
	wait(done);
	//   tx.inst = inst.inst;
    endtask : get_an_output


   initial begin
      clk = 0;
      fork
         forever begin
            #10;
            clk = ~clk;
         end
      join_none
   end


endinterface : tinyalu_bfm

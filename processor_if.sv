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
interface processor_if;
   import tinyalu_pkg::*;

   byte        A;
   byte        B;
   bit          clk;
   bit          reset_n;
   wire [2:0]   op;
   bit          start;
   wire         done;
   logic [15:0]  result;
   instruction_t  instr;
   
   //mss
   logic [15:0] datatomem;
   logic [7:0] datafrommem;
   logic cs;
   logic read_req;
   logic write_req;
   logic [13:0] addrout;
   logic mem_resp;


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

task get_an_input(tinyalu_pkg::item_base tx);
	wait(done || reset_start);
        wait(!done || reset_start);
	tx.inst = instr;
    endtask : get_an_input

    
    task get_an_output(tinyalu_pkg::item_base tx);
	// wait(done || reset_start);
   //      wait(!done || reset_start);
	tx.inst = instr;
	tx.A = A;
	tx.B = B;
	tx.result = result;
    endtask : get_an_output

    task sample_instruction(tinyalu_pkg::item_base tx);
	if (reset_n) begin
	   // wait(done || reset_start);
      //      wait(!done || reset_start);
	   tx.inst = instr;
	   tx.A = A;
	   tx.B = B;
	   tx.result = result;
	end
    endtask : sample_instruction

   initial begin
      clk = 0;
      fork
         forever begin
            #10;
            clk = ~clk;
         end
      join_none
   end

endinterface : processor_if

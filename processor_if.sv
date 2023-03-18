/*  ECE593 Project 2023wi
*   Victoria Van Gaasbeck <vvan@pdx.edu>
*   Julia Filipchuk <bfilipc2@pdx.edu>
*   Emily Weatherford <ew22@pdx.edu>
*   Daniel Keller <dk27@pdx.edu>
*
*   Processor_if, first based of Ray Salemi's bfm from The UVM Primer,
*   highly adapeted for PSU ECE 593 final project
*/



interface processor_if (input clk);
   import tinyalu_pkg::*;

   // top level signals
   byte        A;
   byte        B;
   bit          reset_n;
   wire         done;
   logic [15:0]  result;
   instruction_t  instr;
   logic error;

   
   //mss signal package
   logic [15:0] datatomem;
   logic [15:0] datafrommem;
   logic cs;
   logic read_req;
   logic write_req;
   logic [13:0] addrout;
   logic mem_resp;

   //kick off signal
   bit reset_start;


   // task that reset alu, initalizing all value
   task reset_alu();
      reset_n = 1'b0;
      reset_start =1'b1;
      @(negedge clk);
      @(negedge clk);
      reset_n = 1'b1;
   endtask : reset_alu
    
    //task that sends next instruction from UVM TB to DUV
   task send_instruction (input instruction_t i_instr);
        @(negedge clk);
        wait(done || reset_start);
        wait(!done || reset_start);
	instr = i_instr;
	reset_start = 1'b0;
   endtask : send_instruction


   //task that sends top level signals from DUB to UVM TB
    task sample_instruction(tinyalu_pkg::item_base tx);
	if (reset_n) begin
        if(error) $fatal("ERROR SIGNAL IS HIGH, CHECK FOR RESERVE OPCODE");
        else begin
	   tx.inst = instr;
	   tx.A = A;
	   tx.B = B;
      tx.mem_data = (instr[18:15]==4'b1000)? datafrommem: datatomem;
      @(posedge clk);
	   tx.result = result;
        end
	end
    endtask : sample_instruction

   //SUPER AWESOME TOTALY FUNCTIONAL, LOGICALLY SOUND ASSERTIONS.
   one_cycle_assert : assert property(
	@(posedge clk) disable iff(!reset_n || done || !(instr[18:15] inside {[op_add:op_xor], op_shl, op_shr}))
        instr[18:15] inside {[op_add:op_xor], op_shl, op_shr} |-> ##1 done
	) else $error ("one cycle timing violation with op = %b", instr[18:15]);	

   three_cycle_assert : assert property(
	@(posedge clk) disable iff(!reset_n || done || !(instr[18:15] inside {op_mul, op_sp1, op_sp2}))
         instr[18:15] inside {op_mul, op_sp1, op_sp2} |-> ##3 done
	) else $error ("three cycle timing violation with op = %b", instr[18:15]);	

   four_cycle_assert : assert property(
	@(posedge clk) disable iff(!reset_n || done || !(instr[18:15] inside {op_sp0}))
        instr[18:15] inside {op_sp0} |-> ##4 done
	) else $error ("four cycle timing violation with op = %b", instr[18:15]);

   ten_cycle_assert : assert property(
	@(posedge clk) disable iff(!reset_n || done || !(instr[18:15] inside {op_store, op_load}))
        instr[18:15] inside {op_store, op_load} |-> ##10 done
	) else $error ("Ten cycle timing violation with op = %b", instr[18:15]);



endinterface : processor_if


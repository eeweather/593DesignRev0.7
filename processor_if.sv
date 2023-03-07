interface processor_if(input clk, reset_n);
import tinyalu_pkg::*;

   //ALU signals 
   byte unsigned        A;
   byte unsigned        B;
   alu_opcode_t  	op;
   bit           	start;
   bit           	done;
   logic [15:0]  	result;
   alu_opcode_t  	op_set;
   bit 			error;
            
   //processor to memory signals
   logic processor_req;
   logic [13:0] addr;
   logic processor_resp;

   //memory interface signals
   logic store;
   logic load;
   logic [15:0] datafrommem; //from mss
   logic [15:0] datatomem; // to mss
   logic mem_done;
   logic [7:0] datatoinst;
   logic write_req;
   logic read_req;
   logic [13:0] addrout;
   logic mem_resp;

   //IU signals
   logic alu_done;
   logic [7:0] data;
   logic [15:0] alu_result;
   logic [15:0] IU_result;
   byte unsigned IU_A;
   byte unsigned IU_B;
   bit IU_start;

   // JBFIL: Disable due to multiple assign.
   //send_op task stolen from ALU593 for testing
   // task send_op(input byte iA, input byte iB, input alu_opcode_t iop, output shortint alu_result);
   //    begin
	//  @(negedge clk);
   //       op_set = iop;
   //       A = iA;
   //       B = iB;
   //       start = 1'b1;
   //       if (iop == op_nop) begin
   //          @(posedge clk);
   //          #1;
   //          start = 1'b0;           
   //       end else begin
   //          do
   //            @(negedge clk);
   //          while (done == 0);
   //          alu_result = result;
   //          start = 1'b0;
   //       end
   //    end // else: !if(iop == rst_op)
      
   // endtask : send_op

endinterface : processor_if

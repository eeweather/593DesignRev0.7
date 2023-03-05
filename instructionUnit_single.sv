// ECE593 Project 2023wi
//  Victoria Van Gaasbeck <vvan@pdx.edu>
//  Julia Filipchuk <bfilipc2@pdx.edu>
//  Emily Weatherford <ew22@pdx.edu>
//  Daniel Keller <dk27@pdx.edu>
//
// TinyALU CPU
//

/* Each instruction is 4 bits
o Loads instructions from a file using $fopen() into an array : array size is 1KBytes
o Executes instructions read from local memory one by one
import tinyalu_pkg::*;

Reads instructions from Mem array
 Keeps 2 registers A, B for loading data from main memory
 Sample of Instruction mem array content:
 Load 0x10 A_B=0; IU sends load request o mem interface unit by asserting Load=1, store=0,
addr=0x10; when mem_done=1; wait for next mem_resp; mif.data gets loaded into register A.
 load 0x11 A_B=1; IU sends load request to MIU by asserting Load=1; store=0;addr=0x11; when
mem_done=1; wait for next mem_resp; mif.data gets loaded into register B.
 Add A, B; send Opcode/a/b to ALU593; wait for done
 Store 0x12; send store request to MIU with result[15:0], addr[13:0]; wait for mem_resp
*/

import tinyalu_pkg::*;

module instructionUnit (
    input instruction_t instr,
	input logic clk, reset_n,
    input logic mem_done,          //memory interface done done signal
    input logic alu_done,          //AlU is done and ready for next opcode
    input logic [7:0] data,           //receives data from Memory Interface unit
    input logic [15:0] alu_result,    //results from ALU
    output logic start,              //connects to ALU593 to start operation
    output logic [7:0] A, B,         //connect to ALU593
    output alu_opcode_t  op,           //connect to ALU593
    output logic [13:0] addr,        //address to main memory
    output logic [15:0] result,     //results to be sent to main memory - connect to mem interface unit
    output logic store, load, done       //issue store/load signal to mem interface unit
);

    //internal signals
    logic [7:0] regA, regB;            //internal registers for operand A and B
    logic [18:0] insArray[0 : 999];   //instruction array 
    alu_opcode_t opcode;              //decoded  opcode
    logic [13:0] decode_addr;              //decoded address
    logic loadReg;                  //decoded Load = 0 loads reg A. Load = 1 loads reg B
    int fd;                         //file descriptor
    int count;                      //line count for reading file
    int index;                      //instruction array index
 

 
    assign opcode = alu_opcode_t'(instr[18:15]);      //cast to opcode enum
    assign decode_addr = instr[14:1];         //get address
    assign loadReg = instr[0];         //get reg A or B


    //unsure of all the timing requirements, and which of these things should be sequential in always_ff block
    always_ff @(posedge clk) begin : send_instruction
        if (!reset_n) begin
            index <= '0;
            regA <= '0;
            regB <='0;
            start <='0;
            load <='0;
            store <= '0;
            done <= 0;
        end
        else if (mem_done) begin    //load appropriate register when mem_done signal is asserted
                if (loadReg)              
                    regB <= data;       
                else 
                    regA <= data;
                load <= 1'b0;       //deassert load/store signals
                store <= 1'b0;
                done <= 1;            //increment instruction array index
            end
        else if (opcode == op_load) begin   //load operation
                load <= 1'b1;                   //assert load signal for mem IF
                addr <= decode_addr;                   //supply address to mem IF
		    end
        else if (opcode == op_store) begin  
            store <= 1'b1;                  //assert store signal for mem IF
            addr <= decode_addr;                   //supply address to mem IF
            result <= alu_result;           //results to be stored in mem
        end
        
        else if (alu_done)  begin //alu done signal recieved, send next op
            start <= 1'b0;       //assert ALU start signal
            done <= 1;             //increment instruction array index
            regA <= regA;          //maintain register values?
            regB <= regB;
        end
        else begin
                op <= opcode;
                A <= regA;
                B <= regB;
            start <= 1'b1;          //deassrt alu start
            done <=0;
        end
      
    end : send_instruction

endmodule : instructionUnit

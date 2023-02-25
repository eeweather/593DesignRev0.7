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

typedef enum logic [3:0] {
		op_nop    = 4'b0000,
		op_add    = 4'b0001, // Add A, B
		op_and    = 4'b0010, // And A, B
		op_xor    = 4'b0011, // Xor  A, B
		op_mul    = 4'b0100, // Multiply A, B      (3 cycle)
		op_sp0    = 4'b0101, // Function A + 2 * B (3+1 cycle)
		op_sp1    = 4'b0110, // Function 2 * A     (3 cycle)
		op_sp2    = 4'b0111, // Function 3 * A     (3 cycle)
		op_load   = 4'b1000, // Load Memory to Register
		op_store  = 4'b1001, // Store Register to Memory
		op_shl    = 4'b1010, // shift left 3 bits
		op_shr    = 4'b1011, //shift right 3 bits
		op_res2   = 4'b1100,
		op_res3   = 4'b1101,
		op_rst    = 4'b1110, // using reserved 4 as new reset opcode
		op_nop1   = 4'b1111
	} alu_opcode_t;

module instructionUnit (
	input logic clk, reset_n,
    input logic mem_done,          //memory interface done done signal
    input logic alu_done,          //AlU is done and ready for next opcode
    input logic [7:0] data,           //receives data from Memory Interface unit
    input logic [15:0] alu_result,    //results from ALU
    output logic start,              //connects to ALU593 to start operation
    output logic [7:0] A, B,         //connect to ALU593
    output logic [4:0] op,           //connect to ALU593
    output logic [13:0] Addr,        //address to main memory
    output logic [15:0] result,     //results to be sent to main memory - connect to mem interface unit
    output logic store, load        //issue store/load signal to mem interface unit
);

    //internal signals
    logic [7:0] regA, regB;            //internal registers for operand A and B
    logic [18:0] insArray[0 : 999];   //instruction array 
    logic [18:0] instr;               //current instruction
    logic [3:0] opcode;              //decoded binary opcode
    alu_opcode_t enumOp;             //enumerated opcode type after parsing
    logic [13:0] addr;              //decoded address
    logic loadReg;                  //decoded Load = 0 loads reg A. Load = 1 loads reg B
    int fd;                         //file descriptor
   
   //load instructions from file into array 
    always_comb begin : file_parse
        fd = $fopen("./test.txt", "r");
        if (!fd) $display("File was not opened successfully");
        
        for(int i = 0; i < 1000; i++) begin
            $fscanf(fd,"%x",insArray[i]);    
            $display("Array[%x] = %x", i, insArray[i]); //printing for debug purposes
        end   
    end : file_parse

    always_comb begin : instruction_decode
        instr = insArray[index];    //get current instuction from array
        opcode = instr[18:15];      //get unenumerated opcode
        addr = instr[14:1];         //get address
        loadReg = instr[0];         //get reg A or B
        $cast(enumOp, opcode);      //cast opcode to enumerated type

        start = 1'b0;

    end : instruction_decode


    //  keep load/store high until mem_done signal recieved.
    //on every done signal index + 


    always_ff @(posedge clk) begin
        if (reset_n) begin
            index = '0;
            regA <= '0;
            regB <='0;
        end
        else if (mem_done) begin    //load appropriate register when mem_done signal is asserted
            if (loadReg)              
                regB <= data;
            else(loadB)
                regB <= data;
		end
        else if (alu_done)  begin //alu done signal recieved, send next op
            op <= opcode;
            a <= regA;
            b <= regB;
            start <= 1'b1;
            arrayindex++;
        end
        else if (enumOp == op_load) begin
            load <= 1'b1;
            Addr <= addr;
        end
        else if (enumOp == op_store) begin
            store <= 1'b1;
            Addr <= addr;
            Result <= alu_result;
        end

        

    end

 

endmodule : instructionUnit

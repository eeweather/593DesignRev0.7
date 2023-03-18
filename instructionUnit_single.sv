// ECE593 Project 2023wi
//  Victoria Van Gaasbeck <vvan@pdx.edu>
//  Julia Filipchuk <bfilipc2@pdx.edu>
//  Emily Weatherford <ew22@pdx.edu>
//  Daniel Keller <dk27@pdx.edu>
//
// Instruction Unit, intakes next instruct from proc interface and sends to 
// correct unit, after  unit finishes it task, stores result, or passes data 
// to memory, or next unit
//



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
    
    logic [15:0] last_result;


    assign A = regA;
    assign B = regB;
    assign result = last_result;

    always_comb begin 

        opcode = alu_opcode_t'(instr[18:15]);      //cast to opcode enum 
        decode_addr = instr[14:1];         //get address
        loadReg = instr[0];         //get reg A or B
        done = mem_done || alu_done;
 	if(alu_result != 1'bx) last_result = alu_result;
    else if (alu_result == 4'b0000) last_result = alu_result;
    else if (alu_result == 4'b0001) last_result = alu_result;

        if (!reset_n) begin
            index = '0;
            regA = '0;
            regB ='0;
            start ='0;
            load ='0;
            store = '0;
        end
        else if (mem_done) begin    //load appropriate register when mem_done signal is asserted
                if(load) begin
                if (loadReg)              
                    regB = data;       
                else 
                    regA = data;
                end
                load = 0;       //deassert load/store signals
                store = 0;
            end
        else if (alu_done)  begin //alu done signal recieved, send next op
            start = 1'b0;       //assert ALU start signal
            regA = regA;          //maintain register values
            regB = regB;
        end
        else begin
                op = opcode;
        end

        if (opcode == op_load) begin   //load operation
                load = 1;              //assert load signal for mem IF
                store = 1'b0;                 
                addr = decode_addr;          //supply address to mem IF
                start = 0;                  
		    end
        else if (opcode == op_store) begin  
            start = 0;                  //deassert start
            store = 1'b1;              //assert store signal for mem IF
            load = 0;                  
            addr = decode_addr;                   //supply address to mem IF
        end
         else begin
            if(!alu_done) start = 1;
            load = 0;                  //assert deassert signal for mem IF
            store = 1'b0;                 //assert store signal for mem IF
        end
    end 

endmodule : instructionUnit

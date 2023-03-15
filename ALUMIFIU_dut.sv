import tinyalu_pkg::*;



module alumifiu_dut ( 
    input instruction_t instr,
    input logic clk, reset_n,
    output logic done,
    output logic [7:0] A, B,
    output logic [15:0] result,
    output logic [15:0] datatomem,
    input logic [15:0] datafrommem,
    output logic cs,
    output logic read_req,
    output logic write_req,
    output logic [13:0] addrout,
    input logic mem_resp,
    output logic error
);


    logic [7:0] A_in, B_in;
    alu_opcode_t  op;
    logic start, alu_done, mem_done, preload;
    logic [15:0] alu_result;
    reg store, load;
    reg [15:0] result_in;
    reg [13:0] addr;
    reg [7:0] datatoinst;


assign A = A_in;
assign B = B_in;
assign result = result_in;


 ALU593 ALU (
    .clk(clk), 
    .reset_n(reset_n),
	.A(A_in),
    .B(B_in), //from IU
	.op(op), //from IU
	.start(start), // from IU
	.result(alu_result), //to IU
	.done(alu_done), // to iu
	.error(error) // just around  	
);

instructionUnit instunit (
    .instr(instr),
    .clk(clk), 
    .reset_n(reset_n),
    .mem_done(mem_done),         //memory interface done done signal
    .alu_done(alu_done),          //AlU is done and ready for next opcode
    .data(datatoinst),           //receives data from Memory Interface unit
    .alu_result(alu_result),    //results from ALU
    .start(start),              //connects to ALU593 to start operation
    .A(A_in),
    .B(B_in),         //connect to ALU593
    .op(op),           //connect to ALU593
    .addr(addr),        //address to main memory
    .result(result_in),     //results to be sent to main memory - connect to mem interface unit
    .store(store),
    .load(load),        //issue store/load signal to mem interface unit
    .done(done)
);

 memInerf memInt (
        .clk(clk),
        .reset_n(reset_n),
        .store(store),
        .load(load),
        .mem_resp(mem_resp),
        .result(result_in),
        .addr(addr),
        .datafrommem(datafrommem),
        .datatomem(datatomem),
        .mem_done(mem_done),
        .datatoinst(datatoinst),
        .write_req(write_req),
        .read_req(read_req),
        .cs(cs),
        .addrout(addrout)
    );

endmodule: alumifiu_dut

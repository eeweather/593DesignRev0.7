import tinyalu_pkg::*;



module alumifiu_dut ( 
    input instruction_t instr,
    input logic clk, reset_n,
    output logic done
);


    logic [7:0] A, B;
    alu_opcode_t  op;
    logic start, alu_done, mem_done, error, preload;
    logic [15:0] alu_result;
    reg store, load;
    reg [15:0] result;
    reg [13:0] addr;
    reg [7:0] datatoinst;
    logic [15:0] datatomem;
    logic [7:0] datafrommem;
    logic [13:0] addrout;
    logic write_req, read_req;
    logic mem_resp;


 ALU593 alu (
    .clk(clk), 
    .reset_n(reset_n),
	.A(A),
    .B(B), //from IU
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
    .A(A),
    .B(B),         //connect to ALU593
    .op(op),           //connect to ALU593
    .addr(addr),        //address to main memory
    .result(result),     //results to be sent to main memory - connect to mem interface unit
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
        .result(result),
        .addr(addr),
        .datafrommem(datafrommem),
        .datatomem(datatomem),
        .mem_done(mem_done),
        .datatoinst(datatoinst),
        .write_req(write_req),
        .read_req(read_req),
        .addrout(addrout)
    );

    sram_single_port sram (
        .reset_n(reset_n),
        .clk(clk),
        .re(read_req),
        .we(write_req),
        .preload(preload),
        .addr(addrout),
        .datafrommif(datatomem),
	    .datatomif(datafrommem),
        .mem_resp(mem_resp)
    );


endmodule: alumifiu_dut
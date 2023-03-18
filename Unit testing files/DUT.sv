import tinyalu_pkg::*;



module DUT ( 
    input instruction_t instr,
    input logic clk, reset_n,
    output logic done,
    output logic [7:0] A, B,
    output logic [15:0] result
);


    logic [7:0] A_in, B_in;
    alu_opcode_t  op;
    logic start, alu_done, mem_done, error, preload;
    logic [15:0] alu_result;
    reg store, load;
    reg [15:0] result_in;
    reg [13:0] addr_0, addr_1, addr_2, addr_3;
    reg [7:0] datatoinst;
    logic [15:0] datatomem;
    logic [7:0] datafrommem;
    logic [13:0] addrout;
    logic write_req, read_req;
    logic mem_resp;
    logic cs_0;

assign A = A_in;
assign B = B_in;
assign result = result_in;

processor PROC1 (instr, clk, reset_n, done, A, B, result);


 ALU593 alu_0 (
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

instructionUnit instunit_0 (
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

 memInerf memInt_0 (
        .clk(clk),
        .reset_n(reset_n),
        .store(store),
        .load(load),
        .mem_resp(mem_resp_0),
        .result(result_in),
        .addr(addr),
        .datafrommem(datafrommem),
        .datatomem(datatomem),
        .mem_done(mem_done),
        .datatoinst(datatoinst),
        .write_req(write_req),
        .read_req(read_req),
        .cs(cs_0),
        .addrout(addrout)
    );

    // sram_single_port sram (
    //     .reset_n(reset_n),
    //     .clk(clk),
    //     .re(read_req),
    //     .we(write_req),
    //     .preload(preload),
    //     .addr(addrout),
    //     .datafrommif(datatomem),
	//     .datatomif(datafrommem),
    //     .mem_resp(mem_resp)
    // );

/*
    memory_subsystem mss (
        .clk(clk),                 
        .reset_n(reset_n),              
        .mem_write_data(datatomem),   
        .processor_req_0(cs_0),                     	
        .processor_req_1(0),   
        .processor_req_2(0),  	
        .processor_req_3(0),
        .mem_read_req(read_req), 
        .mem_write_req(write_req),  
        .addr(addrout),
        .mem_read_data(datafrommem),   
        .processor_resp_0(mem_resp_0),
        .processor_resp_1(),
        .processor_resp_2(),
        .processor_resp_3() 
);
*/
endmodule: alumifiu_dut

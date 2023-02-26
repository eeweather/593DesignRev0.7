module top (
    input logic clk, reset_n,

    // Declare signals for memInerf module inputs
    input logic store, load,
    input logic [15:0] result,
    input logic [13:0] addr,

    // Declare signals for memInerf module outputs
    output logic mem_done,
    output [7:0] datatoinst
    );

    tri [15:0] datatofrommem;
    logic [13:0] addrout;
    logic write_req, read_req;
    logic mem_resp;



    memInerf memInt (
        .clk(clk),
        .reset_n(reset_n),
        .store(store),
        .load(load),
        .mem_resp(mem_resp),
        .result(result),
        .addr(addr),
        .datatofrommem(datatofrommem),
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
        .addr(addrout),
        .data(datatofrommem),
        .mem_resp(mem_resp)
    );

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, memInt, sram);
    end

endmodule : top
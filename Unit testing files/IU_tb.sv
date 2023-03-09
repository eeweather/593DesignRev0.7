module iu_tb  ();
    import tinyalu_pkg::*;


    // Declare clock and reset signals
    logic clk, reset_n;

    // Declare signals for instunit module inputs
    logic mem_done, alu_done;
    logic [7:0] data;
    logic [15:0] alu_result;

    // Declare signals for instunit module outputs
    logic start;
    logic [7:0] A, B;
    alu_opcode_t op;
    logic [13:0] Addr;
    logic [15:0] result;
    logic store, load;
    
    

    instructionUnit instunit (.*);

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, instunit);
    end

    initial begin
        clk = 1'b1;
        forever #1 clk = ~clk;
    end


    // Create a reset generator
    initial begin
        reset_n= 0;
	    #10;
        reset_n = 1;
        #10;
        mem_done = 1;
        #2;
        mem_done =0;
        #20;
        mem_done = 1;
        #2;
        mem_done =0;
        #2;
        alu_done = 1;
        #2;
        alu_done =0;
        #20;
        mem_done = 1;
        #2;
        mem_done =0;
        #2;
        alu_done = 1;
        #2;
        alu_done = 0;
        #20;
        mem_done = 1;
        #2
        mem_done = 0;
        #6
        alu_done = 1;
        #2;
        alu_done = 0;
        #20;
        mem_done = 1;
        #2
        mem_done = 0;
        #20;
        mem_done = 1;
        #2
        mem_done = 0;
        #20;
        mem_done = 1;
        #2
        mem_done = 0;
        #2;
        alu_done = 1;
        #2;
        alu_done =0;
	    #20;
        mem_done = 1;
        #2
        mem_done = 0;
        #60

    


    // Stop the simulation

        #10;
        $finish;
    end


endmodule: iu_tb
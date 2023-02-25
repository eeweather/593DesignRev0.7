module memInerf_sram_tb ();

    // Declare clock and reset signals
    reg clk, reset_n;

    // Declare signals for memInerf module inputs
    reg store, load;
    reg [15:0] result;
    reg [13:0] addr;

    // Declare signals for memInerf module outputs
    reg mem_done;
    reg [7:0] datatoinst;
    reg [13:0] addrout;
    
    
    // Instantiate  top
    top dut (.*);

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end


    // Create a reset generator
    initial begin
        
        reset_n = 1;


    // Test case 1: Memory write

        #10;
        result = 16'h34;
        addr = 14'h0A;
        store = 1'b1;
        // #10;
        // store = 0;
        // #10;
        // assert(mem_done === 1) else $error("Test case 1 failed: Memory write operation failed");


    // Test case 2: Memory read

        // #10;
        // addr = 14'h0A;
        // load = 1;
        // #10;
        // load = 0;
        // #10;
        // assert(datatoinst === 16'h1234) else $error("Test case 2 failed: Memory read operation failed");



    // Stop the simulation

        #100;
        // $finish;
    end

endmodule

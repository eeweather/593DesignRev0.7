module memInerf_sram_tb;

    // Declare clock and reset signals
    logic clk, reset_n;

    // Declare signals for memInerf module inputs
    logic store, load;
    logic [15:0] result;
    logic [13:0] addr;
    wire [15:0] datatofrommem;

    // Declare signals for memInerf module outputs
    logic mem_done;
    logic [7:0] datatoinst;
    logic [13:0] addrout;

    // Create a clock generator
    always #5 clk = ~clk;
    
    // Instantiate  top
    top dut (.*);

 
    

    
    assign datatofrommem = 16'h1234;


    // Create a reset generator
    initial begin
        reset_n = 0;
        #10;
        reset_n = 1;


    // Test case 1: Memory write

        #10;
        addr = 14'h0A;
        store = 1;
        #10;
        store = 0;
        #10;
        assert(mem_done === 1) else $error("Test case 1 failed: Memory write operation failed");


    // Test case 2: Memory read

        #10;
        addr = 14'h0A;
        load = 1;
        #10;
        load = 0;
        #10;
        assert(datatoinst === 16'h1234) else $error("Test case 2 failed: Memory read operation failed");



    // Stop the simulation

        #10;
        $finish;
    end

endmodule

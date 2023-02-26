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
        clk = 1'b1;
        forever #1 clk = ~clk;
    end


    // Create a reset generator
    initial begin
        reset_n= 0;
	#10
        reset_n = 1;


    // Test case 1: Memory write

        #10;
        result = 16'h1234;
        addr = 14'h0A;
        store = 1'b1;
        assert property (@(posedge clk) store |=> ##[1:9] mem_done) else $error("Test case 1 failed: Memory write operation failed");
        #20;
        store = 0;
 
 


    // Test case 2: Memory read

        #10;
        addr = 14'h0A;
        load = 1;
        #20;
        load = 0;
        #10;
        assert(datatoinst === 16'h34) else $error("Test case 2 failed: Memory read operation failed");



    // Stop the simulation

        #100;
        $finish;
    end

endmodule

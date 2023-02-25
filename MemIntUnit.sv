/*
--Inputs:
o Reset
o Clk
o Result[15:0];
o Store;
o Load;
o Addr[13:0]
o Mem_resp;
-- Inout:
o DATA[15:0]; // Writes use 15:0/ reads use 7:0
-- Output:
o Done; NOT on drawing
o Data[7:0]
o Write_req; to SMM
o READ_REQ; to SMM
o ADDROUT[13:0]; to SMM 

Purpose of Module

Consists of a memory interface that is connected to a system memory. 
o  The processor should fetch data from the system memory of size 16 KBytes. 
o  The data size should be 2 Bytes. Max operand size is 8 bits. 

Memory Interface Unit: 
o  16 KBytes system memory interface 
o  8 Bytes data size 
o  Makes read/ write request to memory 
  Read request: Asserts request, waits for read data. Removes request upon 
receiving response.  
  Write request: asserts request with write data, removes request upon receiving 
response. 

*/

module memInerf (
    input clk, reset_n, store, load, mem_resp,
    input [15:0] result,
    input [13:0] addr,
	inout [15:0] datatofrommem,
    output mem_done,
    output [7:0] datatoinst,
    output write_req, read_req,
    output [13:0] addrout
);

always_ff @(posedge clk) begin
    mem_done <=0;
    //if reset reset
    if (reset_n)
        //TODO:  what needs to be reset
    // load signal comes in
    else if (load) begin
        // read addr, put on addrout
        addrout<=addr;
        //set read_req
        read_req <=1;
        if (mem_resp) begin
            //when mem_resp goes high, put data on datatofrommem onto datatoinst
            datatoinst<=datatofrommem;
            //end with read_req and raise mem_done
            read_req <= 0;
            mem_done <=1; 
        end
    end
    // store signal comes in
    else if (store) begin
        // read addr onto addrout
        // put result onto datatofrommem
        //set write_req
        addrout<=addr;
        datatofrommem<=result;
        write_req<=1;
        // when mem_resp goes high raise mem_done and lower all else
        if (mem_resp) begin
            mem_done<=1;
            write_req<=0;
        end
    end        
end

endmodule : memInerf

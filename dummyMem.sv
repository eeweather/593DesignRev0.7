module sram_single_port #(
	parameter DATA_WIDTH = 16,
	parameter ADDR_WIDTH = 14
) (
	input logic reset_n, clk,
	input logic re, we,
	input logic [ADDR_WIDTH-1:0] addr,
	input logic [DATA_WIDTH-1:0] datafrommif,
	output logic [7:0] datatomif,
    output logic mem_resp
);

	reg [DATA_WIDTH-1:0] mem [ADDR_WIDTH-1:0];

//	assign data = (re) ? mem[addr] : 'z;

	always_ff @(posedge clk) begin
     
		if (!reset_n) begin
			for (int i=0; i<$size(mem); ++i) // Clear ram on reset.
				mem[i] <= '0;
		end
		else if (mem_resp) begin
		   mem_resp <=0;
		end
        else if (we) begin
			mem[addr] <= datafrommif;
            mem_resp <= 1;
		end
        else if (re) begin
            datatomif <= mem[addr];
			mem_resp <= 1;
        end
    end
endmodule
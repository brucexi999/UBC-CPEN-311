`timescale 1ps / 1ps

module tb_rtl_ksa();

logic clk;
logic rst_n;
logic en;
logic rdy;
logic [23:0] key;
logic [7:0] addr;
logic [7:0] rddata;
logic [7:0] wrdata;
logic wren;

ksa DUT (
.clk (clk),
.rst_n (rst_n),
.en (en),
.rdy (rdy),
.key (key),
.addr (addr),
.rddata (rddata),
.wrdata (wrdata),
.wren (wren)
);

initial begin
	clk = 0; #5;
	forever begin
		clk = 1; #5;
		clk = 0; #5;
	end
end

initial begin
rst_n = 1; rst_n = 0; #10;
rst_n = 1; key = 24'b000000000000001100111100; en = 1; rddata = 8'b00000000; #105;
rddata = 8'b00000001; #100;
rddata = 8'b00000010; #40;
rddata = 8'b00000100; #60;
$stop;
end
endmodule: tb_rtl_ksa

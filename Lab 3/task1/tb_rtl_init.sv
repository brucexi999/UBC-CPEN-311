`timescale 1 ps / 1 ps

module tb_rtl_init();

logic clk;
logic rst_n;
logic en;
logic rdy;
logic [7:0] addr;
logic [7:0] wrdata;
logic wren;

init DUT (
.clk (clk),
.rst_n (rst_n),
.en (en),
.rdy (rdy),
.addr (addr),
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
rst_n = 1; #5;
rst_n = 0; #5;
rst_n = 1; #5;
en = 1; #2500; 
en = 0; #500;
en = 1; #2500; 
$stop;
end

endmodule: tb_rtl_init

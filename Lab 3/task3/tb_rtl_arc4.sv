`timescale 1ps / 1ps

module tb_rtl_arc4();

logic clk, rst_n, en, rdy, pt_wren;
logic [23:0] key;
logic [7:0] ct_addr, ct_rddata, pt_addr, pt_rddata, pt_wrdata; 

arc4 DUT (
.clk (clk),
.rst_n (rst_n),
.en (en),
.rdy (rdy),
.key (key),
.ct_addr (ct_addr),
.ct_rddata (ct_rddata),
.pt_addr (pt_addr),
.pt_rddata (pt_rddata),
.pt_wrdata (pt_wrdata), 
.pt_wren (pt_wren)
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
rst_n = 1; en = 1; key = 'h000018; ct_rddata = 8'b00110101; 
//#2575;
//#35855; 
#100000;
$stop; 
end

endmodule: tb_rtl_arc4

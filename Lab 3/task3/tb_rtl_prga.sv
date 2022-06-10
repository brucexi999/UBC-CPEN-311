`timescale 1ps / 1ps

module tb_rtl_prga();

logic clk, rst_n, en, rdy, s_wren, pt_wren;
logic [23:0] key;
logic [7:0] s_addr, s_rddata, s_wrdata, ct_addr, ct_rddata, pt_addr, pt_rddata, pt_wrdata; 

prga DUT (
.clk (clk),
.rst_n (rst_n),
.en (en),
.rdy (rdy),
.key (key),
.s_addr (s_addr),
.s_rddata (s_rddata),
.s_wrdata (s_wrdata),
.s_wren (s_wren),
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
rst_n = 1; en = 1; #25;
en = 0; ct_rddata = 8'b00000011; #30;
s_rddata = 8'b00000100; #40;
s_rddata = 8'b00000101; #40;
s_rddata = 8'b00000110; ct_rddata = 8'b10000111; 
//rddata = 8'b00000001; #100;
//rddata = 8'b00000010; #40;
//rddata = 8'b00000100; #60;
#500;
$stop;
end
endmodule: tb_rtl_prga

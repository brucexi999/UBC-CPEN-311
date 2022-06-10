`timescale 1ps / 1ps

module tb_rtl_crack();

	logic clk, rst_n, en, rdy, key_valid, pt1_wren, pt1_en;
	logic [23:0] key, initial_key;
	logic [7:0] ct_addr, ct_rddata, pt1_addr, pt1_wrdata; 
	
	crack dut (
	.clk (clk),
	.rst_n (rst_n),
	.en (en),
	.rdy (rdy),
	.key (key),
	.key_valid (key_valid),
	.ct_addr (ct_addr),
	.ct_rddata (ct_rddata),
	.pt1_addr (pt1_addr),
	.pt1_wrdata (pt1_wrdata),
	.pt1_wren (pt1_wren),
	.initial_key (initial_key),
	.pt1_en (pt1_en)
	);
	
	ct_mem ct (
	.address (ct_addr),
	.clock (clk),
	.q (ct_rddata)
	);
	
	pt_mem pt1(
	.address (pt1_addr),
	.clock (clk),
	.data (pt1_wrdata),
	.wren (pt1_wren)
	);
	
	initial begin
		clk = 0; #5;
		forever begin
			clk = 1; #5;
			clk = 0; #5;
		end
	end
	
	initial begin
	$readmemh("test1.memh",ct.altsyncram_component.m_default.altsyncram_inst.mem_data);
	rst_n = 1; rst_n = 0; #10;
	rst_n = 1; initial_key = 0; en = 1; #10;
	en = 0; #500000;
	
	
	
	$stop;
	end
endmodule: tb_rtl_crack

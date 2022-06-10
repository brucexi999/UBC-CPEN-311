`timescale 1ps / 1ps

module tb_rtl_doublecrack();

	logic clk, rst_n, en, rdy, key_valid;
	logic [23:0] key; 
	logic [7:0] ct_addr, ct_rddata;

	doublecrack dut (
	.clk (clk),
	.rst_n (rst_n),
	.en (en),
	.rdy (rdy),
	.key (key),
	.key_valid (key_valid),
	.ct_addr (ct_addr),
	.ct_rddata (ct_rddata)
	);
	
	ct_mem ct (
	.address (ct_addr),
	.clock (clk),
	.q (ct_rddata)
	);
	
	initial begin
		clk = 0; #5;
		forever begin
			clk = 1; #5;
			clk = 0; #5;
		end
	end

	initial begin
	$readmemh("test1.memh", ct.altsyncram_component.m_default.altsyncram_inst.mem_data);
	rst_n = 1; rst_n = 0; #10;
	rst_n = 1; en = 1; #10;
	en = 0; #919815;
	$stop;
	end

endmodule: tb_rtl_doublecrack

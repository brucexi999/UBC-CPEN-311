`timescale 1ps / 1ps

module tb_syn_task5();

	logic CLOCK_50;
	logic [3:0] KEY;
	logic [6:0] HEX0;
	logic [6:0] HEX1;
	logic [6:0] HEX2;
	logic [6:0] HEX3;
	logic [6:0] HEX4;
	logic [6:0] HEX5;
	
	task5 dut (
	.CLOCK_50 (CLOCK_50),
	.KEY (KEY),
	.HEX0 (HEX0),
	.HEX1 (HEX1),
	.HEX2 (HEX2),
	.HEX3 (HEX3),
	.HEX4 (HEX4),
	.HEX5 (HEX5)
	);
	
	initial begin
		CLOCK_50 = 0; #5;
		forever begin
			CLOCK_50 = 1; #5;
			CLOCK_50 = 0; #5;
		end
	end
	
	initial begin
	$readmemh("test1.memh", dut.ct.altsyncram_component.m_default.altsyncram_inst.mem_data);
	KEY[3] = 1; #5;
	KEY[3] = 0; #10;
	KEY[3] = 1; #10000000;

	$stop;
	end

endmodule: tb_syn_task5

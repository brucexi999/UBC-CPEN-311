module task2 (input logic CLOCK_50, input logic [3:0] KEY);
	pixel_xform_system PXS (
	.clk_clk (CLOCK_50),
	.resetn_reset_n (KEY[3])
	);
endmodule
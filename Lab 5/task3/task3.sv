module task3 (
input CLOCK_50, 
input [3:0] KEY
);
	pixel_xform_system PXS (
	.clk_clk (CLOCK_50),
	.resetn_reset_n (KEY[3])
	);
	
endmodule 
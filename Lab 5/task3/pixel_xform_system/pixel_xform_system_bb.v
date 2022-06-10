
module pixel_xform_system (
	clk_clk,
	leds_export,
	resetn_reset_n,
	switches_export);	

	input		clk_clk;
	output	[7:0]	leds_export;
	input		resetn_reset_n;
	input	[7:0]	switches_export;
endmodule

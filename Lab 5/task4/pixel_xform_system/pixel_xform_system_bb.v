
module pixel_xform_system (
	clk_clk,
	leds_export,
	resetn_reset_n,
	switches_export,
	vga_b,
	vga_clk,
	vga_g,
	vga_hs,
	vga_r,
	vga_vs);	

	input		clk_clk;
	output	[7:0]	leds_export;
	input		resetn_reset_n;
	input	[7:0]	switches_export;
	output	[7:0]	vga_b;
	output		vga_clk;
	output	[7:0]	vga_g;
	output		vga_hs;
	output	[7:0]	vga_r;
	output		vga_vs;
endmodule

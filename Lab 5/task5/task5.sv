module task5 (
input CLOCK_50, 
input [3:0] KEY, 
output [7:0] VGA_R, 
output [7:0] VGA_G,
output [7:0] VGA_B, 
output VGA_VS,
output VGA_HS,
output VGA_CLK   
); 

	pixel_xform_system PXS (
	.clk_clk (CLOCK_50),
	.resetn_reset_n (KEY[3]), 
	.vga_b (VGA_B), 
	.vga_clk (VGA_CLK), 
	.vga_g (VGA_G),
	.vga_hs (VGA_HS), 
	.vga_r (VGA_R),
	.vga_vs (VGA_VS)
	);
	
endmodule 
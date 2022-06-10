`timescale 1 ps / 1 ps

module tb_syn_task2();

logic CLOCK_50;
logic [3:0] KEY;
logic [7:0] VGA_R;
logic [7:0] VGA_G; 
logic [7:0] VGA_B;
logic VGA_HS;
logic VGA_VS; 
logic VGA_CLK;
logic [7:0] VGA_X; 
logic [6:0] VGA_Y;
logic [2:0] VGA_COLOUR; 
logic VGA_PLOT;

task2 DUT (
.CLOCK_50 (CLOCK_50),
.KEY (KEY),
.VGA_R (VGA_R),
.VGA_G (VGA_G),
.VGA_B (VGA_B),
.VGA_HS (VGA_HS),
.VGA_VS (VGA_VS),
.VGA_CLK (VGA_CLK),
.VGA_X (VGA_X),
.VGA_Y (VGA_Y),
.VGA_COLOUR (VGA_COLOUR),
.VGA_PLOT (VGA_PLOT)
);

initial begin
	CLOCK_50 = 0; #5;
	forever begin
		CLOCK_50 = 1; #5;
		CLOCK_50 = 0; #5;
	end
end

initial begin
	KEY[3] = 0; #10;
	KEY[3] = 1;
	#200000;
	$stop;
end






endmodule: tb_syn_task2

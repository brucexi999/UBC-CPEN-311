module tb_circle_fsm ();
`define S0 4'b0000
`define S1 4'b0001
`define S2 4'b0010
`define S3 4'b0011
`define S4 4'b0100
`define S5 4'b0101
`define S6 4'b0110
`define S7 4'b0111
`define S8 4'b1000
`define S9 4'b1001
`define S10 4'b1010
`define S11 4'b1011
logic clk;
logic rst_n;
logic [2:0] colour;
logic [7:0] centre_x;
logic [7:0] centre_y;
logic [7:0] radius;
logic start;
logic done;
logic [7:0] x;
logic [7:0] y;
logic [2:0] vga_colour;
logic plot;

circle_fsm DUT (
.clk (clk),
.rst_n (rst_n),
.colour (colour),
.centre_x (centre_x),
.centre_y (centre_y),
.radius (radius),
.start (start),
.done (done),
.x (x),
.y (y),
.vga_colour (vga_colour),
.plot (plot)
);


initial begin
	clk = 0; #5;
	forever begin
		clk = 1; #5;
		clk = 0; #5;
	end
end

initial begin
	rst_n = 1; #5;
	rst_n = 0; #15;
	$display (tb_circle_fsm.DUT.present_state);
	$display (tb_circle_fsm.DUT.offset_x);
	$display (tb_circle_fsm.DUT.offset_y);
	$display (tb_circle_fsm.DUT.crit);
	$display (tb_circle_fsm.DUT.radius);
	rst_n = 1;
	start = 1;
	colour = 3'b001; centre_x = 80; centre_y = 60
; radius = 40;  #20000;
	$display (tb_circle_fsm.DUT.present_state);
	$display (tb_circle_fsm.DUT.offset_x);
	$display (tb_circle_fsm.DUT.offset_y);
	$display (tb_circle_fsm.DUT.crit);
	$stop;
	
end


endmodule
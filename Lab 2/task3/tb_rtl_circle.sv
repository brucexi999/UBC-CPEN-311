`timescale 1 ps / 1 ps

module tb_rtl_circle();

logic clk;
logic rst_n;
logic [2:0] colour;
logic [7:0] centre_x;
logic [6:0] centre_y;
logic [7:0] radius;
logic start;
logic done;
logic [7:0] vga_x;
logic [6:0] vga_y;
logic [2:0] vga_colour;
logic vga_plot;



circle DUT (
.clk (clk),
.rst_n (rst_n),
.colour (colour),
.centre_x (centre_x),
.centre_y (centre_y),
.radius (radius),
.start (start),
.done (done),
.vga_x (vga_x),
.vga_y (vga_y),
.vga_colour (vga_colour),
.vga_plot (vga_plot)
);

initial begin
	clk = 0; #5;
	forever begin
		clk = 1; #5;
		clk = 0; #5;
	end
end

initial begin
rst_n = 0; #10;
rst_n = 1;
start = 1;
centre_x = 50; centre_y = 50; radius = 10; colour = 3'b111; #2000;
$stop;
end




endmodule: tb_rtl_circle

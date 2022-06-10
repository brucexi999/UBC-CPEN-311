`timescale 1 ps / 1 ps

module tb_syn_fillscreen();

reg clk;
reg rst_n;
reg [2:0] colour;
reg start;
wire done;
wire [7:0] vga_x;
wire [6:0] vga_y;
wire [2:0] vga_colour;
wire vga_plot;




fillscreen DUT (
.clk (clk),
.rst_n (rst_n),
.colour (colour),
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
	start = 1; #200000;
	$stop;
end

endmodule: tb_syn_fillscreen

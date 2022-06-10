module circle(input logic clk, input logic rst_n, input logic [2:0] colour,
              input logic [7:0] centre_x, input logic [6:0] centre_y, input logic [7:0] radius,
              input logic start, output logic done,
              output logic [7:0] vga_x, output logic [6:0] vga_y,
              output logic [2:0] vga_colour, output logic vga_plot);

logic [7:0] centre_y8;
logic [7:0] x;
logic [7:0] y;

assign centre_y8 = {1'b0,centre_y};

circle_fsm FSM(
.clk (clk),
.rst_n (rst_n),
.colour (colour),
.centre_x (centre_x),
.centre_y (centre_y8),
.radius (radius),
.start (start),
.done (done),
.x (x),
.y (y),
.vga_colour (vga_colour),
.plot (vga_plot)
);

assign vga_x = x;
assign vga_y = y[6:0];
endmodule


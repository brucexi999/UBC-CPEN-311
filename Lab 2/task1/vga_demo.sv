// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on

module vga_demo(input logic CLOCK_50, input logic [3:0] KEY, input logic [9:0] SW,
                output logic [7:0] VGA_R, output logic [7:0] VGA_G, output logic [7:0] VGA_B,
                output logic VGA_HS, output logic VGA_VS, output logic VGA_CLK,
                output logic [7:0] VGA_X, output logic [6:0] VGA_Y,
                output logic [2:0] VGA_COLOUR, output logic VGA_PLOT);

logic [9:0] VGA_R_10;
logic [9:0] VGA_G_10;
logic [9:0] VGA_B_10;
logic VGA_BLANK, VGA_SYNC;

assign VGA_R = VGA_R_10[9:2];
assign VGA_G = VGA_G_10[9:2];
assign VGA_B = VGA_B_10[9:2];

assign VGA_X = {3'b0,SW[4:0]};
assign VGA_Y = {2'b0,SW[9:5]};
assign VGA_PLOT = ~KEY[0];
assign VGA_COLOUR = SW[2:0];

vga_adapter#(.RESOLUTION("160x120")) vga_u0(.resetn(KEY[3]), .clock(CLOCK_50), .colour(SW[2:0]),
                                            .x({3'b0,SW[4:0]}), .y({2'b0,SW[9:5]}), .plot(~KEY[0]),
                                            .VGA_R(VGA_R_10), .VGA_G(VGA_G_10), .VGA_B(VGA_B_10),
                                            .*);
endmodule: vga_demo

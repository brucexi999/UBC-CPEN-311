module task2(input logic CLOCK_50, input logic [3:0] KEY,
             input logic [9:0] SW, output logic [9:0] LEDR,
             output logic [6:0] HEX0, output logic [6:0] HEX1, output logic [6:0] HEX2,
             output logic [6:0] HEX3, output logic [6:0] HEX4, output logic [6:0] HEX5,
             output logic [7:0] VGA_R, output logic [7:0] VGA_G, output logic [7:0] VGA_B,
             output logic VGA_HS, output logic VGA_VS, output logic VGA_CLK,
             output logic [7:0] VGA_X, output logic [6:0] VGA_Y,
             output logic [2:0] VGA_COLOUR, output logic VGA_PLOT);

logic start;
logic done;
logic rst_n;
logic [7:0] vga_x;
logic [6:0] vga_y;
logic [2:0] vga_colour;
logic vga_plot;

logic [9:0] VGA_R_10;
logic [9:0] VGA_G_10;
logic [9:0] VGA_B_10;
logic VGA_BLANK, VGA_SYNC;

assign rst_n = KEY[3];

always @ (posedge CLOCK_50 or negedge rst_n) begin
if (rst_n == 0)
	start = 0;
else if (rst_n == 1 && ~done)
	start = 1;
else start = 0;
end


fillscreen fs (
.clk (CLOCK_50),
.rst_n (rst_n),
.colour (SW[2:0]),
.start (start),
.done (done),
.vga_x (vga_x),
.vga_y (vga_y),
.vga_colour (vga_colour),
.vga_plot (vga_plot)
);

assign VGA_R = VGA_R_10[9:2];
assign VGA_G = VGA_G_10[9:2];
assign VGA_B = VGA_B_10[9:2];

vga_adapter#(.RESOLUTION("160x120")) adapter(.resetn(rst_n), .clock(CLOCK_50), .colour(vga_colour),
                                            .x(vga_x), .y(vga_y), .plot(vga_plot),
                                            .VGA_R(VGA_R_10), .VGA_G(VGA_G_10), .VGA_B(VGA_B_10), 
                                            .VGA_HS(VGA_HS), .VGA_VS(VGA_VS), .VGA_CLK(VGA_CLK),
											.VGA_BLANK (VGA_BLANK), .VGA_SYNC (VGA_SYNC));

assign VGA_X = vga_x;
assign VGA_Y = vga_y;
assign VGA_COLOUR = vga_colour;
assign VGA_PLOT = vga_plot;

endmodule: task2

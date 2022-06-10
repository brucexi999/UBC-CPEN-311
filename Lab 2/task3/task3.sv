module task3(input logic CLOCK_50, input logic [3:0] KEY,
             input logic [9:0] SW, output logic [9:0] LEDR,
             output logic [6:0] HEX0, output logic [6:0] HEX1, output logic [6:0] HEX2,
             output logic [6:0] HEX3, output logic [6:0] HEX4, output logic [6:0] HEX5,
             output logic [7:0] VGA_R, output logic [7:0] VGA_G, output logic [7:0] VGA_B,
             output logic VGA_HS, output logic VGA_VS, output logic VGA_CLK,
             output logic [7:0] VGA_X, output logic [6:0] VGA_Y,
             output logic [2:0] VGA_COLOUR, output logic VGA_PLOT);

logic [7:0] centre_x;
logic [6:0] centre_y;
logic [7:0] radius;
logic start1;
logic done1;
logic start2;
logic done2;
logic [2:0] black;
logic [7:0] vga_x1;
logic [7:0] vga_x2;
logic [6:0] vga_y1;
logic [6:0] vga_y2;
logic [2:0] vga_colour1;
logic [2:0] vga_colour2;
logic vga_plot1;
logic vga_plot2;

logic [7:0] vga_x;
logic [6:0] vga_y;
logic [2:0] vga_colour;
logic vga_plot;

logic [9:0] VGA_R_10;
logic [9:0] VGA_G_10;
logic [9:0] VGA_B_10;
logic VGA_BLANK, VGA_SYNC;

assign VGA_R = VGA_R_10[9:2];
assign VGA_G = VGA_G_10[9:2];
assign VGA_B = VGA_B_10[9:2];
assign VGA_X = vga_x;
assign VGA_Y = vga_y;
assign VGA_COLOUR = vga_colour;
assign VGA_PLOT = vga_plot;
assign centre_x = 80;
assign centre_y = 60;
assign radius = 40;
assign black = 3'b000;


always @ (posedge CLOCK_50 or negedge KEY[3]) begin
if (KEY[3] == 0) begin
	start1 = 0; 
	start2 = 0;
	end
	
else if (KEY[3] == 1 && ~done1)
	start1 = 1;
else if (KEY[3] == 1 && done1 && ~done2) begin
	start1 = 0;
	start2 = 1;
	end
else if (KEY[3] == 1 && done1 && done2) begin
	start1 = 0;
	start2 = 0;
	end
end

always@ (posedge CLOCK_50) begin
if (start1 == 1) begin
	vga_x = vga_x1;
	vga_y = vga_y1;
	vga_colour = vga_colour1;
	vga_plot = vga_plot1;
	end
else if (start2 == 1) begin
	vga_x = vga_x2;
	vga_y = vga_y2;
	vga_colour = vga_colour2;
	vga_plot = vga_plot2;
	end 
end




fillscreen1 fs1 (
.clk (CLOCK_50),
.rst_n (KEY[3]),
.colour (black),
.start (start1),
.done (done1),
.vga_x (vga_x1),
.vga_y (vga_y1),
.vga_colour (vga_colour1),
.vga_plot (vga_plot1)
);

circle CIRCLE (
.clk (CLOCK_50),
.rst_n (KEY[3]),
.colour (SW[2:0]),
.centre_x (centre_x),
.centre_y (centre_y),
.radius (radius),
.start (start2),
.done (done2),
.vga_x (vga_x2),
.vga_y (vga_y2),
.vga_colour (vga_colour2),
.vga_plot (vga_plot2)

);

vga_adapter#(.RESOLUTION("160x120")) adapter(.resetn(KEY[3]), .clock(CLOCK_50), .colour(vga_colour),
                                            .x(vga_x), .y(vga_y), .plot(vga_plot),
                                            .VGA_R(VGA_R_10), .VGA_G(VGA_G_10), .VGA_B(VGA_B_10), 
                                            .VGA_HS(VGA_HS), .VGA_VS(VGA_VS), .VGA_CLK(VGA_CLK),
											.VGA_BLANK (VGA_BLANK), .VGA_SYNC (VGA_SYNC));



endmodule: task3

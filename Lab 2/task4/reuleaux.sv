module reuleaux(input logic clk, input logic rst_n, input logic [2:0] colour,
                input logic [7:0] centre_x, input logic [6:0] centre_y, input logic [7:0] diameter,
                input logic start, output logic done,
                output logic [7:0] vga_x, output logic [6:0] vga_y,
                output logic [2:0] vga_colour, output logic vga_plot);

logic [7:0] centre_y8;
logic [7:0] x1, x2, x3;
logic [7:0] y1, y2, y3;
logic [2:0] vga_colour1, vga_colour2, vga_colour3;
logic vga_plot1, vga_plot2, vga_plot3;
logic start1, start2, start3;
logic done1, done2, done3; 


assign centre_y8 = {1'b0,centre_y};

reuleaux_fsm1 FSM1(
.clk (clk),
.rst_n (rst_n),
.colour (colour),
.centre_x (centre_x),
.centre_y (centre_y8),
.diameter (diameter),
.start (start1),
.done (done1),
.x (x1),
.y (y1),
.vga_colour (vga_colour1),
.plot (vga_plot1)
);

reuleaux_fsm2 FSM2(
.clk (clk),
.rst_n (rst_n),
.colour (colour),
.centre_x (centre_x),
.centre_y (centre_y8),
.diameter (diameter),
.start (start2),
.done (done2),
.x (x2),
.y (y2),
.vga_colour (vga_colour2),
.plot (vga_plot2)
);

reuleaux_fsm3 FSM3(
.clk (clk),
.rst_n (rst_n),
.colour (colour),
.centre_x (centre_x),
.centre_y (centre_y8),
.diameter (diameter),
.start (start3),
.done (done3),
.x (x3),
.y (y3),
.vga_colour (vga_colour3),
.plot (vga_plot3)
);

always @ (posedge clk or negedge rst_n) begin
if (rst_n == 0) begin
	start1 = 0;
	start2 = 0;
	start3 = 0;
	done = 0;
	end
else if (start == 1 && done1 == 0) begin
	start1 = 1;
	start2 = 0;
	start3 = 0;
	done = 0;
	end
else if (start == 1 && done1 == 1 && done2 ==0) begin
	start1 = 0;
	start2 = 1;
	start3 = 0;
	done = 0;
	end
else if (start == 1 && done1 == 1 && done2 == 1 && done3 ==0) begin
	start1 = 0;
	start2 = 0;
	start3 = 1;
	done = 0;
	end
else if (start == 1 && done1 == 1 && done2 == 1 && done3 ==1) begin
	start1 = 0;
	start2 = 0;
	start3 = 0;
	done = 1;
	end
end

always @ (posedge clk) begin
if (start1 == 1) begin
	vga_x = x1;
	vga_y = y1[6:0];
	vga_colour = vga_colour1;
	vga_plot = vga_plot1;
	end
else if (start2 == 1) begin
	vga_x = x2;
	vga_y = y2[6:0];
	vga_colour = vga_colour2;
	vga_plot = vga_plot2;
	end
else if (start3 == 1) begin
	vga_x = x3;
	vga_y = y3[6:0];
	vga_colour = vga_colour3;
	vga_plot = vga_plot3;
	end
end
endmodule


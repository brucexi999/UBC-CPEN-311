module reuleaux_fsm2 (
input logic clk,
input logic rst_n,
input logic [2:0] colour,
input logic signed  [7:0] centre_x,
input logic signed [7:0] centre_y,
input logic signed [7:0] diameter,
input logic start,
output logic done,
output logic signed [7:0] x,
output logic signed [7:0] y,
output logic [2:0] vga_colour,
output logic plot
);

logic [3:0] present_state;
logic [3:0] next_state;
logic signed [7:0] offset_y;
logic signed [7:0] offset_x;
logic signed [7:0] crit;
logic signed [7:0] centre_x2;
logic signed [7:0] centre_y2;
logic signed [7:0] boundry_x2;
logic signed [7:0] boundry_y2;


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

always @* begin
centre_x2 = centre_x - diameter/2;
centre_y2 = centre_y + diameter * 289 / 1000;
boundry_x2 = centre_x;
boundry_y2 = centre_y2;
end


always @ (posedge clk or negedge rst_n) begin
	if (rst_n == 0) begin
		present_state = `S0;
		next_state = `S0;
		//offset_y = 0;
		//offset_x = r;
		//crit = 1 - r;
		x = 0;
		y = 0;
		vga_colour = 0;
		plot = 0;
		done = 0;
		
	end else begin
		case (present_state)
		`S0: if (start == 1 && offset_y <= offset_x)
				next_state = `S1;
			 else if (start == 1 && offset_y > offset_x)
				next_state = `S11;
			 else if (start == 0)
				next_state = `S0;
		`S1: next_state = `S2;
		`S2: next_state = `S3;
		`S3: next_state = `S4;
		`S4: next_state = `S5;
		`S5: next_state = `S6;
		`S6: next_state = `S7;
		`S7: next_state = `S8;
		`S8: if (crit <= 0)
				next_state = `S9;
			 else 
				next_state = `S10;
		`S9: if (start == 1 && offset_y <= offset_x)
				next_state = `S1;
			 else if (start == 1 && offset_y > offset_x)
				next_state = `S11;
			 else if (start == 0)
				next_state = `S0;
		`S10: if (start == 1 && offset_y <= offset_x)
				next_state = `S1;
			 else if (start == 1 && offset_y > offset_x)
				next_state = `S11;
			 else if (start == 0)
				next_state = `S0;
		`S11: next_state = `S11;
		endcase
		
		present_state = next_state;
		
		case (present_state)
			`S0: begin
			     offset_y = 0;
				 offset_x = diameter;
				 crit = 1 - diameter;
				 done = 0;
				 x = 0;
				 y = 0;
				 vga_colour = 0;
				 plot = 0;
				 end
				 
			`S1: begin
				 x = centre_x2 + offset_x;
				 y = centre_y2 + offset_y;
				 if (x >= 0 && x <= 159 && y >= 0 && y<= 119 && x >= boundry_x2 && y <= boundry_y2)
					plot = 1;
				 else plot = 0;
				 done = 0;
				 vga_colour = colour;
				 end
				 
			`S2: begin
				 x = centre_x2 + offset_y;
				 y = centre_y2 + offset_x;
				 if (x >= 0 && x <= 159 && y >= 0 && y<= 119 && x >= boundry_x2 && y <= boundry_y2)
					plot = 1;
				 else plot = 0;
				 done = 0;
				 vga_colour = colour;
				 end
				 
			`S3: begin
				 x = centre_x2 - offset_x;
				 y = centre_y2 + offset_y;
				 if (x >= 0 && x <= 159 && y >= 0 && y<= 119 && x >= boundry_x2 && y <= boundry_y2)
					plot = 1;
				 else plot = 0;
				 done = 0;
				 vga_colour = colour;
				 end
				 
			`S4: begin
				 x = centre_x2 - offset_y;
				 y = centre_y2 + offset_x;
				 if (x >= 0 && x <= 159 && y >= 0 && y<= 119 && x >= boundry_x2 && y <= boundry_y2)
					plot = 1;
				 else plot = 0;
				 done = 0;
				 vga_colour = colour;
				 end
			
			`S5: begin
				 x = centre_x2 - offset_x;
				 y = centre_y2 - offset_y;
				 if (x >= 0 && x <= 159 && y >= 0 && y<= 119 && x >= boundry_x2 && y <= boundry_y2)
					plot = 1;
				 else plot = 0;
				 done = 0;
				 vga_colour = colour;
				 end
			
			`S6: begin
				 x = centre_x2 - offset_y;
				 y = centre_y2 - offset_x;
				 if (x >= 0 && x <= 159 && y >= 0 && y<= 119 && x >= boundry_x2 && y <= boundry_y2)
					plot = 1;
				 else plot = 0;
				 done = 0;
				 vga_colour = colour;
				 end
				 
			`S7: begin
				 x = centre_x2 + offset_x;
				 y = centre_y2 - offset_y;
				 if (x >= 0 && x <= 159 && y >= 0 && y<= 119 && x >= boundry_x2 && y <= boundry_y2)
					plot = 1;
				 else plot = 0;
				 done = 0;
				 vga_colour = colour;
				 end
			
			`S8: begin
				 x = centre_x2 + offset_y;
				 y = centre_y2 - offset_x;
				 if (x >= 0 && x <= 159 && y >= 0 && y<= 119 && x >= boundry_x2 && y <= boundry_y2)
					plot = 1;
				 else plot = 0;
				 done = 0;
				 vga_colour = colour;
				 end
				 
			`S9: begin
				 offset_y = offset_y +1;
				 crit = crit + 2 * offset_y + 1 ;
				 end
				 
			`S10: begin
				  offset_y = offset_y +1;
				  offset_x = offset_x -1;
				  crit = crit + 2 * (offset_y - offset_x) + 1; 
				  end
				  
			`S11: begin
				  done = 1;
				  plot = 0;
				  vga_colour = colour;
				  end
		endcase
	end
end
endmodule

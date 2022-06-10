module fillscreen2(input logic clk, input logic rst_n, input logic [2:0] colour,
                  input logic start, output logic done, 
                  output logic [7:0] vga_x, output logic [6:0] vga_y,
                  output logic [2:0] vga_colour, output logic vga_plot
				  );
				  
logic x_load;
logic y_load;
logic x_count;
logic y_count;
logic x_done;
logic y_done;
logic [7:0] x;
logic [6:0] y;


counter_x cx (
.clk (clk),
.rst_n (rst_n),
.load (x_load),
.count (x_count),
.done (x_done),
.Q (x)
);

counter_y cy(
.clk (clk),
.rst_n (rst_n),
.load (y_load),
.count (y_count),
.done (y_done),
.Q (y)
);

fsm_fillscreen FSM (
.clk (clk),
.rst_n (rst_n),
.x_done (x_done),
.y_done (y_done),
.start (start),
.x_load (x_load),
.y_load (y_load),
.x_count (x_count),
.y_count (y_count),
.done (done)
);

assign vga_x = x;
assign vga_y = y; 

always@* begin
vga_colour = colour; 
if (start == 1 && done == 0)
	vga_plot = 1;
else if (start == 0 || done == 1)
	vga_plot = 0;
end

endmodule




module vga_avalon(input logic clk, input logic reset_n,
                  input logic [3:0] address,
                  input logic read, output logic [31:0] readdata,
                  input logic write, input logic [31:0] writedata,
                  output logic [7:0] VGA_R, output logic [7:0] VGA_G, output logic [7:0] VGA_B,
                  output logic VGA_HS, output logic VGA_VS, output logic VGA_CLK);

    
    logic [9:0] VGA_R_10, VGA_G_10, VGA_B_10;
	logic plot; 
	logic unsigned [7:0] x; 
	logic unsigned [6:0] y; //x annd y will be signed, to see whether they fall into the screen. 
	logic [2:0] colour; 
	
	assign colour = writedata [18:16]; 
	assign x = writedata [15:8];
	assign y = writedata [6:0]; // writedata contains all the signals VGA needs. 
	
	always@* begin
		if (~reset_n) 
			plot = 0;
		else if (write && x >= 0 && x < 160 && y>=0 && y < 120 && address == 4'b0)
			plot = 1; //If x and y fall into the screen, write is asserted, and address offset is 0, then assert plot. 
		else 
			plot = 0; 
	end

    vga_adapter #(.RESOLUTION("160x120")) vga(
	.resetn (reset_n),
	.clock (clk), 
	.colour (colour),
	.x (x), 
	.y (y), 
	.plot (plot), 
	.VGA_R (VGA_R_10),
	.VGA_G (VGA_G_10),
	.VGA_B (VGA_B_10),
	.VGA_HS (VGA_HS),
	.VGA_VS (VGA_VS),
	.VGA_CLK (VGA_CLK)
	);
	
	assign VGA_R = VGA_R_10 [7:0]; 
	assign VGA_G = VGA_G_10 [7:0];
	assign VGA_B = VGA_B_10 [7:0]; //VGA core outputs RGB with 10 bit precison, but we only use the low 8 bits. 
    // NOTE: We will ignore the SYNC and BLANK signals.
    //       Either don't connect them or connect them to dangling wires.
    //       In addition, the VGA_{R,G,B} should be the low 8 bits of the VGA module outputs.

endmodule: vga_avalon
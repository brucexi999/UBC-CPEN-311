module tb_vga_avalon();
	
	logic clk, reset_n, write;
	logic [3:0] address; 
	logic [31:0] writedata; 
	logic [7:0] VGA_R, VGA_G, VGA_B; 
	logic VGA_HS, VGA_VS, VGA_CLK; 
	
	vga_avalon dut (
	.clk (clk),
	.reset_n (reset_n),
	.address (address),
	.write (write),
	.writedata (writedata),
	.VGA_R (VGA_R),
	.VGA_G (VGA_G), 
	.VGA_B (VGA_B), 
	.VGA_HS (VGA_HS), 
	.VGA_VS (VGA_VS),
	.VGA_CLK (VGA_CLK)
	); 
	
	initial begin
		clk = 1;
		forever #5 clk = ~clk;
	end
	
	initial begin
		reset_n = 0; #5;
		reset_n = 1; #5; 
		#10;
		write = 1; writedata = {13'b0, 3'b001, 8'b0, 1'b0, 7'b0}; address = 4'b0000; 
		#20;
		$display ("Checking |write|");
		write = 0; 
		#20;
		write = 1; writedata = {13'b0, 3'b101, 8'b00000010, 1'b0, 7'b0000001}; address = 4'b0000;
		#20;
		$display ("Checking |address|");
		address = 4'b0010; 
		#20;
		$display ("Checking x, y range");
		writedata = {13'b0, 3'b101, 8'b10100000, 1'b0, 7'b1111000}; address = 4'b0000; // x= 160, y = 120. 
		#20; 
		$stop;
	end
	
endmodule: tb_vga_avalon

module vga_adapter (
input logic clock, 
input logic resetn, 
input logic [2:0] colour, 
input signed [7:0] x, 
input signed [6:0] y, 
input logic plot, 
output logic [9:0] VGA_R,
output logic [9:0] VGA_G, 
output logic [9:0] VGA_B,
output logic VGA_HS, 
output logic VGA_VS, 
output logic VGA_CLK
);
	parameter RESOLUTION = "160x120";
	always @ (posedge clock or negedge resetn) begin
		if (~resetn) begin
			VGA_R = 10'b0; 
			VGA_G = 10'b0; 
			VGA_B = 10'b0;
			VGA_HS = 0; 
			VGA_VS = 0; 
			VGA_CLK = 0;
		end
		else if (plot) begin
			VGA_R = {9'b0, colour[0]};
			VGA_G = {9'b0, colour[1]};
			VGA_B = {9'b0, colour[2]};
			VGA_HS = 1; 
			VGA_VS = 1; 
			VGA_CLK = 1;
		end
	end

endmodule: vga_adapter

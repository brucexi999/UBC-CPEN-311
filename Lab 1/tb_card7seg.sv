`timescale 1 ns / 1 ns

module tb_card7seg();
	reg [3:0] sim_SW;
	wire [6:0] sim_HEX0;
	card7seg DUT (.SW(sim_SW), .HEX0(sim_HEX0));
	initial begin
		sim_SW = 4'b0000;
		#5;
		$display("Output is %b, we expected %b", sim_HEX0, 7'b1111111);
		
		sim_SW = 4'b0001;
		#5;
		$display("Output is %b, we expected %b", sim_HEX0, 7'b0001000);
		
		sim_SW = 4'b0010;
		#5;
		$display("Output is %b, we expected %b", sim_HEX0, 7'b0100100);
		
		sim_SW = 4'b0011;
		#5;
		$display("Output is %b, we expected %b", sim_HEX0, 7'b0110000);
		
		sim_SW = 4'b0100;
		#5;
		$display("Output is %b, we expected %b", sim_HEX0, 7'b0011001);
		
		sim_SW = 4'b0101;
		#5;
		$display("Output is %b, we expected %b", sim_HEX0, 7'b0010010);
		
		sim_SW = 4'b0110;
		#5;
		$display("Output is %b, we expected %b", sim_HEX0, 7'b0000010);
		
		sim_SW = 4'b0111;
		#5;
		$display("Output is %b, we expected %b", sim_HEX0, 7'b1111000);
		
		sim_SW = 4'b1000;
		#5;
		$display("Output is %b, we expected %b", sim_HEX0, 7'b0000000);
		
		sim_SW = 4'b1001;
		#5;
		$display("Output is %b, we expected %b", sim_HEX0, 7'b0010000);
		
		sim_SW = 4'b1010;
		#5;
		$display("Output is %b, we expected %b", sim_HEX0, 7'b1000000);
		
		sim_SW = 4'b1011;
		#5;
		$display("Output is %b, we expected %b", sim_HEX0, 7'b1100001);
		
		sim_SW = 4'b1100;
		#5;
		$display("Output is %b, we expected %b", sim_HEX0, 7'b0011000);
		
		sim_SW = 4'b1101;
		#5;
		$display("Output is %b, we expected %b", sim_HEX0, 7'b0001001);
		
		sim_SW = 4'b1110;
		#5;
		$display("Output is %b, we expected %b", sim_HEX0, 7'b1111111);
		
		sim_SW = 4'b1111;
		#5;
		$display("Output is %b, we expected %b", sim_HEX0, 7'b1111111);
		$stop;
	end
endmodule


`timescale 1 ns / 1 ns

module tb_scorehand();
	reg [3:0] sim_card1;
	reg [3:0] sim_card2;
	reg [3:0] sim_card3;
	
	wire [3:0] sim_total;
	
	scorehand DUT (.card1(sim_card1), .card2(sim_card2), .card3(sim_card3), .total(sim_total));
	
	initial begin
		sim_card1 = 4'b0001; 
		sim_card2 = 4'b1001;
		sim_card3 = 4'b0110;
		#5;
		
		sim_card1 = 4'b1001; 
		sim_card2 = 4'b1000;
		sim_card3 = 4'b0000;
		#5;
		
		sim_card1 = 4'b0011; 
		sim_card2 = 4'b1010;
		sim_card3 = 4'b0010;
		#5;
	end 
	
endmodule


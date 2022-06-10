`timescale 1 ps / 1 ps

module tb_reg4 ();
	reg [3:0] sim_new_card;
	reg sim_load_card = 0;
	reg sim_resetb = 1;
	reg sim_slow_clock = 0;
	wire [3:0] sim_card_out;
	
	reg4 DUT (
	.new_card(sim_new_card),
	.load_card(sim_load_card),
	.resetb(sim_resetb),
	.slow_clock(sim_slow_clock),
	.card_out(sim_card_out)
	); 
	
	always begin
		sim_slow_clock = ~ sim_slow_clock;
		#15;
	end
	
	initial begin
		sim_resetb = 0;
		#5;
		sim_resetb = 1;
		sim_new_card = 4'b1101;
		#40;
		
		
		sim_load_card = 1;
		sim_new_card = 4'b1101;
		#40;
		sim_new_card = 4'b0000;
		#40;
		sim_new_card = 4'b0110;
		#40;
		sim_resetb = 0; 
		#40;
		
		$stop; 
	end
	

endmodule
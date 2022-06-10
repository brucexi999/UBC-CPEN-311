`timescale 1ns/1ns

module tb_datapath();

reg sim_slow_clock = 0;
reg sim_fast_clock = 0;
reg sim_resetb = 1;
reg sim_load_pcard1 = 0;
reg sim_load_pcard2 = 0;
reg sim_load_pcard3 = 0;
reg sim_load_dcard1 = 0;
reg sim_load_dcard2 = 0;
reg sim_load_dcard3 = 0;

wire [3:0] sim_pcard3_out;
wire [3:0] sim_pscore_out;
wire [3:0] sim_dscore_out;

wire [6:0] sim_HEX0;
wire [6:0] sim_HEX1; 
wire [6:0] sim_HEX2; 
wire [6:0] sim_HEX3; 
wire [6:0] sim_HEX4; 
wire [6:0] sim_HEX5; 



datapath DUT (
.slow_clock (sim_slow_clock),
.fast_clock (sim_fast_clock),
.resetb (sim_resetb),
.load_pcard1 (sim_load_pcard1),
.load_pcard2 (sim_load_pcard2),
.load_pcard3 (sim_load_pcard3),
.load_dcard1 (sim_load_dcard1),
.load_dcard2 (sim_load_dcard2),
.load_dcard3 (sim_load_dcard3),
.pcard3_out (sim_pcard3_out),
.pscore_out (sim_pscore_out),
.dscore_out (sim_dscore_out),
.HEX0 (sim_HEX0),
.HEX1 (sim_HEX1),
.HEX2 (sim_HEX2),
.HEX3 (sim_HEX3),
.HEX4 (sim_HEX4),
.HEX5 (sim_HEX5)
 );


always begin
	sim_slow_clock = ~ sim_slow_clock;
	#10;
end 

always begin
	sim_fast_clock = ~ sim_fast_clock;
	#5;
end 

initial begin
	sim_resetb = 0;
	#5
	sim_resetb = 1;
	#20;
	sim_load_pcard1 = 1;
	#5;
	sim_load_dcard1 = 1;
	#20;
	sim_load_pcard1 = 0;
	sim_load_dcard1 = 0;
	sim_load_pcard2 = 1;
	#5;
	sim_load_dcard2 = 1;
	#20;
	sim_load_pcard2 = 0;
	sim_load_dcard2 = 0;
	sim_load_pcard3 = 1;
	#30;
	sim_resetb = 0;
	#50;
	$stop; 
end 	
endmodule


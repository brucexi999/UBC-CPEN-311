
module tb_statemachine();

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
`define S12 4'b1100
`define S13 4'b1101

reg sim_slow_clock;
reg sim_resetb;
reg err;
reg [3:0] sim_dscore;
reg [3:0] sim_pscore;
reg [3:0] sim_pcard3;

wire sim_load_pcard1;
wire sim_load_pcard2;
wire sim_load_pcard3;
wire sim_load_dcard1;
wire sim_load_dcard2;
wire sim_load_dcard3;
wire sim_player_win_light ;
wire sim_dealer_win_light ;

statemachine DUT (
.slow_clock (sim_slow_clock), 
.resetb (sim_resetb), 
.dscore (sim_dscore), 
.pscore (sim_pscore), 
.pcard3 (sim_pcard3), 
.load_pcard1 (sim_load_pcard1),  
.load_pcard2 (sim_load_pcard2), 
.load_pcard3 (sim_load_pcard3), 
.load_dcard1 (sim_load_dcard1), 
.load_dcard2 (sim_load_dcard2), 
.load_dcard3 (sim_load_dcard3), 
.player_win_light (sim_player_win_light), 
.dealer_win_light (sim_dealer_win_light)
); 

task check;
	input [3:0] expected_state;
	input expected_player_win_light;
	input expected_dealer_win_light;
	input expected_load_pcard1;
	input expected_load_pcard2;
	input expected_load_pcard3;
	input expected_load_dcard1;
	input expected_load_dcard2;
	input expected_load_dcard3;
	
begin
	if (tb_statemachine.DUT.present_state !== expected_state) begin
		$display ("ERROR, state is %b, expected %b", tb_statemachine.DUT.present_state, expected_state);
		err = 1'b1;
	end
	
	if (sim_player_win_light !== expected_player_win_light) begin
		$display ("ERROR, player_win_light is %b, expected %b", sim_player_win_light, expected_player_win_light);
		err = 1'b1;
	end
	
	if (sim_dealer_win_light !== expected_dealer_win_light) begin
		$display ("ERROR, dealer_win_light is %b, expected %b", sim_dealer_win_light, expected_dealer_win_light);
		err = 1'b1; 
	end
	
	if (sim_load_pcard1 !== expected_load_pcard1) begin
		$display ("ERROR, load_pcard1 is %b, expected %b", sim_load_pcard1, expected_load_pcard1);
		err = 1'b1; 
	end
	
	if (sim_load_pcard2 !== expected_load_pcard2) begin
		$display ("ERROR, load_pcard2 is %b, expected %b", sim_load_pcard2, expected_load_pcard2);
		err = 1'b1; 
	end
	
	if (sim_load_pcard3 !== expected_load_pcard3) begin
		$display ("ERROR, load_pcard3 is %b, expected %b", sim_load_pcard3, expected_load_pcard3);
		err = 1'b1; 
	end
	
	if (sim_load_dcard1 !== expected_load_dcard1) begin
		$display ("ERROR, load_dcard1 is %b, expected %b", sim_load_dcard1, expected_load_dcard1);
		err = 1'b1; 
	end
	
	if (sim_load_dcard2 !== expected_load_dcard2) begin
		$display ("ERROR, load_dcard2 is %b, expected %b", sim_load_dcard2, expected_load_dcard2);
		err = 1'b1; 
	end
	
	if (sim_load_dcard3 !== expected_load_dcard3) begin
		$display ("ERROR, load_dcard3 is %b, expected %b", sim_load_dcard3, expected_load_dcard3);
		err = 1'b1; 
	end
end
endtask
	

initial begin
	sim_slow_clock = 0; #5;
	forever begin
		sim_slow_clock = 1; #5;
		sim_slow_clock = 0; #5;
	end
end

initial begin
	sim_resetb = 0; err = 0; sim_pscore = 4'b0000; sim_dscore = 4'b0000; sim_pcard3 = 4'b0000; #10; 
	
	$display("checking S0");
	check(`S0, 0,0,0,0,0,0,0,0);
	sim_resetb = 1; 
	
	$display("checking S0->S1"); #10;
	check(`S1, 0,0,1,0,0,0,0,0); 
	
	$display("checking S1->S2"); #10;
	check(`S2, 0,0,0,0,0,1,0,0); 
	
	$display("checking S2->S3"); #10;
	check(`S3, 0,0,0,1,0,0,0,0); 
	
	$display("checking S3->S4"); #10;
	check(`S4, 0,0,0,0,0,0,1,0); 
	
	$display("checking S4->S12"); #10;
	check(`S12, 0,0,0,0,0,0,0,0); 
	
	$display("checking S12->S5");
	sim_pscore = 8; #10;
	check(`S5, 0,0,0,0,0,0,0,0);
	
	$display("checking S5->S6");
	sim_dscore = 7; #10;
	check(`S6, 1,0,0,0,0,0,0,0);
	//----------------------------------------------
	
	sim_resetb = 0; err = 0; sim_pscore = 4'b0000; sim_dscore = 4'b0000; sim_pcard3 = 4'b0000; #10; 
	
	$display("checking S0");
	check(`S0, 0,0,0,0,0,0,0,0);
	sim_resetb = 1; 
	
	$display("checking S0->S1"); #10;
	check(`S1, 0,0,1,0,0,0,0,0); 
	
	$display("checking S1->S2"); #10;
	check(`S2, 0,0,0,0,0,1,0,0); 
	
	$display("checking S2->S3"); #10;
	check(`S3, 0,0,0,1,0,0,0,0); 
	
	$display("checking S3->S4"); #10;
	check(`S4, 0,0,0,0,0,0,1,0); 
	
	$display("checking S4->S12"); #10;
	check(`S12, 0,0,0,0,0,0,0,0); 
	
	$display("checking S12->S5");
	sim_pscore = 8; #10;
	check(`S5, 0,0,0,0,0,0,0,0);
	
	$display("checking S5->S7");
	sim_dscore = 9; #10;
	check(`S7, 0,1,0,0,0,0,0,0);
	//----------------------------------------------
	
	sim_resetb = 0; err = 0; sim_pscore = 4'b0000; sim_dscore = 4'b0000; sim_pcard3 = 4'b0000; #10; 
	
	$display("checking S0");
	check(`S0, 0,0,0,0,0,0,0,0);
	sim_resetb = 1; 
	
	$display("checking S0->S1"); #10;
	check(`S1, 0,0,1,0,0,0,0,0); 
	
	$display("checking S1->S2"); #10;
	check(`S2, 0,0,0,0,0,1,0,0); 
	
	$display("checking S2->S3"); #10;
	check(`S3, 0,0,0,1,0,0,0,0); 
	
	$display("checking S3->S4"); #10;
	check(`S4, 0,0,0,0,0,0,1,0); 
	
	$display("checking S4->S12"); #10;
	check(`S12, 0,0,0,0,0,0,0,0); 
	
	$display("checking S12->S5");
	sim_pscore = 8; #10;
	check(`S5, 0,0,0,0,0,0,0,0);
	
	$display("checking S5->S8");
	sim_dscore = 8; #10;
	check(`S8, 1,1,0,0,0,0,0,0);
	//----------------------------------------------
	
	sim_resetb = 0; err = 0; sim_pscore = 4'b0000; sim_dscore = 4'b0000; sim_pcard3 = 4'b0000; #10; 
	
	$display("checking S0");
	check(`S0, 0,0,0,0,0,0,0,0);
	sim_resetb = 1; 
	
	$display("checking S0->S1"); #10;
	check(`S1, 0,0,1,0,0,0,0,0); 
	
	$display("checking S1->S2"); #10;
	check(`S2, 0,0,0,0,0,1,0,0); 
	
	$display("checking S2->S3"); #10;
	check(`S3, 0,0,0,1,0,0,0,0); 
	
	$display("checking S3->S4"); #10;
	check(`S4, 0,0,0,0,0,0,1,0); 
	
	$display("checking S4->S12"); #10;
	check(`S12, 0,0,0,0,0,0,0,0); 
	
	$display("checking S12->S11");
	sim_pscore = 6; #10;
	check(`S11, 0,0,0,0,0,0,0,0);
	
	$display("checking S11->S10");
	sim_dscore = 5; #10;
	check(`S10, 0,0,0,0,0,0,0,1);
	
	$display("checking S10->S5");
	#10;
	check(`S5, 0,0,0,0,0,0,0,0);
	
	$display("checking S5->S7");
	sim_dscore = 7; #10;
	check(`S7, 0,1,0,0,0,0,0,0);
	//----------------------------------------------
	
	sim_resetb = 0; err = 0; sim_pscore = 4'b0000; sim_dscore = 4'b0000; sim_pcard3 = 4'b0000; #10; 
	
	$display("checking S0");
	check(`S0, 0,0,0,0,0,0,0,0);
	sim_resetb = 1; 
	
	$display("checking S0->S1"); #10;
	check(`S1, 0,0,1,0,0,0,0,0); 
	
	$display("checking S1->S2"); #10;
	check(`S2, 0,0,0,0,0,1,0,0); 
	
	$display("checking S2->S3"); #10;
	check(`S3, 0,0,0,1,0,0,0,0); 
	
	$display("checking S3->S4"); #10;
	check(`S4, 0,0,0,0,0,0,1,0); 
	
	$display("checking S4->S12"); #10;
	check(`S12, 0,0,0,0,0,0,0,0); 
	
	$display("checking S12->S11");
	sim_pscore = 6; #10;
	check(`S11, 0,0,0,0,0,0,0,0);
	
	$display("checking S11->S5");
	sim_dscore = 6; #10;
	check(`S5, 0,0,0,0,0,0,0,0);
	
	$display("checking S5->S8");
	#10;
	check(`S8, 1,1,0,0,0,0,0,0);
	//----------------------------------------------
	
	sim_resetb = 0; err = 0; sim_pscore = 4'b0000; sim_dscore = 4'b0000; sim_pcard3 = 4'b0000; #10; 
	
	$display("checking S0");
	check(`S0, 0,0,0,0,0,0,0,0);
	sim_resetb = 1; 
	
	$display("checking S0->S1"); #10;
	check(`S1, 0,0,1,0,0,0,0,0); 
	
	$display("checking S1->S2"); #10;
	check(`S2, 0,0,0,0,0,1,0,0); 
	
	$display("checking S2->S3"); #10;
	check(`S3, 0,0,0,1,0,0,0,0); 
	
	$display("checking S3->S4"); #10;
	check(`S4, 0,0,0,0,0,0,1,0); 
	
	$display("checking S4->S12"); #10;
	check(`S12, 0,0,0,0,0,0,0,0); 
	
	$display("checking S12->S9"); 
	sim_pscore = 4; #10;
	check(`S9, 0,0,0,0,1,0,0,0); 
	
	$display("checking S9->S13"); 
	#10;
	check(`S13, 0,0,0,0,0,0,0,0); 
	
	$display("checking S13->S5"); 
	sim_dscore = 7; #10;
	check(`S5, 0,0,0,0,0,0,0,0);
	//----------------------------------------------
	
	sim_resetb = 0; err = 0; sim_pscore = 4'b0000; sim_dscore = 4'b0000; sim_pcard3 = 4'b0000; #10; 
	
	$display("checking S0");
	check(`S0, 0,0,0,0,0,0,0,0);
	sim_resetb = 1; 
	
	$display("checking S0->S1"); #10;
	check(`S1, 0,0,1,0,0,0,0,0); 
	
	$display("checking S1->S2"); #10;
	check(`S2, 0,0,0,0,0,1,0,0); 
	
	$display("checking S2->S3"); #10;
	check(`S3, 0,0,0,1,0,0,0,0); 
	
	$display("checking S3->S4"); #10;
	check(`S4, 0,0,0,0,0,0,1,0); 
	
	$display("checking S4->S12"); #10;
	check(`S12, 0,0,0,0,0,0,0,0); 
	
	$display("checking S12->S9"); 
	sim_pscore = 4; #10;
	check(`S9, 0,0,0,0,1,0,0,0); 
	
	$display("checking S9->S13"); 
	#10;
	check(`S13, 0,0,0,0,0,0,0,0); 
	
	$display("checking S13->S10"); 
	sim_dscore = 6; sim_pcard3 = 6; #10;
	check(`S10, 0,0,0,0,0,0,0,1);
	//----------------------------------------------
	
	sim_resetb = 0; err = 0; sim_pscore = 4'b0000; sim_dscore = 4'b0000; sim_pcard3 = 4'b0000; #10; 
	
	$display("checking S0");
	check(`S0, 0,0,0,0,0,0,0,0);
	sim_resetb = 1; 
	
	$display("checking S0->S1"); #10;
	check(`S1, 0,0,1,0,0,0,0,0); 
	
	$display("checking S1->S2"); #10;
	check(`S2, 0,0,0,0,0,1,0,0); 
	
	$display("checking S2->S3"); #10;
	check(`S3, 0,0,0,1,0,0,0,0); 
	
	$display("checking S3->S4"); #10;
	check(`S4, 0,0,0,0,0,0,1,0); 
	
	$display("checking S4->S12"); #10;
	check(`S12, 0,0,0,0,0,0,0,0); 
	
	$display("checking S12->S9"); 
	sim_pscore = 4; #10;
	check(`S9, 0,0,0,0,1,0,0,0); 
	
	$display("checking S9->S13"); 
	#10;
	check(`S13, 0,0,0,0,0,0,0,0); 
	
	$display("checking S13->S5"); 
	sim_dscore = 6; sim_pcard3 = 3; #10;
	check(`S5, 0,0,0,0,0,0,0,0);
	//----------------------------------------------
	
	sim_resetb = 0; err = 0; sim_pscore = 4'b0000; sim_dscore = 4'b0000; sim_pcard3 = 4'b0000; #10; 
	
	$display("checking S0");
	check(`S0, 0,0,0,0,0,0,0,0);
	sim_resetb = 1; 
	
	$display("checking S0->S1"); #10;
	check(`S1, 0,0,1,0,0,0,0,0); 
	
	$display("checking S1->S2"); #10;
	check(`S2, 0,0,0,0,0,1,0,0); 
	
	$display("checking S2->S3"); #10;
	check(`S3, 0,0,0,1,0,0,0,0); 
	
	$display("checking S3->S4"); #10;
	check(`S4, 0,0,0,0,0,0,1,0); 
	
	$display("checking S4->S12"); #10;
	check(`S12, 0,0,0,0,0,0,0,0); 
	
	$display("checking S12->S9"); 
	sim_pscore = 4; #10;
	check(`S9, 0,0,0,0,1,0,0,0); 
	
	$display("checking S9->S13"); 
	#10;
	check(`S13, 0,0,0,0,0,0,0,0); 
	
	$display("checking S13->S10"); 
	sim_dscore = 5; sim_pcard3 = 6; #10;
	check(`S10, 0,0,0,0,0,0,0,1);
	//----------------------------------------------
	
	sim_resetb = 0; err = 0; sim_pscore = 4'b0000; sim_dscore = 4'b0000; sim_pcard3 = 4'b0000; #10; 
	
	$display("checking S0");
	check(`S0, 0,0,0,0,0,0,0,0);
	sim_resetb = 1; 
	
	$display("checking S0->S1"); #10;
	check(`S1, 0,0,1,0,0,0,0,0); 
	
	$display("checking S1->S2"); #10;
	check(`S2, 0,0,0,0,0,1,0,0); 
	
	$display("checking S2->S3"); #10;
	check(`S3, 0,0,0,1,0,0,0,0); 
	
	$display("checking S3->S4"); #10;
	check(`S4, 0,0,0,0,0,0,1,0); 
	
	$display("checking S4->S12"); #10;
	check(`S12, 0,0,0,0,0,0,0,0); 
	
	$display("checking S12->S9"); 
	sim_pscore = 4; #10;
	check(`S9, 0,0,0,0,1,0,0,0); 
	
	$display("checking S9->S13"); 
	#10;
	check(`S13, 0,0,0,0,0,0,0,0); 
	
	$display("checking S13->S5"); 
	sim_dscore = 5; sim_pcard3 = 9; #10;
	check(`S5, 0,0,0,0,0,0,0,0);
	//----------------------------------------------
	
	sim_resetb = 0; err = 0; sim_pscore = 4'b0000; sim_dscore = 4'b0000; sim_pcard3 = 4'b0000; #10; 
	
	$display("checking S0");
	check(`S0, 0,0,0,0,0,0,0,0);
	sim_resetb = 1; 
	
	$display("checking S0->S1"); #10;
	check(`S1, 0,0,1,0,0,0,0,0); 
	
	$display("checking S1->S2"); #10;
	check(`S2, 0,0,0,0,0,1,0,0); 
	
	$display("checking S2->S3"); #10;
	check(`S3, 0,0,0,1,0,0,0,0); 
	
	$display("checking S3->S4"); #10;
	check(`S4, 0,0,0,0,0,0,1,0); 
	
	$display("checking S4->S12"); #10;
	check(`S12, 0,0,0,0,0,0,0,0); 
	
	$display("checking S12->S9"); 
	sim_pscore = 3; #10;
	check(`S9, 0,0,0,0,1,0,0,0); 
	
	$display("checking S9->S13"); 
	#10;
	check(`S13, 0,0,0,0,0,0,0,0); 
	
	$display("checking S13->S10"); 
	sim_dscore = 4; sim_pcard3 = 4; #10;
	check(`S10, 0,0,0,0,0,0,0,1);
	//----------------------------------------------

	sim_resetb = 0; err = 0; sim_pscore = 4'b0000; sim_dscore = 4'b0000; sim_pcard3 = 4'b0000; #10; 
	
	$display("checking S0");
	check(`S0, 0,0,0,0,0,0,0,0);
	sim_resetb = 1; 
	
	$display("checking S0->S1"); #10;
	check(`S1, 0,0,1,0,0,0,0,0); 
	
	$display("checking S1->S2"); #10;
	check(`S2, 0,0,0,0,0,1,0,0); 
	
	$display("checking S2->S3"); #10;
	check(`S3, 0,0,0,1,0,0,0,0); 
	
	$display("checking S3->S4"); #10;
	check(`S4, 0,0,0,0,0,0,1,0); 
	
	$display("checking S4->S12"); #10;
	check(`S12, 0,0,0,0,0,0,0,0); 
	
	$display("checking S12->S9"); 
	sim_pscore = 3; #10;
	check(`S9, 0,0,0,0,1,0,0,0); 
	
	$display("checking S9->S13"); 
	#10;
	check(`S13, 0,0,0,0,0,0,0,0); 
	
	$display("checking S13->S5"); 
	sim_dscore = 4; sim_pcard3 = 1; #10;
	check(`S5, 0,0,0,0,0,0,0,0);
	//----------------------------------------------
	
	sim_resetb = 0; err = 0; sim_pscore = 4'b0000; sim_dscore = 4'b0000; sim_pcard3 = 4'b0000; #10; 
	
	$display("checking S0");
	check(`S0, 0,0,0,0,0,0,0,0);
	sim_resetb = 1; 
	
	$display("checking S0->S1"); #10;
	check(`S1, 0,0,1,0,0,0,0,0); 
	
	$display("checking S1->S2"); #10;
	check(`S2, 0,0,0,0,0,1,0,0); 
	
	$display("checking S2->S3"); #10;
	check(`S3, 0,0,0,1,0,0,0,0); 
	
	$display("checking S3->S4"); #10;
	check(`S4, 0,0,0,0,0,0,1,0); 
	
	$display("checking S4->S12"); #10;
	check(`S12, 0,0,0,0,0,0,0,0); 
	
	$display("checking S12->S9"); 
	sim_pscore = 3; #10;
	check(`S9, 0,0,0,0,1,0,0,0); 
	
	$display("checking S9->S13"); 
	#10;
	check(`S13, 0,0,0,0,0,0,0,0); 
	
	$display("checking S13->S10"); 
	sim_dscore = 3; sim_pcard3 = 1; #10;
	check(`S10, 0,0,0,0,0,0,0,1);
	//----------------------------------------------
	
	sim_resetb = 0; err = 0; sim_pscore = 4'b0000; sim_dscore = 4'b0000; sim_pcard3 = 4'b0000; #10; 
	
	$display("checking S0");
	check(`S0, 0,0,0,0,0,0,0,0);
	sim_resetb = 1; 
	
	$display("checking S0->S1"); #10;
	check(`S1, 0,0,1,0,0,0,0,0); 
	
	$display("checking S1->S2"); #10;
	check(`S2, 0,0,0,0,0,1,0,0); 
	
	$display("checking S2->S3"); #10;
	check(`S3, 0,0,0,1,0,0,0,0); 
	
	$display("checking S3->S4"); #10;
	check(`S4, 0,0,0,0,0,0,1,0); 
	
	$display("checking S4->S12"); #10;
	check(`S12, 0,0,0,0,0,0,0,0); 
	
	$display("checking S12->S9"); 
	sim_pscore = 3; #10;
	check(`S9, 0,0,0,0,1,0,0,0); 
	
	$display("checking S9->S13"); 
	#10;
	check(`S13, 0,0,0,0,0,0,0,0); 
	
	$display("checking S13->S5"); 
	sim_dscore = 3; sim_pcard3 = 8; #10;
	check(`S5, 0,0,0,0,0,0,0,0);
	//----------------------------------------------
	
	sim_resetb = 0; err = 0; sim_pscore = 4'b0000; sim_dscore = 4'b0000; sim_pcard3 = 4'b0000; #10; 
	
	$display("checking S0");
	check(`S0, 0,0,0,0,0,0,0,0);
	sim_resetb = 1; 
	
	$display("checking S0->S1"); #10;
	check(`S1, 0,0,1,0,0,0,0,0); 
	
	$display("checking S1->S2"); #10;
	check(`S2, 0,0,0,0,0,1,0,0); 
	
	$display("checking S2->S3"); #10;
	check(`S3, 0,0,0,1,0,0,0,0); 
	
	$display("checking S3->S4"); #10;
	check(`S4, 0,0,0,0,0,0,1,0); 
	
	$display("checking S4->S12"); #10;
	check(`S12, 0,0,0,0,0,0,0,0); 
	
	$display("checking S12->S9"); 
	sim_pscore = 3; #10;
	check(`S9, 0,0,0,0,1,0,0,0); 
	
	$display("checking S9->S13"); 
	#10;
	check(`S13, 0,0,0,0,0,0,0,0); 
	
	$display("checking S13->S10"); 
	sim_dscore = 2; #10;
	check(`S10, 0,0,0,0,0,0,0,1);
	//----------------------------------------------
	$stop;
end						
endmodule


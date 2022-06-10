module statemachine(input slow_clock, input resetb,
                    input [3:0] dscore, input [3:0] pscore, input [3:0] pcard3,
                    output reg load_pcard1, output reg load_pcard2,output reg load_pcard3,
                    output reg load_dcard1, output reg load_dcard2, output reg load_dcard3,
                    output reg player_win_light, output reg dealer_win_light);
					
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

reg [3:0] present_state, next_state;

always @(posedge slow_clock or negedge resetb) begin
	if (resetb == 0) begin
		present_state = `S0;
		next_state = `S0;
		load_pcard1 = 0;
		load_pcard2 = 0;
		load_pcard3 = 0;
		load_dcard1 = 0;
		load_dcard2 = 0;
		load_dcard3 = 0;
		player_win_light = 0;
		dealer_win_light = 0;
		
	end else begin
		case (present_state)
			`S0: next_state = `S1;
			`S1: next_state = `S2;
			`S2: next_state = `S3;
			`S3: next_state = `S4;
			`S4: next_state = `S12;
			`S12:if (pscore >=8 || dscore >=8)
					next_state = `S5;
				else if (pscore <= 5)
					next_state = `S9;
				else if (pscore == 6 || pscore ==7)
					next_state = `S11;
			`S5:if (pscore > dscore)
					next_state = `S6;
				else if (dscore > pscore)
					next_state = `S7;
				else if (pscore == dscore)
					next_state = `S8;
			//`S6: next_state = `S0;
			//`S7: next_state = `S0;
			//`S8: next_state = `S0;
			`S9: next_state = `S13;
			`S13:if(dscore == 7)
					next_state = `S5;
				else if (dscore == 6 && (pcard3 == 6 || pcard3 == 7))
					next_state = `S10;
				else if (dscore == 6 && ~(pcard3 == 6 || pcard3 == 7))
					next_state = `S5;
				else if (dscore == 5 && (pcard3 >= 4 && pcard3 <= 7))
					next_state = `S10;
				else if (dscore == 5 && ~(pcard3 >= 4 && pcard3 <= 7))
					next_state = `S5;
				else if (dscore == 4 && (pcard3 >= 2 && pcard3 <= 7))
					next_state = `S10;
				else if (dscore == 4 && ~(pcard3 >= 2 && pcard3 <= 7))
					next_state = `S5;
				else if (dscore == 3 && ~(pcard3 == 8))
					next_state = `S10;
				else if (dscore == 3 && (pcard3 == 8))
					next_state = `S5;
				else if (dscore <= 2)
					next_state = `S10;
			`S10: next_state = `S5;
			`S11:if (dscore <= 5)
					next_state = `S10;
				 else if (dscore > 5)
					next_state = `S5;
			//default: next_state = `S0;
		endcase
		
		present_state = next_state;
		
		case (present_state)
			`S1: begin 
					load_pcard1 = 1;
					load_pcard2 = 0;
					load_pcard3 = 0;
					load_dcard1 = 0;
					load_dcard2 = 0;
					load_dcard3 = 0;
					player_win_light = 0;
					dealer_win_light = 0;
				 end
			`S2: begin 
					load_pcard1 = 0;
					load_pcard2 = 0;
					load_pcard3 = 0;
					load_dcard1 = 1;
					load_dcard2 = 0;
					load_dcard3 = 0;
					player_win_light = 0;
					dealer_win_light = 0;
				 end
				 
			`S3: begin 
					load_pcard1 = 0;
					load_pcard2 = 1;
					load_pcard3 = 0;
					load_dcard1 = 0;
					load_dcard2 = 0;
					load_dcard3 = 0;
					player_win_light = 0;
					dealer_win_light = 0;
				 end
				 
			`S4: begin 
					load_pcard1 = 0;
					load_pcard2 = 0;
					load_pcard3 = 0;
					load_dcard1 = 0;
					load_dcard2 = 1;
					load_dcard3 = 0;
					player_win_light = 0;
					dealer_win_light = 0;
				 end 
			`S6: begin 
					load_pcard1 = 0;
					load_pcard2 = 0;
					load_pcard3 = 0;
					load_dcard1 = 0;
					load_dcard2 = 0;
					load_dcard3 = 0;
					player_win_light = 1;
					dealer_win_light = 0;
				 end
			`S7: begin 
					load_pcard1 = 0;
					load_pcard2 = 0;
					load_pcard3 = 0;
					load_dcard1 = 0;
					load_dcard2 = 0;
					load_dcard3 = 0;
					player_win_light = 0;
					dealer_win_light = 1;
				 end
			`S8: begin 
					load_pcard1 = 0;
					load_pcard2 = 0;
					load_pcard3 = 0;
					load_dcard1 = 0;
					load_dcard2 = 0;
					load_dcard3 = 0;
					player_win_light = 1;
					dealer_win_light = 1;
				 end
			`S9: begin 
					load_pcard1 = 0;
					load_pcard2 = 0;
					load_pcard3 = 1;
					load_dcard1 = 0;
					load_dcard2 = 0;
					load_dcard3 = 0;
					player_win_light = 0;
					dealer_win_light = 0;
				 end
			`S10: begin 
					load_pcard1 = 0;
					load_pcard2 = 0;
					load_pcard3 = 0;
					load_dcard1 = 0;
					load_dcard2 = 0;
					load_dcard3 = 1;
					player_win_light = 0;
					dealer_win_light = 0;
				 end
			default: begin
						load_pcard1 = 0;
						load_pcard2 = 0;
						load_pcard3 = 0;
						load_dcard1 = 0;
						load_dcard2 = 0;
						load_dcard3 = 0;
						player_win_light = 0;
						dealer_win_light = 0;
					 end
		endcase
		
		
	end 
end 
endmodule
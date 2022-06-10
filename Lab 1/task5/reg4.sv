module reg4 (input [3:0] new_card, input load_card, input resetb, input slow_clock, output reg [3:0] card_out); 

	always @ (posedge slow_clock or negedge resetb) begin
		if (resetb == 0)
			card_out <= 0;
		else if (load_card)
			card_out <= new_card;
	end

endmodule 
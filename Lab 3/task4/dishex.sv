module dishex (
input logic [3:0] seg_key,
input logic done,
input logic key_valid,
output logic [6:0] hex
);
	always_comb begin
		if (~done) 
			hex = 7'b1111111;
		
		else if (done && ~key_valid)
			hex = 7'b0111111;
		
		else if (done && key_valid) begin
			case (seg_key)
				'h0: hex = 7'b1000000;
				'h1: hex = 7'b1111001;
				'h2: hex = 7'b0100100;
				'h3: hex = 7'b0110000;
				'h4: hex = 7'b0011001;
				'h5: hex = 7'b0010010;
				'h6: hex = 7'b0000010;
				'h7: hex = 7'b1111000;
				'h8: hex = 7'b0000000;
				'h9: hex = 7'b0010000;
				'ha: hex = 7'b0001000;
				'hb: hex = 7'b0000011;
				'hc: hex = 7'b1000110;
				'hd: hex = 7'b0100001;
				'he: hex = 7'b0000110;
				'hf: hex = 7'b0001110;
				default: hex = 7'b1111111;
			endcase
		end
		else hex = 7'b1111111;
	end
	
endmodule: dishex
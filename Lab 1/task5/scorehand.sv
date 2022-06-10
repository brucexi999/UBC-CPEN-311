module scorehand(input [3:0] card1, input [3:0] card2, input [3:0] card3, output reg [3:0] total);
	reg [3:0] value1;
	reg [3:0] value2;
	reg [3:0] value3;
	
	always @* begin // check if the value of the card is smaller or equal to 9. 
		if (card1 <= 4'b1001)
			value1 = card1;
		else 
			value1 = 4'b0000; 
	end 
	
	always @* begin
		if (card2 <= 4'b1001)
			value2 = card2;
		else 
			value2 = 4'b0000; 
	end 
	
	always @* begin
		if (card3 <= 4'b1001)
			value3 = card3;
		else 
			value3 = 4'b0000; 
	end
	
	always @* 
		total = (value1 + value2 + value3) %10; 
endmodule


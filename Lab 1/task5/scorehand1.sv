module scorehand(input [3:0] card1, input [3:0] card2, input [3:0] card3, output reg [3:0] total);
	reg [3:0] value1;
	reg [3:0] value2;
	reg [3:0] value3;
	reg [4:0] total_5bits;
	integer i;
	reg [3:0] tens;
	
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
	
	always @* begin
		total_5bits = value1 + value2 + value3; // Add all card values together stored in a 5-bits register 
		tens = 4'd0;
		total = 4'd0;
		
		for (i=4; i>=0; i = i-1 ) begin // Convert the 5-bits binary into BCD, take the ones as output 
			if (tens>5)
				tens = tens + 3;
			if (total>5)
				total = total + 3; 
			
			tens = tens << 1;
			tens[0] = total[3];
			total = total << 1;
			total[0] = total_5bits[i];
		end
	end 
endmodule


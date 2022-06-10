module mult(input logic [31:0] dataa, input logic [31:0] datab, output logic [31:0] result);
	
	//signed dataa, datab, result; 
	
	always @* 
		result  = dataa * datab; 
		
endmodule: mult

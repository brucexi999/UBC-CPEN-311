module tb_mult();

	logic signed [31:0] dataa, datab, result; 

	mult dut (
	.dataa (dataa),
	.datab (datab),
	.result (result)
	);
	
	initial begin
		dataa = 3; datab = 2; #20; 
		dataa = -3; datab = 2; #20; 
	end
endmodule: tb_mult

module tb_rtl_dishex ();
	logic [3:0] seg_key;
	logic done, key_valid;
	logic [6:0] hex;
	
	
	dishex dut (
	.seg_key (seg_key),
	.done (done),
	.key_valid (key_valid),
	.hex (hex)
	);
	
	initial begin
		done = 0; #10;
		done = 1; key_valid = 0; seg_key = 4'b1111; #10;
		key_valid = 1; seg_key = 4'b1111; #10;
		seg_key = 4'b0000; #10;
		seg_key = 4'b0001; #10;
		key_valid = 0; seg_key = 4'b0010; #10;
	end
	
endmodule: tb_rtl_dishex
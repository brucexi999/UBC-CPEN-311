module counter(input logic clk, input logic reset_n,
               input logic [3:0] address, input logic read, output logic [31:0] readdata);

	logic [63:0] cycle_counter;
	//logic addr_offset; 
	//The counter---------------------------
	always @ (posedge clk or negedge reset_n) begin
		if (~reset_n)
			cycle_counter = 64'b0;
		else
			cycle_counter = cycle_counter + 64'b1;
	end
	//----------------------------------------
	
	always@* begin
		if (read && address == 0)
			readdata = cycle_counter [31:0];
	    else if (read && address !== 0)
			readdata = cycle_counter [63:32]; 
	end

endmodule: counter
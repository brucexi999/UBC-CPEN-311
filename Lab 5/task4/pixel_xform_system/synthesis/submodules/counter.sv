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
	
	//The reading state machine---------------
	
	typedef enum {
	state_counting,
	state_read1,
	state_read2
	} state_type;

	state_type state;
	
	always @ (posedge clk or negedge reset_n) begin
		if (~reset_n) 
			state = state_counting; 
		else begin
			case (state)
				state_counting: begin
								if (read && (address == 4'b0))
									state = state_read1; 
								else if (read && (address !== 4'b0))
									state = state_read2;
								end
								
				state_read1: begin
							 readdata = cycle_counter [31:0];
							 state = state_counting; 
							 end

				state_read2: begin
							 readdata = cycle_counter [63:32];
							 state = state_counting; 
							 end								 
			endcase
		end
	end

	//----------------------------------------

endmodule: counter
module fsm_fillscreen (
input logic clk,
input logic rst_n,
input logic x_done,
input logic y_done,
input logic start,
output logic x_load,
output logic y_load,
output logic x_count,
output logic y_count,
output logic done
);

`define S0 2'b00
`define S1 2'b01
`define S2 2'b10
`define S3 2'b11

reg [1:0] present_state, next_state;

always @(posedge clk or negedge rst_n) begin
	if (rst_n == 0) begin
		present_state = `S0;
		next_state = `S0;
		x_load = 0;
		y_load = 0;
		x_count = 0;
		y_count = 0;
		done = 0;
		
	end else begin
		case (present_state) 
			`S0: if (start == 1)
					next_state = `S2;
				 else 
					next_state = `S0;

			`S1: next_state = `S2;
				 	
			`S2: if (y_done == 1 && x_done !== 1)
					next_state = `S1;
				 else if (y_done !== 1)
					next_state = `S2;
				 else if (y_done == 1 && x_done == 1)
					next_state = `S3;
			`S3: next_state = `S3;
		endcase
	
		present_state = next_state;
		
		case (present_state)
			`S0: begin
				 x_load = 1;
				 y_load = 1;
				 x_count = 0;
				 y_count = 0;
				 done = 0;
				 end
				 
			`S1: begin
				 x_load = 0;
				 y_load = 1;
				 x_count = 1;
				 y_count = 0;
				 done = 0;
				 end
			
			`S2: begin
				 x_load = 0;
				 y_load = 0;
				 x_count = 0;
				 y_count = 1;
				 done = 0;
				 end
			
			`S3: begin
				 x_load = 0;
				 y_load = 0;
				 x_count = 0;
				 y_count = 0;
				 done = 1;
				 end
		endcase
	end
end

endmodule 
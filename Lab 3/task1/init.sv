`timescale 1ps / 1ps

module init(input logic clk, input logic rst_n,
            input logic en, output logic rdy,
            output logic [7:0] addr, output logic [7:0] wrdata, output logic wren);

	logic [8:0] i; 
	
	typedef enum {
	state_init,
	state_run
	} state_type;
	
	state_type state; 
	
	always @ (posedge clk or negedge rst_n) begin
		if (~rst_n) begin
			state <= state_init;
			i <= 0;
			rdy <= 1;
			wren <= 0;
		end
		
		else begin
			case (state)
				state_init: begin
							i <= 0;
							rdy <= 1;
							wren <= 0; 
							if (en)
								state <= state_run;
							end
							
				state_run:  begin
							rdy <= 0;
							wren <= 1;
							addr <= i[7:0];
							wrdata <= i[7:0];
							i = i + 1; 
							if (i == 256)
								state <= state_init;
						    end
			endcase
		end
	end
endmodule: init
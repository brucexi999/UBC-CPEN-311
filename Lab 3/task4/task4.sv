`timescale 1ps / 1ps

module task4(input logic CLOCK_50, input logic [3:0] KEY, input logic [9:0] SW,
             output logic [6:0] HEX0, output logic [6:0] HEX1, output logic [6:0] HEX2,
             output logic [6:0] HEX3, output logic [6:0] HEX4, output logic [6:0] HEX5,
             output logic [9:0] LEDR);

    logic [7:0] ct_addr, ct_rddata;
	logic en, rdy, key_valid, done;
	logic [23:0] key;

    ct_mem ct(
	.address (ct_addr),
	.clock (CLOCK_50),
	.q (ct_rddata)
	);
	
    crack c(
	.clk (CLOCK_50),
	.rst_n (KEY[3]),
	.en (en),
	.rdy (rdy),
	.key (key),
	.key_valid (key_valid),
	.ct_addr (ct_addr),
	.ct_rddata (ct_rddata)
	);
	
	dishex dh0 (
	.seg_key (key[3:0]),
	.done (done),
	.key_valid (key_valid),
	.hex (HEX0)
	);
	
	dishex dh1 (
	.seg_key (key[7:4]),
	.done (done),
	.key_valid (key_valid),
	.hex (HEX1)
	);
	
	dishex dh2 (
	.seg_key (key[11:8]),
	.done (done),
	.key_valid (key_valid),
	.hex (HEX2)
	);
	
	dishex dh3 (
	.seg_key (key[15:12]),
	.done (done),
	.key_valid (key_valid),
	.hex (HEX3)
	);
	
	dishex dh4 (
	.seg_key (key[19:16]),
	.done (done),
	.key_valid (key_valid),
	.hex (HEX4)
	);
	
	dishex dh5 (
	.seg_key (key[23:20]),
	.done (done),
	.key_valid (key_valid),
	.hex (HEX5)
	);
	
    typedef enum {
	state_initial,
	state_en,
	state_dummy1,
	state_dummy2,
	state_wait_done
	} state_type;
	
	state_type state;
	
	always_ff @ (posedge CLOCK_50 or negedge KEY[3] ) begin
		if (~KEY[3]) begin
			done <= 0;
			en <= 0;
			state <= state_initial;
		end
		
		else begin
			case (state)
				state_initial:
				begin
					done <= 0;
					en <= 0;
					if (rdy)
						state <= state_en;
				end
				
				state_en:
				begin
					en <= 1;
					state <= state_dummy1;
				end
				
				state_dummy1:
				begin
					en <= 0;
					state <= state_dummy2;
				end
				
				state_dummy2:
				begin
					state <= state_wait_done;
				end
				
				state_wait_done:
				begin
					if (rdy) begin
						done <= 1;
					end
				end
		
			endcase
		end
	end
	
endmodule: task4

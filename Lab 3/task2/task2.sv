`timescale 1ps / 1ps

module task2(input logic CLOCK_50, input logic [3:0] KEY, input logic [9:0] SW,
             output logic [6:0] HEX0, output logic [6:0] HEX1, output logic [6:0] HEX2,
             output logic [6:0] HEX3, output logic [6:0] HEX4, output logic [6:0] HEX5,
             output logic [9:0] LEDR);
			 
	logic en_k, en_i, rdy_k, rdy_i, wren, wren_k, wren_i, done_i; 
	logic [7:0] addr, addr_k, addr_i, wrdata, wrdata_k, wrdata_i, rddata; 

	init INIT (
	.clk (CLOCK_50),
	.rst_n (KEY[3]),
	.en (en_i),
	.rdy (rdy_i),
	.addr (addr_i),
	.wrdata (wrdata_i),
	.wren (wren_i)
	);

	ksa KSA (
	.clk (CLOCK_50),
	.rst_n (KEY[3]),
	.en (en_k),
	.rdy (rdy_k),
	.key ({14'b0, SW}),
	.addr (addr_k),
	.rddata (rddata),
	.wrdata (wrdata_k),
	.wren (wren_k)
	);

	s_mem s(
	.address (addr),
	.clock (CLOCK_50),
	.data (wrdata),
	.wren (wren),
	.q (rddata)
	);

//Control FSM of en and rdy---------------

	typedef enum {
	state_initial,
	state_en_i,
	state_dummy_1,
	state_dummy_2,
	state_wait_i_done,
	state_en_k, 
	state_wait_k_done
	} state_type;
	
	state_type state; 
	always_ff @(posedge CLOCK_50 or negedge KEY[3]) begin 
		if (~KEY[3]) begin
			state <= state_initial;
			done_i <=0; 
			en_i <= 0;
			en_k <= 0;
		end
		
		else begin
			case (state)
				
				state_initial:
				begin
					en_i <= 0;
					en_k <= 0;
					done_i <=0;
					state <= state_en_i;
				end
				
				state_en_i:
				begin
					en_i <= 1;
					state <= state_dummy_1;
				end
				
				state_dummy_1: //Just a dummy state, to allow an entra cycle for rdy_i to deassert. 
				begin
					en_i <= 0; //Deassert en after 1 cycle.
					state <= state_dummy_2; 
				end
				
				state_dummy_2: //Just a dummy state, to allow an entra cycle for rdy_i to deassert.
				begin
					state <= state_wait_i_done;
				end
				
				state_wait_i_done:
				begin
					if (rdy_i) begin//Only when we've asserted en_i, and rdy_i undergoes the transition of 1 -> 0 -> 1, we are sure that INIT has completed, and we proceed to assert en_k. 
						done_i <= 1; 
						state <= state_en_k;
					end
					
				end
				
				state_en_k:
				begin
					en_k <= 1;
					state <= state_wait_k_done;
				end
				
				state_wait_k_done:
				begin
					en_k <= 0;
				end
				
			endcase
		end
	end
//-----------------------------------------

	always_comb begin //A tri-state driver used to coordinate addr, wrdata and wren, because both INIT and KSA are driving these signals of the S memory. 
		if (~done_i) begin
			addr = addr_i;
			wrdata = wrdata_i;
			wren = wren_i;
		end
		
		else if (done_i) begin
			addr = addr_k;
			wrdata = wrdata_k;
			wren = wren_k;
		end
		
		else begin
			addr = 8'bz;
			wrdata = 8'bz;
			wren = 1'bz;
		end
		
	end
endmodule: task2

`timescale 1ps / 1ps

module arc4(input logic clk, input logic rst_n,
            input logic en, output logic rdy,
            input logic [23:0] key,
            output logic [7:0] ct_addr, input logic [7:0] ct_rddata,
            output logic [7:0] pt_addr, input logic [7:0] pt_rddata, output logic [7:0] pt_wrdata, output logic pt_wren);

    logic [7:0] s_addr, s_addr_i, s_addr_k, s_addr_p;
	logic [7:0] s_rddata, s_rddata_k, s_rddata_p;
	logic [7:0] s_wrdata, s_wrdata_i, s_wrdata_k, s_wrdata_p;
	logic s_wren, s_wren_i, s_wren_k, s_wren_p;
	logic rdy_i, en_i, rdy_k, en_k, rdy_p, en_p;
	logic done_i, done_k, done_p; 
	
    s_mem s(
	.address (s_addr),
	.clock (clk),
	.data (s_wrdata),
	.wren (s_wren),
	.q (s_rddata)
	);
	
    init INIT(
	.clk (clk),
	.rst_n (rst_n),
	.en (en_i),
	.rdy (rdy_i),
	.addr (s_addr_i),
	.wrdata  (s_wrdata_i),
	.wren (s_wren_i)
	);
	
    ksa KSA(
	.clk (clk),
	.rst_n (rst_n),
	.en (en_k),
	.rdy (rdy_k),
	.key (key),
	.addr (s_addr_k),
	.rddata (s_rddata_k),
	.wrdata (s_wrdata_k),
	.wren (s_wren_k)
	);
	
    prga PRGA(
	.clk (clk),
	.rst_n (rst_n),
	.en (en_p),
	.rdy (rdy_p),
	.key (key),
	.s_addr (s_addr_p),
	.s_rddata (s_rddata_p),
	.s_wrdata (s_wrdata_p),
	.s_wren (s_wren_p),
	.ct_addr (ct_addr),
	.ct_rddata (ct_rddata),
	.pt_addr (pt_addr),
	.pt_rddata (pt_rddata),
	.pt_wrdata (pt_wrdata),
	.pt_wren (pt_wren)
	);

//Control FSM of en and rdy---------------

	typedef enum {
	state_initial,
	state_en_i,
	state_dummy_1,
	state_dummy_2,
	state_wait_i_done,
	state_en_k, 
	state_dummy_3,
	state_dummy_4,
	state_wait_k_done,
	state_en_p,
	state_dummy_5,
	state_dummy_6,
	state_wait_p_done
	} state_type;
	
	state_type state; 
	always_ff @(posedge clk or negedge rst_n) begin 
		if (~rst_n) begin
			state <= state_initial;
			done_i <= 0;
			done_k <= 0;
			en_i <= 0;
			en_k <= 0;
			en_p <= 0;
			rdy <= 1; 
		end
		
		else begin
			case (state)
				
				state_initial:
				begin
					en_i <= 0;
					en_k <= 0;
					en_p <= 0;
					done_i <= 0;
					done_k <= 0;
					done_p <= 0;
					rdy <= 1; 
					if (rdy_i && en)
						state <= state_en_i;
				end
				
				state_en_i:
				begin
					rdy <= 0; 
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
					if (rdy_i && rdy_k) begin//Only when we've asserted en_i, and rdy_i undergoes the transition of 1 -> 0 -> 1, we are sure that INIT has completed, and we proceed to assert en_k. 
						done_i <= 1; 
						state <= state_en_k;
					end
					
				end
				
				state_en_k:
				begin
					en_k <= 1;
					state <= state_dummy_3;
				end
				
				state_dummy_3:
				begin
					en_k <= 0;
					state <= state_dummy_4;
				end
				
				state_dummy_4:
				begin
					state <= state_wait_k_done;
				end
				
				state_wait_k_done:
				begin
					if (rdy_k && rdy_p) begin 
						done_k <= 1; 
						state <= state_en_p;
					end
				end
				
				state_en_p:
				begin
					en_p <= 1;
					state <= state_dummy_5; 
				end
				
				state_dummy_5:
				begin
					en_p <= 0; 
					state <= state_dummy_6;
				end
				
				state_dummy_6:
				begin
					state <= state_wait_p_done;
				end
				
				
				state_wait_p_done:
				begin
					if (rdy_p) begin
						done_p <= 1; 
						state <= state_initial;
					end
				end
				
			endcase
		end
	end
	//-----------------------------------------

	always_comb begin //A tri-state driver used to coordinate addr, wrdata and wren, because both INIT, KSA  and PRGA are driving these signals of the S memory. 
		if (~done_i) begin
			s_addr = s_addr_i;
			s_wrdata = s_wrdata_i;
			s_rddata_k = 8'bz; 
			s_rddata_p = 8'bz;
			s_wren = s_wren_i;
		end
		
		else if (done_i && ~done_k) begin
			s_addr = s_addr_k;
			s_wrdata = s_wrdata_k;
			s_rddata_k = s_rddata;
			s_rddata_p = 8'bz;
			s_wren = s_wren_k;
		end

		else if (done_i && done_k && ~done_p) begin
			s_addr = s_addr_p;
			s_wrdata = s_wrdata_p;
			s_rddata_p = s_rddata; 
			s_rddata_k = 8'bz;
			s_wren = s_wren_p;
		end
		
		else begin
			s_addr = 8'bz;
			s_wrdata = 8'bz;
			s_rddata_k = 8'bz;
			s_rddata_p = 8'bz;
			s_wren = 1'bz;
		end
		
	end

endmodule: arc4

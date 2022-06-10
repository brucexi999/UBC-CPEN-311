
`timescale 1ps / 1ps

module crack(input logic clk, input logic rst_n,
             input logic en, output logic rdy,
             output logic [23:0] key, output logic key_valid,
             output logic [7:0] ct_addr, input logic [7:0] ct_rddata);

	logic [23:0] key_trial; 
	logic [7:0] message_length, i; 
	logic en_ARC4, rdy_ARC4, pt_wren, load_key, rst_key, pt_arb, ct_arb;
	logic [7:0] pt_addr, pt_addr_arc4, pt_addr_fsm, pt_rddata, pt_wrdata; 
	logic [7:0] ct_addr_arc4, ct_addr_fsm;
	
	pt_mem PT(
	.address (pt_addr),
	.clock (clk),
	.data (pt_wrdata),
	.wren (pt_wren),
	.q (pt_rddata)
	);
	
	arc4 ARC4(
	.clk (clk),
	.rst_n (rst_n),
	.en (en_ARC4),
	.rdy (rdy_ARC4),
	.key (key_trial),
	.ct_addr (ct_addr_arc4),
	.ct_rddata (ct_rddata),
	.pt_addr (pt_addr_arc4),
	.pt_rddata (pt_rddata),
	.pt_wrdata (pt_wrdata),
	.pt_wren (pt_wren)
	);
	
	always_ff @ (posedge clk) begin
		if (rst_key)
			key <= 0;
		
		else if (load_key)
			key <= key_trial;
		
	end
	
	typedef enum {
	state_initial,
	state_read_ml,
	state_wait_ml_en_acr4,
	state_store_ml,
	state_dummy,
	state_wait_arc4_done,
	state_read_pt,
	state_wait_pt,
	state_dummy1,
	state_check_pt,
	state_cracked,
	state_uncracked
	} state_type;

	state_type state;
	
	always_ff @ (posedge clk or negedge rst_n) begin
	
		if (~rst_n) begin
			state <= state_initial;
			pt_arb <= 0;
			ct_arb <= 0;
			i <= 1;
			key_trial <= 24'b0;
			rst_key <= 1;
			key_valid <= 0;
			rdy <= 1;
			en_ARC4 <= 0; 
			load_key <= 0;
		end
		
		else begin
		
			case (state)
				state_initial:
				begin
					pt_arb <= 0;
					ct_arb <= 0;
					i <= 1;
					key_trial <= 24'b0;
					rst_key <= 1;
					key_valid <= 0;
					rdy <= 1;
					en_ARC4 <= 0;
					load_key <= 0;
					if (en)
						state <= state_read_ml;
				end
				
				state_read_ml:
				begin
					rst_key <= 0;
					rdy <= 0;
					ct_addr_fsm <= 0;
					ct_arb <= 1; 
					state <= state_wait_ml_en_acr4;
				end
				
				state_wait_ml_en_acr4:
				begin
					en_ARC4 <= 1;
					ct_arb <= 0;
					pt_arb <= 0;
					state <= state_store_ml;
				end
				
				state_store_ml:
				begin
					en_ARC4 <= 0;
					message_length <= ct_rddata;
					state <= state_dummy;
				end
				
				state_dummy:
				begin
					state <= state_wait_arc4_done;
				end
				
				state_wait_arc4_done:
				begin
					if (rdy_ARC4)
						state <= state_read_pt;
				end
				
				state_read_pt:
				begin
					pt_addr_fsm <= i;
					pt_arb <= 1;
					state <= state_wait_pt;
				end
				
				state_wait_pt:
				begin
					state <= state_dummy1;
				end
				
				
				state_dummy1:
				begin
					state <= state_check_pt;
				end
				
				state_check_pt:
				begin
				
					if (pt_rddata >= 8'b00100000 && pt_rddata <= 8'b01111110 && i < message_length) begin
						i <= i+1;
						state <= state_read_pt;
					end	
					
					else if (pt_rddata >= 8'b00100000 && pt_rddata <= 8'b01111110 && i == message_length) begin
						state <= state_cracked;
					end	
					
					else if ((pt_rddata < 8'b00100000 || pt_rddata > 8'b01111110) && key_trial < 'hffffff) begin
						key_trial <= key_trial + 1;
						i <= 1; 
						state <= state_read_ml;
					end	

					else if ((pt_rddata < 8'b00100000 || pt_rddata > 8'b01111110) && key_trial == 'hffffff) begin
						state <= state_uncracked;						
					end			
					
				end
				
				state_cracked:
				begin
					load_key <= 1;
					key_valid <= 1;
					rdy <= 1;
					if (en) begin
						i <= 1;
						rst_key <= 1;
						load_key <= 0;
						key_trial <= 0;
						state <= state_read_ml;
					end
				end
				
				state_uncracked:
				begin
					rdy <= 1;

					if (en) begin
						i <= 1;
						rst_key <= 1;
						load_key <= 0;
						key_trial <= 0;
						state <= state_read_ml; 
					end
				end
				
			endcase
			
		end
		
	end
	
	always_comb begin //Mux as arbitratration
		case ({pt_arb, ct_arb})
			2'b00:
			begin
				pt_addr = pt_addr_arc4;
				ct_addr = ct_addr_arc4;
			end
			
			2'b01:
			begin
				pt_addr = pt_addr_arc4;
				ct_addr = ct_addr_fsm;
			end
			
			2'b10:
			begin
				pt_addr = pt_addr_fsm;
				ct_addr = ct_addr_arc4;
			end
			
			2'b11:
			begin
				pt_addr = pt_addr_fsm;
				ct_addr = ct_addr_fsm;
			end
			
		endcase
	end
	
endmodule: crack

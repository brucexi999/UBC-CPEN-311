`timescale 1ps / 1ps

module crack(input logic clk, input logic rst_n,
             input logic en, output logic rdy,
             output logic [23:0] key, output logic key_valid,
             output logic [7:0] ct_addr, input logic [7:0] ct_rddata,
			 output logic [7:0] pt1_addr, output logic [7:0] pt1_wrdata, 
			 output logic pt1_wren, input logic [23:0] initial_key,
			 input logic pt1_en
			 );

    // For Task 5, you may modify the crack port list above,
    // but ONLY by adding new ports. All predefined ports must be identical.

	logic [24:0] key_trial; 
	logic [7:0] message_length, i, j; 
	logic en_ARC4, rdy_ARC4, pt_wren, load_key, pt_arb, ct_arb, rst_key;
	logic [7:0] pt_addr, pt_addr_arc4, pt_addr_fsm, pt_rddata, pt_wrdata;
	logic [7:0] ct_addr_arc4, ct_addr_fsm;
	
    // this memory must have the length-prefixed plaintext if key_valid
    pt_mem pt(
	.address (pt_addr),
	.clock (clk),
	.data (pt_wrdata),
	.wren (pt_wren),
	.q (pt_rddata)
	);
	
    arc4 a4(
	.clk (clk),
	.rst_n (rst_n),
	.en (en_ARC4),
	.rdy (rdy_ARC4),
	.key (key_trial[23:0]),
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
			key <= key_trial[23:0];
	end
	
	typedef enum {
	state_initial,
	state_read_initial_key,
	state_read_ml,
	state_wait_ml_en_acr4,
	state_store_ml,
	state_dummy,
	state_wait_arc4_done,
	state_read_pt,
	state_wait_pt,
	state_dummy1,
	state_check_pt,
	state_write_pt1_ml,
	state_read_pta,
	state_dummy2,
	state_write_pt1,
	state_cracked,
	state_finish,
	state_uncracked
	} state_type;

	state_type state;
	
	always_ff @ (posedge clk or negedge rst_n) begin
	
		if (~rst_n) begin
			state <= state_initial;
			i <= 1;
			rst_key <= 1;
			key_valid <= 0;
			rdy <= 1;
			en_ARC4 <= 0; 
			load_key <= 0;
			pt1_wren <= 0;
			pt_arb <= 0;
			ct_arb <= 0;
		end
		
		else begin
		
			case (state)
				state_initial:
				begin
					i <= 1;
					rst_key <= 1;
					key_valid <= 0;
					rdy <= 1;
					en_ARC4 <= 0;
					load_key <= 0;
					pt1_wren <= 0;
					pt_arb <= 0;
					ct_arb <= 0;
					if (en)
						state <= state_read_initial_key;
				end
				
				state_read_initial_key:
				begin
					rdy <= 0;
					key_trial <= {1'b0, initial_key};
					state <= state_read_ml;
				end
				
				state_read_ml:
				begin
					rst_key <= 0;
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
						key_trial <= key_trial + 2;
						i <= 1; 
						state <= state_read_ml;
					end	

					else if ((pt_rddata < 8'b00100000 || pt_rddata > 8'b01111110) && key_trial >= 'hffffff) begin
						state <= state_uncracked;						
					end			
					
				end
				
				state_cracked:
				begin
					key_valid <= 1;
					load_key <= 1;
					if (pt1_en)
						state <= state_write_pt1_ml;
				end
				
				state_write_pt1_ml:
				begin
					load_key <= 0;
					pt1_addr <= 0;
					pt1_wrdata <= message_length;
					pt1_wren <= 1;
					j <= 1;
					state <= state_read_pta;
				end
				
				state_read_pta:
				begin
					pt_addr_fsm <= j;
					pt_arb <= 1;
					pt1_wren <= 0;
					state <= state_dummy2;
				end
				
				state_dummy2:
				begin
					state <= state_write_pt1;
				end
				
				state_write_pt1:
				begin
					pt1_addr <= j;
					pt1_wrdata <= pt_rddata;
					pt1_wren <= 1;
					j = j+1;
					if (j <= message_length)
						state <= state_read_pta;
					else if (j > message_length)
						state <= state_finish;
				end
				
				state_finish:
				begin
					pt1_wren <= 0;
					rdy <= 1;
					if (en) begin
						i <= 1;
						rst_key <= 1;
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
						state <= state_read_ml; 
					end
				end
				
			endcase
			
		end
		
	end
	
	always_comb begin // Mux as arbitratration
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

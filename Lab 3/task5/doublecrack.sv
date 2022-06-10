module doublecrack(input logic clk, input logic rst_n,
             input logic en, output logic rdy,
             output logic [23:0] key, output logic key_valid,
             output logic [7:0] ct_addr, input logic [7:0] ct_rddata);

    logic en_1, en_2, rdy_1, rdy_2, key_valid_1, key_valid_2, pt_wren, pt_wren_1, pt_wren_2, pt_en_1, pt_en_2, ct1_wren, ct2_wren,
	ct1_arb, ct2_arb, pt_arb;
    logic [7:0] pt_addr, pt_addr_1, pt_addr_2, pt_wrdata, pt_wrdata_1, pt_wrdata_2, ct1_rddata, ct1_addr, ct1_addr_crack, ct1_addr_fsm,
	ct2_addr, ct2_addr_crack, ct2_addr_fsm, ct2_rddata, i, message_length;
	logic [23:0] key_1, key_2, initial_key_1, initial_key_2; 
	
    // this memory must have the length-prefixed plaintext if key_valid
    pt_mem pt(
	.address (pt_addr),
	.clock (clk),
	.data (pt_wrdata),
	.wren (pt_wren)
	);
	
	ct_mem ct1 (
	.address (ct1_addr),
	.clock (clk),
	.data (ct_rddata),
	.wren (ct1_wren),
	.q (ct1_rddata)
	);
	
	ct_mem ct2 (
	.address (ct2_addr),
	.clock (clk),
	.data (ct_rddata),
	.wren (ct2_wren),
	.q (ct2_rddata)	
	);
	
    // for this task only, you may ADD ports to crack
    crack c1(
	.clk (clk),
	.rst_n (rst_n),
	.en (en_1),
	.rdy (rdy_1),
	.key (key_1),
	.key_valid (key_valid_1),
	.ct_addr (ct1_addr_crack),
	.ct_rddata (ct1_rddata),
	.pt1_addr (pt_addr_1),
	.pt1_wrdata (pt_wrdata_1),
	.pt1_wren (pt_wren_1),
	.initial_key (initial_key_1),
	.pt1_en (pt_en_1)
	);
	
    crack c2(
	.clk (clk),
	.rst_n (rst_n),
	.en (en_2),
	.rdy (rdy_2),
	.key (key_2),
	.key_valid (key_valid_2),
	.ct_addr (ct2_addr_crack),
	.ct_rddata (ct2_rddata),
	.pt1_addr (pt_addr_2),
	.pt1_wrdata (pt_wrdata_2),
	.pt1_wren (pt_wren_2),
	.initial_key (initial_key_2),
	.pt1_en (pt_en_2)
	);
    
    typedef enum {
	state_initial,
	state_read_message_length,
	state_wait_1,
	state_store_message_length,
	state_read_global_ct,
	state_wait_2,
	state_write_local_ct,
	state_en_cracks,
	state_dummy_1,
	state_dummy_2,
	state_wait_3,
	state_cracked_1,
	state_cracked_2,
	state_finished,
	state_uncracked
	} state_type;
	
	state_type state; 
	
	always_ff @(posedge clk or negedge rst_n) begin
		if (~rst_n) begin
			state <= state_initial;
			key_valid <= 0;
			key <= 0;
			rdy <= 1;
			en_1 <= 0;
			en_2 <= 0;
			ct1_wren <= 0;
			ct2_wren <= 0;
			initial_key_1 <= 0;
			initial_key_2 <= 1;
			i <= 1;
		end
		
		else begin
			case (state)
			state_initial:
			begin
				key_valid <= 0;
				key <= 0;
				rdy <= 1;
				en_1 <= 0;
				en_2 <= 0;
				ct1_wren <= 0;
				ct2_wren <= 0;
				initial_key_1 <= 0;
				initial_key_2 <= 1;
				i <= 1;
				if (en)
					state <= state_read_message_length;
			end
			
			state_read_message_length:
			begin
				rdy <= 0;
				ct_addr <= 0;
				state <= state_wait_1;
			end
			
			state_wait_1:
			begin
				state <= state_store_message_length;
			end
			
			state_store_message_length:
			begin
				message_length <= ct_rddata;
				ct1_addr_fsm <= 0;
				ct2_addr_fsm <= 0;
				ct1_arb <= 1;
				ct2_arb <= 1;
				ct1_wren <= 1;
				ct2_wren <= 1;
				state <= state_read_global_ct;
			end
			
			state_read_global_ct:
			begin
				ct_addr <= i;
				ct1_wren <= 0;
				ct2_wren <= 0;
				state <= state_wait_2;
			end
			
			state_wait_2:
			begin
				state <= state_write_local_ct;
			end
			
			state_write_local_ct:
			begin
				ct1_addr_fsm <= i;
				ct2_addr_fsm <= i;
				ct1_wren <= 1;
				ct2_wren <= 1;
				i = i + 1;
				if (i <= message_length)
					state <= state_read_global_ct;
				else if (i > message_length && rdy_1 && rdy_2)
					state <= state_en_cracks;
			end
			
			state_en_cracks:
			begin
				ct1_wren <= 0;
				ct2_wren <= 0;
				ct1_arb <= 0;
				ct2_arb <= 0;
				en_1 <= 1;
				en_2 <= 1;
				state <= state_dummy_1;
			end
			
			state_dummy_1:
			begin
				en_1 <= 0;
				en_2 <= 0;
				state <= state_dummy_2;
			end
			
			state_dummy_2:
			begin
				state <= state_wait_3;
			end
			
			state_wait_3:
			begin
				if (key_valid_1) 
					state <= state_cracked_1;
				else if (key_valid_2)
					state <= state_cracked_2;
				else if (~key_valid_1 && ~key_valid_2 && rdy_1 && rdy_2)
					state <= state_uncracked;
			end
			
			state_cracked_1:
			begin
				pt_en_1 <= 1;
				pt_arb <= 0;
				if (rdy_1) begin
					key_valid <= 1;
					key <= key_1;
					state <= state_finished;
				end
			end
			
			state_cracked_2:
			begin
				pt_en_2 <= 1;
				pt_arb <= 1;
				if (rdy_2) begin
					key_valid <= 1;
					key <= key_2;
					state <= state_finished;
				end
			end			
			
			state_uncracked:
			begin
				key_valid <= 0;
				rdy <= 1;
				if (en) begin
					key_valid <= 0;
					key <= 0;
					rdy <= 1;
					en_1 <= 0;
					en_2 <= 0;
					ct1_wren <= 0;
					ct2_wren <= 0;
					initial_key_1 <= 0;
					initial_key_2 <= 1;
					state <= state_read_message_length;
				end
			end
			
			state_finished:
			begin
				rdy <= 1;
				if (en) begin
					key_valid <= 0;
					key <= 0;
					rdy <= 1;
					en_1 <= 0;
					en_2 <= 0;
					ct1_wren <= 0;
					ct2_wren <= 0;
					initial_key_1 <= 0;
					initial_key_2 <= 1;
					state <= state_read_message_length;					
				end
			end
			
			endcase
		end
		
	end
	
	always_comb begin // Mux for ct1 and ct2 addr as arbitration between crack modules and the fsm. 
		case ({ct1_arb, ct2_arb})
			2'b00:
			begin
				ct1_addr = ct1_addr_crack;
				ct2_addr = ct2_addr_crack;
			end
			
			2'b01:
			begin
				ct1_addr = ct1_addr_crack;
			    ct2_addr = ct2_addr_fsm;
			end
			
			2'b10:
			begin
				ct1_addr = ct1_addr_fsm;
			    ct2_addr = ct2_addr_crack;
			end
			
			2'b11:
			begin
				ct1_addr = ct1_addr_fsm;
			    ct2_addr = ct2_addr_fsm;
			end
			
		endcase
	end
	
	always_comb begin // Mux for pt addr, wrdata, wren as arbitration between two crack modules.
		case (pt_arb)	
			1'b0:
			begin
				pt_addr = pt_addr_1;
				pt_wrdata = pt_wrdata_1;
				pt_wren = pt_wren_1;
			end
			
			1'b1:
			begin
				pt_addr = pt_addr_2;
			    pt_wrdata = pt_wrdata_2;
				pt_wren = pt_wren_2;
			end
			
		endcase
	end
	
endmodule: doublecrack

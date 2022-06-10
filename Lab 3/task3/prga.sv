`timescale 1ps / 1ps

module prga(input logic clk, input logic rst_n,
            input logic en, output logic rdy,
            input logic [23:0] key,
            output logic [7:0] s_addr, input logic [7:0] s_rddata, output logic [7:0] s_wrdata, output logic s_wren,
            output logic [7:0] ct_addr, input logic [7:0] ct_rddata,
            output logic [7:0] pt_addr, input logic [7:0] pt_rddata, output logic [7:0] pt_wrdata, output logic pt_wren);
	
	logic [7:0] i, j, temp_i, temp_j, d, k, message_length, pad_k, ct_k;
	logic load_j, rst_j; 
	
	always_ff @ (posedge clk) begin
		if (rst_j) 
			j <= 0; 
		
		else if (load_j) 
			j <= d;
		
	end
	
	always_comb begin
		d = (j + temp_i) % 256; 
	end
	
	typedef enum {
	state_initial,
	state_read_message_length,
	state_wait_message_length,
	state_store_message_length,
	state_compute_i_read_si,
	state_wait_si_write_message_length, 
	state_store_si_load_j, 
	state_wait_j, 
	state_read_sj, 
	state_wait_sj, 
	state_store_sj_write_si_to_j, 
	state_write_sj_to_i, 
	state_read_ctk_sij, 
	state_wait_sij, 
	state_store_sij_ctk, 
	state_write_ptk,
	state_new_k
	} state_type;

	state_type state; 
	
	always_ff @(posedge clk or negedge rst_n) begin
		if (~rst_n) begin
			state <= state_initial;
			k <= 1; 
			i <= 0; 
			rst_j <= 1;
			s_wren <= 0; 
			pt_wren <= 0;
			load_j <= 0;
			rdy <= 1;
		end
		
		else begin
			case (state)
			
			state_initial:
			begin
				k <= 1; 
				i <= 0; 
				rst_j <= 1;
				s_wren <= 0; 
				pt_wren <= 0;
				load_j <= 0;
				rdy <= 1;
				if (en)
					state <= state_read_message_length;
			end
			
			state_read_message_length:
			begin
				rst_j <= 0;
				rdy <= 0; 
				ct_addr <= 7'b0; 
				state <= state_wait_message_length; 
			end
			
			state_wait_message_length:
			begin
				state <= state_store_message_length;
			end
			
			state_store_message_length:
			begin
				message_length <= ct_rddata; 
				state <= state_compute_i_read_si; 
			end
			
			state_compute_i_read_si:
			begin
				i =  (i + 1) % 256; 
				s_addr <= i; 
				state <= state_wait_si_write_message_length; 
			end
			
			state_wait_si_write_message_length:
			begin
				pt_addr <= 0;
				pt_wrdata <= message_length;
				pt_wren <= 1;
				state <= state_store_si_load_j;
			end
			
			state_store_si_load_j:
			begin
				pt_wren <= 0;
				temp_i <= s_rddata;
				load_j <= 1; 
				state <= state_wait_j;
			end
			
			state_wait_j:
			begin
				load_j <= 0; 
				state <= state_read_sj;
			end
			
			state_read_sj:
			begin
				s_addr <= j;
				state <= state_wait_sj;
			end
			
			state_wait_sj:
			begin
				state <= state_store_sj_write_si_to_j;
			end
			
			state_store_sj_write_si_to_j:
			begin
				temp_j <= s_rddata;
				s_addr <= j;
				s_wrdata <= temp_i;
				s_wren <= 1;
				state <= state_write_sj_to_i;
			end
			
			state_write_sj_to_i:
			begin
				s_addr <= i;
				s_wrdata <= temp_j;
				s_wren <= 1;
				state <= state_read_ctk_sij;
			end
			
			state_read_ctk_sij:
			begin
				s_wren <= 0; 
				s_addr <= (temp_i + temp_j) % 256;
				ct_addr <= k; 
				state <= state_wait_sij;
			end
			
			state_wait_sij:
			begin
				state <= state_store_sij_ctk;
			end
			
			state_store_sij_ctk:
			begin
				pad_k <= s_rddata;
				ct_k <= ct_rddata;
				state <= state_write_ptk;
			end
			
			state_write_ptk:
			begin
				pt_addr <= k;
				pt_wrdata <= pad_k ^ ct_k;
				pt_wren <= 1;
				state <= state_new_k; 
			end
			
			state_new_k:
			begin
				pt_wren <= 0;
				k = k + 1;
				if (k == message_length + 1)
					state <= state_initial;
				else 
					state <= state_compute_i_read_si; 
			end
			
			endcase
		end
	end
endmodule: prga

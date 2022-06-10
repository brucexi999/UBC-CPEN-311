`timescale 1ps / 1ps

module ksa(input logic clk, input logic rst_n,
           input logic en, output logic rdy,
           input logic [23:0] key,
           output logic [7:0] addr, input logic [7:0] rddata, output logic [7:0] wrdata, output logic wren);
	
	logic [8:0] i;
	logic [8:0] j;
	logic [8:0] D; //used as "new j".  
	logic [8:0] temp_Si;
	logic [8:0] temp_Sj; //temp_Si and temp_Sj are temporary memory of S[i] and S[j].
	logic load_j, rst_j;
	

	
	always_ff @ (posedge clk) begin //The register of j. 
		if (rst_j)
			j <= 0; 
		
		else if (load_j)
			j <= D; 
	end
	
	always_comb begin //This is the computing unit of j.	
		case (i % 3)
			0:
			begin
				D = (j + temp_Si + {1'b0, key[23:16]}) % 256;
			end
			
			1:
			begin
				D = (j + temp_Si + {1'b0, key[15:8]}) % 256;
			end
			
			2:
			begin
				D = (j + temp_Si + {1'b0, key[7:0]}) % 256;
			end
			
			default:
				D = 0; 
				
		endcase 
		
	end
	
	typedef enum {
	state_initial,
	state_read_Si,
	state_dummy_i,
	state_store_Si,
	state_load_j,
	state_read_Sj,
	state_dummy_j,
	state_store_Sj,
	state_write_Sj_to_i,
	state_write_Si_to_j
	} state_type;
	
	state_type state;
	
	always_ff @ (posedge clk or negedge rst_n) begin
		if (~rst_n) begin
			state <= state_initial;
			i <= 0;
			rst_j <= 1;
			load_j <= 1'b0;
			rdy <= 1'b1; //after the reset, the state machine is ready for a request. 
			wren <= 1'b0;
		end

		else begin
			case (state)
				state_initial:
				begin
					i <= 0;
					rst_j <= 1;
					rdy <= 1'b1;
					wren <= 1'b0;					
					if (en)
						state <= state_read_Si;
				end
				
				state_read_Si:
				begin
					rst_j <= 0;
					wren <= 1'b0;
					addr = i[7:0]; //send out the address = i. 
					rdy <= 1'b0; //deassert the ready signal as at this state, the state machine is already processing a request and cannot handle any more request. 
					state <= state_dummy_i; //wait one extra cycle for readdata.   
				end
				
				state_dummy_i: //readdata arrives at this rising edge. 
				begin
					state <= state_store_Si;
				end
				
				state_store_Si:
				begin
					load_j <= 1'b1; //Load j as well since temp_Si will be ready. 
					temp_Si <= {1'b0,rddata}; //store the read data into temporary memory. 
					state <= state_load_j;
				end
				
				state_load_j: //This is really a dummy state to wait for the update of j. 
				begin
					load_j <= 0;
					state <= state_read_Sj;
				end
				
				state_read_Sj:
				begin 
					addr <= j[7:0]; //send out the address = j. 
					state <= state_dummy_j; 
				end
				
				state_dummy_j:
				begin
					state <= state_store_Sj;
				end
				
				state_store_Sj:
				begin
					temp_Sj <= {1'b0,rddata}; //store the read data into temporary memory. 
					state <= state_write_Sj_to_i;
				end
				
				state_write_Sj_to_i:
				begin
					wren <= 1'b1;
					addr <= i[7:0];
					wrdata <= temp_Sj[7:0];
					state <= state_write_Si_to_j;
				end
				
				state_write_Si_to_j:
				begin
					wren <= 1'b1;
					addr <= j[7:0];
					wrdata <= temp_Si[7:0];
					i = i + 1'b1;
					if (i == 256)
						state <= state_initial;
					else 
						state <= state_read_Si;
				end
				
			endcase
		end
	end
endmodule: ksa

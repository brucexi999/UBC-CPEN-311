module pixel_xformer_avalon(input logic clk, input logic reset_n,
                            // slave
                            input logic [3:0] slave_address,
                            input logic slave_read, output logic [31:0] slave_readdata,
                            input logic slave_write, input logic [31:0] slave_writedata,
                            // master
                            input logic waitrequest, output logic [31:0] master_address,
                            output logic master_write, output logic [31:0] master_writedata);
							
	logic signed [31:0] matrix_00;
	logic signed [31:0] matrix_01;
	logic signed [31:0] matrix_02;
	logic signed [31:0] matrix_10;
	logic signed [31:0] matrix_11;
	logic signed [31:0] matrix_12;
	logic signed [31:0] matrix_20;
	logic signed [31:0] matrix_21;
	logic signed [31:0] matrix_22; //Define the matrix elements. Is there a way to make a matrix in Verilog with signed elements? 
	logic [7:0] x, x_t; 
	logic [6:0] y, y_t;
	logic [2:0] colour; //Define the x, y coords and the colour. x_t and y_t are translated + rotated coords. 
	logic matrix_done; //Tell the master that matrix is done loading, proceeding to read pixels.
	logic en; //Enable signal to compute translated + rotated coords, controlled by the master.
	//Master needs to have a control on when new x_t and y_t are coming, and consequently, have a control
	//on the write process. 
	
	//Slave reading the signals from CPU and store then locally----
    always @* begin 
		if (~reset_n) begin
			x = 8'b0;
			y = 7'b0; 
			colour = 3'b0; 
			matrix_00 = 32'b0;
			matrix_01 = 32'b0;
			matrix_02 = 32'b0;
			matrix_10 = 32'b0;
			matrix_11 = 32'b0;
			matrix_12 = 32'b0;
			matrix_20 = 32'b0;
			matrix_21 = 32'b0;
			matrix_22 = 32'b0;
		end 
		else if (slave_write)
			case (slave_address)
				4'b0000: begin
						 colour = slave_writedata [18:16];
						 x = slave_writedata [15:8];
						 y = slave_writedata [6:0];
						 end
				4'b0001: matrix_00 = slave_writedata; 
				4'b0010: matrix_01 = slave_writedata;
				4'b0011: matrix_02 = slave_writedata;
				4'b0100: matrix_10 = slave_writedata;
				4'b0101: matrix_11 = slave_writedata;
				4'b0110: begin
						 matrix_12 = slave_writedata;
						 matrix_done = 1; 
						 end
				4'b0111: matrix_20 = slave_writedata;
				4'b1000: matrix_21 = slave_writedata;
				4'b1001: matrix_22 = slave_writedata;
		endcase
	end
	//--------------------------------------------------------------
	
	//Compute the transformation coords-----------------------------
	always @* begin
		if (en) begin//When enabled, x_t and y_t are generated and waiting to be sent. 
			x_t = (matrix_00 * x + matrix_01 * y + matrix_02) >> 16;
			y_t = (matrix_10 * x + matrix_11 * y + matrix_12) >> 16;
		end
	end
	//--------------------------------------------------------------
	
	//Master output the coords and colour to VGA--------------------
	typedef enum {
	state_reset,
	state_matrix, 
	state_read_pixel,
	state_write,
	state_wait_1,
	state_wait_2
	} state_type;

	state_type state;
	
	always @(posedge clk or negedge reset_n) begin //
		if (~reset_n) begin
			state = state_reset;
			master_write = 0;
			//en = 0;
		end
		else begin
			case (state)
				state_reset: begin 
							 en = 0; 
							 master_write = 0; //The reset state, make sure master_write = 0;
							 state = state_matrix; 
							 end
							 
				state_matrix: begin 
				              en = 0;
							  master_write = 0;
							  if (matrix_done)
								state = state_read_pixel; //When the loading of matrix is done, i.e. slave_address = 0, we start to read pixels. 
							  end	
							
				state_read_pixel: begin 
								  en = 1;
							      master_write = 0;
								  state = state_write;
								  end
							  
                state_write: begin 
							 en = 0;
							 master_write = 1;
						     master_address = 'hA200; 
							 //x_t = (matrix_00 * x + matrix_01 * y + matrix_02) >> 16;
							 //y_t = (matrix_10 * x + matrix_11 * y + matrix_12) >> 16;
						     master_writedata = {13'b0, colour, x_t, 1'b0, y_t};
							 //if (waitrequest == 0)
							 state = state_wait_1; //Hold this state until waitrequest goes high. 
							 //else if (waitrequest == 1)
								//state = state_wait_2; //If waitrequest goes high, we go to wait state 2, where write, address, and writedata are kept. 
							 end
				state_wait_1: begin 
							if (waitrequest == 0)
								state = state_read_pixel;
							end
			endcase
		end
	end
	//--------------------------------------------------------------
endmodule: pixel_xformer_avalon
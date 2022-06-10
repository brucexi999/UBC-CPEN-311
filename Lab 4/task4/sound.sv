module sound(input CLOCK_50, input CLOCK2_50, input [3:0] KEY, input [9:0] SW,
             input AUD_DACLRCK, input AUD_ADCLRCK, input AUD_BCLK, input AUD_ADCDAT,
			 inout FPGA_I2C_SDAT, output FPGA_I2C_SCLK, output AUD_DACDAT, output AUD_XCK,
             output [6:0] HEX0, output [6:0] HEX1, output [6:0] HEX2,
             output [6:0] HEX3, output [6:0] HEX4, output [6:0] HEX5,
             output [9:0] LEDR);
			
// an enumerated type for our state machine

typedef enum { state_wait_until_ready, state_send_sample, state_wait_for_accepted } state_type;

// signals that are used to communicate with the audio core

reg read_ready, write_ready, write_s;
reg [15:0] writedata_left, writedata_right;
reg [15:0] readdata_left, readdata_right;	
wire reset, read_s;

// some signals I will use in my always block

integer cnt;
state_type state;
reg [15:0] sample;

// instantiate the parts of the audio core. 

clock_generator my_clock_gen(CLOCK2_50, reset, AUD_XCK);
audio_and_video_config cfg(CLOCK_50, reset, FPGA_I2C_SDAT, FPGA_I2C_SCLK);
audio_codec codec(CLOCK_50,reset,read_s,write_s,writedata_left, writedata_right,AUD_ADCDAT,AUD_BCLK,AUD_ADCLRCK,AUD_DACLRCK,read_ready, write_ready,readdata_left, readdata_right,AUD_DACDAT);

// The audio core requires an active high reset signal

assign reset = ~(KEY[3]);

// we will never read from the microphone in this lab, so we might as well set read_s to 0.

assign read_s = 1'b0;

// The main state machine in the design. The purpose of this state machien
// is to send samples to the audio core. This machine will send 91 high samples
// followed by 91 low samples, and repeat. It turns out that this square wave 
// will sound like a single tone when played. In the lab, you will modify this
// to send the actual samples (which descirbe a waveform much more complex
// than just a square wave).
	
always_ff @(posedge CLOCK_50)
   if (reset == 1'b1) begin
         state <= state_wait_until_ready;
         write_s <= 1'b0;
         cnt <= 0;
			
   end else begin
      case (state)
		
         state_wait_until_ready: begin
				 
				     // In this state, we set write_s to 0,
					 // and wait for write_ready to become 1.
					 // The write_ready signal will go 1 when the FIFOs
					 // are ready to accept new data.  We can't do anything
					 // until this signal goes to a 1.
					 
				    write_s <= 1'b0;
                if (write_ready == 1'b1)  
	                 state <= state_send_sample;
             end // state_wait_until_ready				   
   
         state_send_sample: begin
				 
				     // Now that the core has indicated that it is ready to 
					 // accept a sample, send one.  In this case, our samples are
					 // calculated (rather than read from the flash memory)
					 
				    cnt = cnt + 1;  // used to calculate the sample value
					 if (cnt == 182)
					     cnt = 0;
					
					 // The sample is either -256 or 256 depending on the count.
					 // Note that we can scale this up (say -512 and 512) if we
					 // want a louder volume.  I found 256 plenty loud for me.
					 
					 sample = -256;
					 if (cnt > 91) 
					    sample = 256;
					 
                     // send the sample to the core (it is added to the two FIFOs
                     // as explained in the handout.  We need to be sure to send data
					 // to both the right and left queue.  Since we are only playing a
					 // mono sound (not stereo) we send the same sample to both FIFOs.
					 // You will do the same in your implementation in the final task.
					 
				    writedata_right <= sample;
				    writedata_left <= sample;
			        write_s <= 1'b1;  // indicate we are writing a value
                    state <= state_wait_for_accepted;
				   end // state_send_sample
					
		       state_wait_for_accepted: begin

                     // now we have to wait until the core has accepted
	                 // the value. We will know this has happened when
	                 // write_ready goes to 0.   Once it does, we can 
					 // go back to the top, set write_s to 0, and 
					 // wait until the core is ready for a new sample.
					 
				    if (write_ready == 1'b0) 
				        state <= state_wait_until_ready;
				    
					end // state_wait_for_accepted
					
	          default: begin
				 
				    // should never happen, but good practice
					 
                state <= state_wait_until_ready;
					 
				 end // default
			endcase
     end  // if 

endmodule: sound

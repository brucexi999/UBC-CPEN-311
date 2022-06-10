module datapath(input slow_clock, input fast_clock, input resetb,
                input load_pcard1, input load_pcard2, input load_pcard3,
                input load_dcard1, input load_dcard2, input load_dcard3,
                output [3:0] pcard3_out,
                output [3:0] pscore_out, output [3:0] dscore_out,
                output[6:0] HEX5, output[6:0] HEX4, output[6:0] HEX3,
                output[6:0] HEX2, output[6:0] HEX1, output[6:0] HEX0);
						
// The code describing your datapath will go here.  Your datapath 
// will hierarchically instantiate six card7seg blocks, two scorehand
// blocks, and a dealcard block.  The registers may either be instatiated
// or included as sequential always blocks directly in this file.
//
// Follow the block diagram in the Lab 1 handout closely as you write this code.
wire [3:0] new_card;
wire [3:0] cardP1;
wire [3:0] cardP2;
wire [3:0] cardP3;

wire [3:0] cardD1;
wire [3:0] cardD2;
wire [3:0] cardD3;

dealcard DealCard (fast_clock, resetb, new_card);

//Player's
reg4 PCard1 (new_card, load_pcard1, resetb, slow_clock, cardP1);
reg4 PCard2 (new_card, load_pcard2, resetb, slow_clock, cardP2);
reg4 PCard3 (new_card, load_pcard3, resetb, slow_clock, cardP3);

assign pcard3_out = cardP3;

scorehand scorehandP (cardP1, cardP2, cardP3, pscore_out);

card7seg card7segP1 (cardP1, HEX0);
card7seg card7segP2 (cardP2, HEX1);
card7seg card7segP3 (cardP3, HEX2);

//Dealer's 
reg4 DCard1 (new_card, load_dcard1, resetb, slow_clock, cardD1);
reg4 DCard2 (new_card, load_dcard2, resetb, slow_clock, cardD2);
reg4 DCard3 (new_card, load_dcard3, resetb, slow_clock, cardD3);

scorehand scorehandD (cardD1, cardD2, cardD3, dscore_out);

card7seg card7segD1 (cardD1, HEX3);
card7seg card7segD2 (cardD2, HEX4);
card7seg card7segD3 (cardD3, HEX5);


endmodule


module stopwatch(CLOCK_50,KEY,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5);
	input CLOCK_50;
	input [1:0]KEY;
	output [0:7] HEX0,HEX1,HEX2,HEX3,HEX4,HEX5;
	wire reset_n = KEY[1];
	wire tick_100Hz;
	wire ms_clk;
	wire tenths_in,ones_in,tens_in;
	wire dummy_carry;
	wire [3:0]hundredths_bcd,tenths_bcd,ones_bcd,tens_bcd;
	wire clk_100Hz_sq; // optional (unused)
	clockdivider u_div(
        .CLK_50_MHz (CLOCK_50),
        .reset_n    (reset_n),
        .CLK_100Hz  (clk_100Hz_sq),
        .tick_100Hz (tick_100Hz)
    );
	 
    ms_clock_switched u_gate (
        .tick_in (tick_100Hz),
        .run_n   (KEY[0]),
        .tick_out(ms_clk)
    );

   
	bcd_counter u_hundredths (
			  .clk_en_pulse (ms_clk),
			  .reset_n      (reset_n),
			  .bcd          (hundredths_bcd),
			  .carry        (tenths_in)
		 );
	
	bcd_counter u_tenths (
			  .clk_en_pulse (tenths_in),
			  .reset_n      (reset_n),
			  .bcd          (tenths_bcd),
			  .carry        (ones_in)
		 );
		 
	
	 bcd_counter u_ones (
			  .clk_en_pulse (ones_in),
			  .reset_n      (reset_n),
			  .bcd          (ones_bcd),
			  .carry        (tens_in)
		 );

    bcd_counter u_tens (
        .clk_en_pulse (tens_in),
        .reset_n      (reset_n),
        .bcd          (tens_bcd),
        .carry        (dummy_carry)
    );
	 
	 wire [0:6] seg_hundredths, seg_tenths, seg_ones, seg_tens;
	 seven_segment_decoder dec_hundredths (.bcd(hundredths_bcd), .HEX(seg_hundredths));
    seven_segment_decoder dec_tenths     (.bcd(tenths_bcd),     .HEX(seg_tenths));
    seven_segment_decoder dec_ones       (.bcd(ones_bcd),       .HEX(seg_ones));
    seven_segment_decoder dec_tens       (.bcd(tens_bcd),       .HEX(seg_tens));

    // Map to digits: HEX5 HEX4 . HEX3 HEX2 = tens ones . tenths hundredths
    // DP (bit 7) is active-low; drive it ONLY here (decoder has no DP).
    assign HEX2[0:6] = seg_hundredths;  assign HEX2[7] = 1'b1; // no dot
    assign HEX3[0:6] = seg_tenths;      assign HEX3[7] = 1'b1; // no dot
    assign HEX4[0:6] = seg_ones;        assign HEX4[7] = 1'b0; // DOT ON here
    assign HEX5[0:6] = seg_tens;        assign HEX5[7] = 1'b1; // no dot

    // Unused digits -> blank (all off = 1 because active-low).
    assign HEX0 = 8'b1111_1111;
    assign HEX1 = 8'b1111_1111;

endmodule

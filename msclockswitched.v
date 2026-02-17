module ms_clock_switched (
    input  wire tick_in,   // single-cycle enable at 100 Hz
    input  wire run_n,     // active-low button; 0 = run
    output wire tick_out   // gated 100 Hz pulses
);
    assign tick_out = (run_n == 1'b0) ? tick_in : 1'b0;
endmodule

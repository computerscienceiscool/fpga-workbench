// blinky_tb.v -- Testbench for blinky.v
//
// Simulates the blinky design for a short period and dumps a VCD
// waveform file that can be viewed with GTKWave.
//
// Run:  iverilog -o blinky_tb blinky.v blinky_tb.v && vvp blinky_tb
// View: gtkwave blinky_tb.vcd

`timescale 1ns / 1ps

module blinky_tb;

    reg clk = 0;
    wire LED_R, LED_G, LED_B;

    // Instantiate the design under test
    top uut (
        .clk   (clk),
        .LED_R (LED_R),
        .LED_G (LED_G),
        .LED_B (LED_B)
    );

    // 12 MHz clock: period = 83.33 ns
    always #41.667 clk = ~clk;

    initial begin
        $dumpfile("blinky_tb.vcd");
        $dumpvars(0, blinky_tb);

        // Simulate long enough to see several LED transitions.
        // 2^24 cycles at 12 MHz ~ 1.4 s.  We simulate ~3 seconds
        // worth of clock cycles (36 million cycles = 3 s * 12e6).
        // That would be slow, so we only run 2^26 cycles (~5.6 s
        // real time) but at full speed in simulation.
        //
        // For a quick smoke test, 2^25 cycles is plenty:
        #(83.334 * (1 << 25));

        $display("=== Simulation complete ===");
        $display("Final counter value: %d", uut.counter);
        $display("LED_R=%b  LED_G=%b  LED_B=%b", LED_R, LED_G, LED_B);
        $finish;
    end

    // Print LED state whenever it changes
    reg [2:0] prev_leds = 3'b111;
    always @(LED_R or LED_G or LED_B) begin
        if ({LED_R, LED_G, LED_B} != prev_leds) begin
            $display("t=%0t ns: LED_R=%b LED_G=%b LED_B=%b",
                     $time, LED_R, LED_G, LED_B);
            prev_leds = {LED_R, LED_G, LED_B};
        end
    end

endmodule

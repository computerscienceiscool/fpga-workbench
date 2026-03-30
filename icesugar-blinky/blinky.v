// blinky.v -- Classic FPGA "hello world" for the IceSugar board
//
// Blinks the on-board RGB LED by cycling through colors using the
// upper bits of a free-running counter driven by the 12 MHz clock.
//
// The IceSugar RGB LED is active-low: drive 0 to light, 1 to turn off.
// Counter bit 23 at 12 MHz toggles at ~12e6 / 2^24 ~ 0.71 Hz (per color).

module top (
    input  wire clk,      // 12 MHz on-board oscillator
    output wire LED_R,    // Red   (active low, pin 40)
    output wire LED_G,    // Green (active low, pin 41)
    output wire LED_B     // Blue  (active low, pin 39)
);

    reg [25:0] counter = 26'd0;

    // Each color channel is driven by a different counter bit so the
    // LED cycles through 8 color combinations (including off/white).
    assign LED_R = ~counter[23];
    assign LED_G = ~counter[24];
    assign LED_B = ~counter[25];

    always @(posedge clk) begin
        counter <= counter + 1'b1;
    end

endmodule

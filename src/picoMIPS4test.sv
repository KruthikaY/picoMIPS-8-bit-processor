module picoMIPS4test(
    input  logic fastclk,  // 50MHz Altera DE0 clock
    input  logic [9:0] SW, // Switches SW0..SW9
    output logic [7:0] LED // LEDs
);

    logic clk; // slow clock, about 10Hz (actually ~2-3Hz with n=24)
    counter #(4)c (.fastclk(fastclk), .clk(clk));

    // Instantiate your picoMIPS design
    picoMIPS Design (.clk(clk), .SW(SW), .LED(LED));

endmodule

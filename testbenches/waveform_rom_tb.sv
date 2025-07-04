// Testbench for waveform_rom module

`timescale 1ns/1ps

module wave_tb;

    // Testbench signals
    logic [7:0] address;
    logic [7:0] data;

    // Instantiate the waveform_rom module
    wave uut (
        .address(address),
        .data(data)
    );

    // Test procedure
    initial begin
        $display("Starting waveform_rom test...");

        // Test a few known addresses
        address = 8'd0;
        #10 $display("Address: %0d -> Data: %0h", address, data);

        address = 8'd5;
        #10 $display("Address: %0d -> Data: %0h", address, data);

        address = 8'd100;
        #10 $display("Address: %0d -> Data: %0h", address, data);

        address = 8'd255;
        #10 $display("Address: %0d -> Data: %0h", address, data);

        $display("Waveform ROM test completed.");
        $stop;
    end

endmodule

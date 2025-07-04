`timescale 1ns/1ps

module register_file_tb;

    // Testbench signals
    logic clk;
    logic enable_write;
    logic [2:0] write_to;
    logic [7:0] data_in;
    logic [2:0] read_from1, read_from2;
    logic [7:0] data_out1, data_out2;

    // Instantiate the DUT (Design Under Test)
    register_file uut (
        .clk(clk),
        .enable_write(enable_write),
        .write_to(write_to),
        .data_in(data_in),
        .read_from1(read_from1),
        .read_from2(read_from2),
        .data_out1(data_out1),
        .data_out2(data_out2)
    );

    // Clock generation: 10ns period
    always #5 clk = ~clk;

    initial begin
        // Initialization
        clk = 0;
        enable_write = 0;
        write_to = 3'b000;
        data_in = 8'h00;
        read_from1 = 3'b000;
        read_from2 = 3'b000;

        // Wait for 10ns
        #10;

        // Write 0xA5 to register 3
        enable_write = 1;
        write_to = 3'd3;
        data_in = 8'hA5;
        #10;

        // Write 0x3C to register 5
        write_to = 3'd5;
        data_in = 8'h3C;
        #10;

        // Disable writing
        enable_write = 0;

        // Set read addresses
        read_from1 = 3'd3;
        read_from2 = 3'd5;
        #10;

        // Check the results
        $display("Read from register 3: %h ", data_out1);
        $display("Read from register 5: %h ", data_out2);

        // Read from an unwritten register (e.g., register 1)
        read_from1 = 3'd1;
        read_from2 = 3'd7;
        #10;
        $display("Read from register 1 : %h", data_out1);
        $display("Read from register 7 : %h", data_out2);

        $finish;
    end

endmodule

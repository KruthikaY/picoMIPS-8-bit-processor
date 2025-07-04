// program_counter_tb.sv
module program_counter_tb;
    // Testbench signals
    reg       clk;
    reg       n_reset;
    reg       halt;
    wire [7:0] pc;

    // Instantiate the program_counter (Device Under Test)
    program_counter dut (
        .clk(clk),
        .n_reset(n_reset),
        .halt(halt),
        .pc(pc)
    );

    // Clock generation: 10 ns period (50 MHz clock)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test sequence
    initial begin
        // Initially, assert reset (active-low) and no halt.
        n_reset = 0;  // Reset is active
        halt = 0;
        #20;          // Wait for a few clock cycles with reset active

        // Release reset; PC should be 0 and then start incrementing on each clock edge.
        n_reset = 1;
        #50;          // Let PC increment for a few cycles

        // Assert halt; PC should stop incrementing.
        halt = 1;
        #50;          // Wait while halted

        // Deassert halt; PC should resume incrementing.
        halt = 0;
        #50;          // Let PC increment again

        $finish;
    end

    // Monitor signals to observe PC behavior
    initial begin
        $monitor("Time=%0t ns | n_reset=%b | halt=%b | PC=%h", $time, n_reset, halt, pc);
    end
endmodule

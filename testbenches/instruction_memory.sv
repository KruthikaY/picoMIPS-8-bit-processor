// Testbench for instruction_memory.sv

`timescale 1ns/1ps

module instruction_memory_tb;

    logic [7:0] address;           // Program Counter 
    logic [15:0] instruction;      // Output instruction

    // Instantiate the instruction memory module
    instruction_memory uut (
        .address(address),
        .instruction(instruction)
    );

    initial begin
        $display("Starting Instruction Memory Test...");

        // Apply a few test addresses
        address = 6'd0;
        #10 $display("Address: %0d -> Instruction: %h", address, instruction);

        address = 6'd1;
        #10 $display("Address: %0d -> Instruction: %h", address, instruction);

        address = 6'd2;
        #10 $display("Address: %0d -> Instruction: %h", address, instruction);

        address = 6'h2;
        #10 $display("Address: %0h -> Instruction: %h", address, instruction);

        address = 6'd63;
        #10 $display("Address: %0d -> Instruction: %h", address, instruction);

        $display("Instruction Memory Test Completed.");
        $stop;
    end

endmodule

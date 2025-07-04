// Testbench for alu.sv

`timescale 1ns/1ps

module alu_tb;

    // Testbench signals
    logic [7:0] A, B;
    logic [2:0] alu_op;
    logic [7:0] result;

    // Instantiate the ALU
    alu uut (
        .A(A),
        .B(B),
        .alu_op(alu_op),
        .result(result)
    );

    initial begin
        $display("Starting ALU Test...");

        // Test ADD
        A = 8'h0A;     // 10
        B= 8'h05;     // 5
        alu_op    = 2'b00;    // ADD
        #10;
        $display("ADD 0A + 05 = %h ", result);

        // Test MULH
        A= 8'h10;     // 16
       B = 8'h20;     // 32
        alu_op    = 2'b01;    // MULH
        #10;
        $display("MULH 10 * 20 = %h ", result);
       

        // Test undefined operation (default case)
        A = 8'h0A;     // 10
        B= 8'h05;     // 5
        alu_op    = 2'b11;
        #10;
        $display("Invalid opcode = %h ", result);

        $display("ALU Test Completed.");
        $stop;
    end

endmodule

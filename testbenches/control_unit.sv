// Testbench for the control_unit module

module control_unit_tb;
    // Testbench signals for the control_unit inputs
    reg  [15:0] instruction;

    // Wires for the control_unit outputs
    wire [3:0]  opcode;
    wire [2:0]  rd;
    wire [2:0]  rs;
    wire [7:0]  immediate;
    wire [1:0]  alu_op;
    wire        reg_write_enable;
    wire        use_immediate;
    wire        is_input;
    wire        is_output;
    wire        is_loadw;
    wire        is_loadi;
    wire        is_move;
    wire        is_addi;
    wire        halt;

    // Instantiate the control_unit.
    // Change the parameter SWAP if needed (0 = no swap, 1 = swap bytes).
    control_unit uut (
        .instruction(instruction),
        .opcode(opcode),
        .rd(rd),
        .rs(rs),
        .immediate(immediate),
        .alu_op(alu_op),
        .reg_write_enable(reg_write_enable),
        .use_immediate(use_immediate),
        .is_input(is_input),
        .is_output(is_output),
        .is_loadw(is_loadw),
        .is_loadi(is_loadi),
        .is_move(is_move),
        .is_addi(is_addi),
        .halt(halt)
    );

    // Display header for clarity.
    initial begin
        $display("Time\tInstruction\tOpcode\tRD\tRS\tImmediate\tALU_OP\tRWE\tUseImm\tIN\tOUT\tLOADW\tLOADI\tMOVE\tADDI\tHALT");
    end

    initial begin
        // Test 1: IN Instruction
        // Expected: opcode=0010, rd = 000 (R0), others 0 except reg_write_enable=1, is_input=1.
        // Corresponds to "2000" in program.hex.
        instruction = 16'h2000;
        #10;
        $display("%0t\t%h\t%b\t%b\t%b\t%h\t%b\t%b\t%b\t%b\t%b\t%b\t%b\t%b\t%b",
                 $time, instruction, opcode, rd, rs, immediate, alu_op,
                 reg_write_enable, use_immediate, is_input, is_output,
                 is_loadw, is_loadi, is_move, is_addi, halt);

        // Test 2: LOADI Instruction
        // Expected: opcode=1110, rd = 001 (R1), immediate=0x00 (for example "E100")
        instruction = 16'hE100;
        #10;
        $display("%0t\t%h\t%b\t%b\t%b\t%h\t%b\t%b\t%b\t%b\t%b\t%b\t%b\t%b\t%b",
                 $time, instruction, opcode, rd, rs, immediate, alu_op,
                 reg_write_enable, use_immediate, is_input, is_output,
                 is_loadw, is_loadi, is_move, is_addi, halt);

        // Test 3: MOVE Instruction
        // Expected: opcode=1111, rd = 010 (R2), rs = 000 (R0), reg_write_enable and is_move asserted.
        // For example: "F400"
        instruction = 16'hF400;
        #10;
        $display("%0t\t%h\t%b\t%b\t%b\t%h\t%b\t%b\t%b\t%b\t%b\t%b\t%b\t%b\t%b",
                 $time, instruction, opcode, rd, rs, immediate, alu_op,
                 reg_write_enable, use_immediate, is_input, is_output,
                 is_loadw, is_loadi, is_move, is_addi, halt);

        // Test 4: ADDI Instruction
        // Expected: opcode=1011, rd = 010 (R2), immediate=0xFE (-2), use_immediate, reg_write_enable, is_addi asserted.
        // For example: "B4FE"
        instruction = 16'hB4FE;
        #10;
        $display("%0t\t%h\t%b\t%b\t%b\t%h\t%b\t%b\t%b\t%b\t%b\t%b\t%b\t%b\t%b",
                 $time, instruction, opcode, rd, rs, immediate, alu_op,
                 reg_write_enable, use_immediate, is_input, is_output,
                 is_loadw, is_loadi, is_move, is_addi, halt);

        // Test 5: LOADW Instruction
        // Expected: opcode=0100, rd = 011 (R3), reg_write_enable and is_loadw asserted.
        // For example: "4600"
        instruction = 16'h4600;
        #10;
        $display("%0t\t%h\t%b\t%b\t%b\t%h\t%b\t%b\t%b\t%b\t%b\t%b\t%b\t%b\t%b",
                 $time, instruction, opcode, rd, rs, immediate, alu_op,
                 reg_write_enable, use_immediate, is_input, is_output,
                 is_loadw, is_loadi, is_move, is_addi, halt);

        // Test 6: MUL Instruction
        // Expected: opcode=0001, rd = 011 (R3), rs = 100 (R4), alu_op=01, reg_write_enable asserted.
        // For example: "1700" (assuming bits align so that rd=011, rs=100).
        instruction = 16'h1700;
        #10;
        $display("%0t\t%h\t%b\t%b\t%b\t%h\t%b\t%b\t%b\t%b\t%b\t%b\t%b\t%b\t%b",
                 $time, instruction, opcode, rd, rs, immediate, alu_op,
                 reg_write_enable, use_immediate, is_input, is_output,
                 is_loadw, is_loadi, is_move, is_addi, halt);

        // Test 7: ADD Instruction
        // Expected: opcode=0000, rd = 001 (R1), rs = 011 (R3), reg_write_enable asserted.
        // For example: "02C0" (which may represent ADD R1,R3).
        instruction = 16'h02C0;
        #10;
        $display("%0t\t%h\t%b\t%b\t%b\t%h\t%b\t%b\t%b\t%b\t%b\t%b\t%b\t%b\t%b",
                 $time, instruction, opcode, rd, rs, immediate, alu_op,
                 reg_write_enable, use_immediate, is_input, is_output,
                 is_loadw, is_loadi, is_move, is_addi, halt);

        // Test 8: OUT Instruction
        // Expected: opcode=0011, rs = 001 (R1), is_output asserted.
        // For example: "3100"
        instruction = 16'h3100;
        #10;
        $display("%0t\t%h\t%b\t%b\t%b\t%h\t%b\t%b\t%b\t%b\t%b\t%b\t%b\t%b\t%b",
                 $time, instruction, opcode, rd, rs, immediate, alu_op,
                 reg_write_enable, use_immediate, is_input, is_output,
                 is_loadw, is_loadi, is_move, is_addi, halt);

        // Test 9: HALT Instruction
        // Expected: opcode=1100, halt asserted.
        // For example: "C000"
        instruction = 16'hC000;
        #10;
        $display("%0t\t%h\t%b\t%b\t%b\t%h\t%b\t%b\t%b\t%b\t%b\t%b\t%b\t%b\t%b",
                 $time, instruction, opcode, rd, rs, immediate, alu_op,
                 reg_write_enable, use_immediate, is_input, is_output,
                 is_loadw, is_loadi, is_move, is_addi, halt);

        $finish;
    end
endmodule

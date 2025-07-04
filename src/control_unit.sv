module control_unit (
    input  logic [15:0] instruction,  // 16-bit instruction
    output logic [3:0]  opcode,       // Bits [15:12]: opcode
    output logic [2:0]  rd,           // Bits [11:9]: destination register (or output register for OUT)
    output logic [2:0]  rs,           // Bits [8:6]: source register
    output logic [7:0]  immediate,    // Bits [7:0]: immediate value
    output logic [1:0]  alu_op,
    output logic        reg_write_enable,
    output logic        use_immediate,
    output logic        use_rs_as_read2, // Select second read port
    output logic        is_input,
    output logic        is_output,
    output logic        is_loadw,
    output logic        is_loadi,
    output logic        is_move,
    output logic        is_addi,
    output logic        halt
);

    assign opcode = instruction[15:12];

    always_comb begin
        // Defaults
        rd               = 3'd0;
        rs               = 3'd0;
        immediate        = 8'd0;
        alu_op           = 2'b00;
        reg_write_enable = 1'b0;
        use_immediate    = 1'b0;
        use_rs_as_read2  = 1'b1; // default for arithmetic operations
        is_input         = 1'b0;
        is_output        = 1'b0;
        is_loadw         = 1'b0;
        is_loadi         = 1'b0;
        is_move          = 1'b0;
        is_addi          = 1'b0;
        halt             = 1'b0;

        case (opcode)
            4'b0000: begin // ADD
                alu_op           = 2'b00;
                reg_write_enable = 1'b1;
                rd               = instruction[11:9];
                rs               = instruction[8:6];
                use_rs_as_read2  = 1'b1;
            end
            4'b0001: begin // MUL
                alu_op           = 2'b01;
                reg_write_enable = 1'b1;
                rd               = instruction[11:9];
                rs               = instruction[8:6];
                use_rs_as_read2  = 1'b1;
            end
            4'b0010: begin // IN
                is_input         = 1'b1;
                reg_write_enable = 1'b1;
                rd               = instruction[11:9];
            end
            4'b0011: begin // OUT
                is_output        = 1'b1;
                // IMPORTANT FIX: For OUT, assign rd with the output register.
                rd               = instruction[11:9];
                // rs is not used.
            end
            4'b0100: begin // LOADW
                is_loadw         = 1'b1;
                reg_write_enable = 1'b1;
                rd               = instruction[11:9];
                // For LOADW, we force the second read port to be R2,
                // which should contain the computed waveform address.
                use_rs_as_read2  = 1'b0;
            end
            4'b1011: begin // ADDI
                alu_op           = 2'b00;
                use_immediate    = 1'b1;
                reg_write_enable = 1'b1;
                rd               = instruction[11:9];
                immediate        = instruction[7:0];
                is_addi         = 1'b1;
                use_rs_as_read2  = 1'b1;
            end
            4'b1110: begin // LOADI
                use_immediate    = 1'b1;
                reg_write_enable = 1'b1;
                rd               = instruction[11:9];
                immediate        = instruction[7:0];
                is_loadi         = 1'b1;
            end
            4'b1111: begin // MOVE
                is_move          = 1'b1;
                reg_write_enable = 1'b1;
                rd               = instruction[11:9];
                rs               = instruction[8:6];
                use_rs_as_read2  = 1'b1;
            end
            4'b1100: begin // HALT
                halt             = 1'b1;
            end
            default: ;
        endcase
    end
endmodule

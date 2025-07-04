`timescale 1ns / 1ps
module picoMIPS(
    input  logic        clk,         // Clock
    input  logic [9:0]  SW,          // SW[9]=reset (active low),            SW[8]=handshake, SW[7:0]=input index
    output logic [7:0]  LED          // LED output

);

    // Internal wires/signals
    logic [15:0] instruction;
    logic [3:0]  opcode;
    logic [2:0]  rd, rs;
    logic [7:0]  immediate;
    logic [1:0]  alu_op;
    logic        reg_write_enable, use_immediate;
    logic        use_rs_as_read2;
    logic        is_input, is_output, is_loadw;
    logic        is_loadi, is_move, is_addi, halt;

    // Data signals
    logic signed [7:0] regfile_data1, regfile_data2, alu_result;
    logic signed [7:0] reg_write_data;
    logic signed [7:0] wave_data;
    logic [7:0]        pc_value;
    logic              n_reset;
    assign n_reset = SW[9]; // Active low reset
    logic triggered;

    // Holding register for OUT value
    logic [7:0] last_out_data;

    // === Program Counter ===
    program_counter pc (
        .clk(clk),
        .n_reset(n_reset),
        .halt(halt || !triggered),
        .pc(pc_value)
    );

    // === Instruction Memory ===
    instruction_memory imem (
        .address(pc_value),
        .instruction(instruction)
    );

    // === Control Unit ===
    control_unit cu (
        .instruction(instruction),
        .opcode(opcode),
        .rd(rd),
        .rs(rs),
        .immediate(immediate),
        .alu_op(alu_op),
        .reg_write_enable(reg_write_enable),
        .use_immediate(use_immediate),
        .use_rs_as_read2(use_rs_as_read2),
        .is_input(is_input),
        .is_output(is_output),
        .is_loadw(is_loadw),
        .is_loadi(is_loadi),
        .is_move(is_move),
        .is_addi(is_addi),
        .halt(halt)
    );

    // === Register File ===
    // For the first read port, we use rd.
    // For the second read port, if use_rs_as_read2 is true, we use rs; otherwise, we force it to 3'd2.

    register_file rf (
        .clk(clk),
        .n_reset(n_reset),
        .enable_write(reg_write_enable),
        .write_to(rd),
        .data_in(reg_write_data),
        .read_from1(rd),
        .read_from2( use_rs_as_read2 ? rs : 3'd2 ),
        .data_out1(regfile_data1),
        .data_out2(regfile_data2)
    );

    // === ALU ===
    alu alu_inst (
        .A(regfile_data1),
        .B(use_immediate ? immediate : regfile_data2),
        .alu_op(alu_op),
        .result(alu_result)
    );
 
    // === Waveform ROM ===
    wave waveform_rom_inst (
        .address(regfile_data2),
        .data(wave_data)
    );

    // === Main Datapath & Writeback (excluding LED update) ===
    always_ff @(posedge clk or negedge n_reset) begin
        if (!n_reset) begin
            triggered      <= 1'b0;
            reg_write_data <= 8'd0;
            last_out_data  <= 8'd0;
        end else begin

            // Handshake logic
            if (!triggered && SW[8])
                triggered <= 1'b1;
            else if (triggered && !SW[8])
                triggered <= 1'b0;

            // Register writeback logic

            if (is_input && SW[8])
                reg_write_data <= SW[7:0];
            else if (is_loadi)
                reg_write_data <= immediate;
            else if (is_move)
                reg_write_data <= regfile_data2;
            else if (is_loadw)
                reg_write_data <= wave_data;
            else
                reg_write_data <= alu_result;

 
            // Capture the OUT value when OUT instruction is active.

            if (is_output && SW[8])
                last_out_data <= regfile_data1;
        end
    end

    // === LED Output Update ===

    always_ff @(posedge clk or negedge n_reset) begin
        if (!n_reset)
            LED <= 8'd0;
        else if (!SW[8])
            LED <= last_out_data;
    end
endmodule


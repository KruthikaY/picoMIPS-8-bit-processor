module register_file(
    input  logic        clk,
    input  logic        n_reset,
    input  logic        enable_write,
    input  logic [2:0]  write_to,
    input  logic [7:0]  data_in,
    input  logic [2:0]  read_from1,
    input  logic [2:0]  read_from2,
    output logic [7:0]  data_out1,
    output logic [7:0]  data_out2
);
    // 8 general purpose registers, 8-bit each.
    logic [7:0] registers [7:0];

    // Write operation
    always_ff @(posedge clk or negedge n_reset) begin
        if (!n_reset) begin
            for (int i = 0; i < 8; i++) begin
                registers[i] <= 8'd0;
            end
        end else if (enable_write) begin
            registers[write_to] <= data_in;
        end
    end

    // Asynchronous read
    assign data_out1 = registers[read_from1];
    assign data_out2 = registers[read_from2];
endmodule

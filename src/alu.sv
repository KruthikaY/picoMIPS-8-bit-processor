module alu(
    input  logic signed [7:0] A,
    input  logic signed [7:0] B,
    input  logic [1:0]        alu_op,
    output logic signed [7:0] result
);
    logic signed [15:0] product;
    always_comb begin
	result = 8'd0;
	product = 16'd0;
        case (alu_op)
            2'b00: begin
                // ADD operation
                result = A + B;
            end
            2'b01: begin
                // MUL operation: perform 8-bit signed multiplication,
                // then extract bits [14:7] (i.e. shift right by 7 bits).
                product = A * B;
                result = product[14:7]; // This truncates the lower 7 bits.
            end
            2'b10: begin
                result = A - B;
            end
            2'b00: begin
                result = A / B;
            end
            default: result = 8'd0;
        endcase
    end
endmodule


module program_counter(
    input  logic clk,
    input  logic n_reset,
    input  logic halt,
    output logic [7:0] pc
);
    always_ff @(posedge clk or negedge n_reset) begin
        if (!n_reset)
            pc <= 8'd0;
        else if (!halt)
            pc <= pc + 1;
    end
endmodule


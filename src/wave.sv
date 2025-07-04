module wave(
    input  logic [7:0] address,
    output logic [7:0] data
);
    logic [7:0] rom [0:255];
    initial begin
        $readmemh("wave.hex", rom);
    end
    assign data = rom[address];
endmodule

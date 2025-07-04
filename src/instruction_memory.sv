module instruction_memory(
    input  logic [7:0] address,
    output logic [15:0] instruction
);
    // For simulation purposes, you can initialize an array with your program.hex data.
    // For synthesis, use your toolís ROM inference from a hex file.
    logic [15:0] rom [0:255];
    initial begin
        $readmemh("program.hex", rom);
    end
    assign instruction = rom[address];
endmodule

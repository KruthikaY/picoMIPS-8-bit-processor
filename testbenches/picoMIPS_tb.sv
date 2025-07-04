`timescale 1ns/1ps
module picoMIPS_tbFinal;

    // Testbench signals
    logic clk;
    logic [9:0] SW;  // SW[9]=reset (active low), SW[8]=handshake, SW[7:0]=input index
    logic [7:0] LED;
    
    // Instantiate picoMIPS (unit under test)
    picoMIPS uut (
        .clk(clk),
        .SW(SW),
        .LED(LED)
    );
    
    // Clock generation: 10 ns period (100 MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Stimulus: hold handshake high for a long time, then deassert
    initial begin
        // Assert reset (SW[9] = 0) for 50 ns
        SW = 10'b0000000000;
        #50;
        
        // Release reset and set input index to 5
        SW[9]   = 1;      // Deassert reset
        SW[7:0] = 8'd5;   // Input index = 5
        // Keep handshake high so triggered=1 and PC runs
        SW[8]   = 1;
        
        // Wait (20,000 ns) so the CPU definitely executes the entire program
        #20000;
        
        // Now deassert handshake, so the LED will update (when SW[8]==0)
        SW[8] = 0;
        
        // Wait an additional 5 s (5,000 ns) to observe final LED state
        #5000;
        
        $finish;
    end
    
    // Single-line monitor for all signals
    initial begin
        $monitor("Time=%0t | PC=%0d | Instr=%h | LED=%h | SW=%b | R0=%h R1=%h R2=%h R3=%h R4=%h R5=%h R6=%h R7=%h",
                 $time,
                 uut.pc.pc,
                 uut.instruction,
                 LED,
                 SW,
                 uut.rf.registers[0],
                 uut.rf.registers[1],
                 uut.rf.registers[2],
                 uut.rf.registers[3],
                 uut.rf.registers[4],
                 uut.rf.registers[5],
                 uut.rf.registers[6],
                 uut.rf.registers[7]);
    end

endmodule

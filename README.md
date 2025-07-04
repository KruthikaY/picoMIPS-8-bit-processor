# 🔧 picoMIPS Processor – Gaussian Smoothing on FPGA (SystemVerilog)

This repository contains the full RTL implementation, testbenches, simulation outputs, and HEX-programmed waveform files for a custom-designed **picoMIPS processor** capable of computing **Gaussian smoothing** using an embedded instruction set architecture (ISA). The processor is implemented in **SystemVerilog**, simulated in **ModelSim**, and synthesized for **Intel DE1-SoC (Cyclone V)** FPGA.

---

## 📁 Repository Structure

├── src/ # Core processor RTL modules
│ ├── alu.sv
│ ├── control_unit.sv
│ ├── counter.sv
│ ├── instruction_memory.sv
│ ├── picoMIPS.sv
│ ├── picoMIPS4test.sv
│ ├── program_counter.sv
│ ├── register_file.sv
│ └── wave.sv
│
├── testbenches/ # Individual module testbenches
│ ├── alu_tb.sv
│ ├── control_unit_tb.sv
│ ├── instruction_memory_tb.sv
│ ├── picoMIPS_tb.sv
│ ├── program_counter_tb.sv
│ ├── register_file_tb.sv
│ └── waveform_rom_tb.sv
│
├── hex files/ # Preloaded HEX files for simulation and synthesis
│ ├── program.hex # Gaussian smoothing program
│ └── wave.hex # Input waveform samples
│
├── Oput_files/ # Simulation and synthesis outputs
│ ├── Block_diagram.png
│ ├── Design_Details.png
│ ├── ES_Output Video.mp4
│ ├── FPGA_Output.png
│ ├── ModelSim_Output.png
│ ├── Output
│ └── Resource_Usage.png
│
├── picoMIPS-Flow Summary.rpt # Intel Quartus synthesis report
└── README.md # Project documentation (this file)


---

## 🧠 Project Overview

The design mimics a simplified RISC-V-inspired ISA customized for signal processing. Key features include:

- 8-bit 2's complement arithmetic
- Support for custom instructions:
  - `LOADW` (waveform ROM read)
  - `ADDI`, `MUL`, `MOVE`
  - `IN`, `OUT`, `HALT`
- Instruction memory initialized from `program.hex`
- Waveform ROM initialized from `wave.hex`
- Output displayed on DE1-SoC board LEDs (`LED[7:0]`)
- Control via switches (`SW[7:0]`, `SW[8]`, `SW[9]`)

---

## ⚙️ Platform Configuration

- **Platform**: Altera Cyclone V FPGA (DE1–SoC)
- **Programming Tool**: Intel Quartus
- **ROM Initialization**: `program.hex` and `wave.hex` preloaded
- **I/O Mapping**:
  - `SW[7:0]`: Index `i` input
  - `SW[8]`: Execution trigger
  - `SW[9]`: Active-low reset
  - `LED[7:0]`: Output smoothed value `S[i]`

---

## 📤 Output Artifacts

| File                       | Description                                       |
|----------------------------|---------------------------------------------------|
| **Block_diagram.png**      | System-level schematic of picoMIPS design        |
| **Design_Details.png**     | ALU and control flow overview                    |
| **ModelSim_Output.png**    | RTL waveform verification (Gaussian output)      |
| **FPGA_Output.png**        | On-board LED verification on DE1-SoC             |
| **Resource_Usage.png**     | Quartus resource utilization report              |
| **ES_Output Video.mp4**    | Demo of on-board execution result                |

---

## ✅ Features

- RTL-synthesizable RISC-style pipeline
- ALU supports ADD and MUL (MUL upper bits truncated)
- Fully combinational control logic
- Modular design with testbenches for each submodule
- LED-based Gaussian output validation
- Optimized for embedded signal processing workloads

---

## 🛠️ Simulation Instructions

1. Launch **ModelSim**  
2. Compile all `src/` files and respective `testbenches/`  
3. Load `picoMIPS_tb.sv` and simulate  
4. View waveform output and register activity  
5. Modify `.hex` files for new instruction sequences

---

Let me know if you’d like to add FPGA pin mappings, synthesis timing reports!

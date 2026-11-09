# TIMER IP – 64-bit Configurable Timer

## 1. Overview
A 64-bit configurable Timer IP designed using Verilog HDL, featuring an AMBA APB Slave interface, programmable clock division, hardware interrupts and debug halt control.
Developed as an Advanced Level Final Project for the Fundamental IC Design and Verification Course at IC Training Center Vietnam.

## 2. Key Features
- APB Interface: 32-bit data bus, 12-bit address bus, byte access and 1-cycle wait state.
- 64-bit Counter: Count-up timer using TDR0 and TDR1.
- Clock Division: Programmable division from 1 to 256.
- Interrupt: 64-bit compare matching with RW1C pending status.
- Debug Halt:Counter freeze and resume in debug mode.
- Error Handling: Invalid configuration detection and APB error response.
- Register Protection: RAZ/WI support for reserved addresses and fields.

## 3. Architecture
The design consists of five main modules:
| Module | Function |
|---|---|
| APB Slave | APB protocol and bus control |
| Register | Register access and address decoding |
| Counter Control | Prescaler and debug halt control |
| Counter | 64-bit counting and auto-clear |
| Interrupt | Compare matching and interrupt generation |

Top module:`timer_top`
## 4. Register Map
| Offset | Register | Description |
|---|---|---|
| 0x000 | TCR | Timer Control |
| 0x004 | TDR0 | Counter Lower 32-bit |
| 0x008 | TDR1 | Counter Upper 32-bit |
| 0x00C | TCMP0 | Compare Lower 32-bit |
| 0x010 | TCMP1 | Compare Upper 32-bit |
| 0x014 | TIER | Interrupt Enable |
| 0x018 | TISR | Interrupt Status |
| 0x01C | THCSR | Halt Control Status |

## 5. Verification
Functional verification covers:
- APB read/write transactions.
- Register reset and byte access.
- Counter operation and clock division.
- Error handling and register protection.
- Debug halt and resume.
- Interrupt generation and clearance.
- Code coverage analysis.
- 
## 6. Tools
- Verilog HDL 
- ModelSim
- RTL Simulation
- Functional Verification
- Code Coverage

## 7. Author
Trinh Minh Quan  
Computer Engineering Student
Ho Chi Minh City University of Technology and Education (HCMUTE)  
IC41 – IC Training Center Vietnam

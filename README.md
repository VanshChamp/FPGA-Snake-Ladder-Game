# FPGA Project: Snake and Ladder Game on an 8x8 LED Matrix
## Overview
This repository contains the design and implementation of a simplified Snake and Ladder game on an FPGA, utilizing an 8×8 LED dot matrix display. The game logic, dice simulation, and real-time display control are all implemented in Verilog HDL. This project showcases advanced skills in hardware-level design for interactive applications.

The primary focus of this project was to create a responsive and precise game experience by directly manipulating the LED matrix through FPGA logic, without relying on external driver ICs.

Project for: Nirma University, Institute of Technology, B. Tech. Semester IV
Submitted by: Vansh Champaneri (23BEC027)

## Key Features & Specifications
Game Logic: Implemented in Verilog, incorporating player movement, dice rolling, and predefined snake and ladder positions.

Direct LED Control: The 8×8 LED matrix is directly controlled by the FPGA, demonstrating efficient use of hardware resources and a deeper understanding of low-level hardware manipulation.

Interactive Interface: The game features two buttons for cycling the dice value and confirming a move, with integrated button debouncing logic to ensure a stable user experience.

Real-Time Display: The game board and player position are displayed on an 8×8 dot matrix LED, with a 7-segment display showing the dice value.

Player Feedback: The player's current position blinks at a fixed rate for clear visibility.

System Architecture: The design utilizes a 50 MHz clock with frequency division for display refresh, blink effects, and state updates, as detailed in the block diagram and flowchart.

## Repository Files
23BEC027_Project_Report.pdf: The full project report detailing the design, implementation, and conclusion of the Snake and Ladder game.

FPGA PIN Assignment.pdf: The pin assignments used for implementation on the FPGA board.

README.md: This file, providing an overview and details of the project.

## How to Run the Project

Open in IDE: Open the Verilog files in Intel Quartus Prime.

Synthesize and Implement: Use the provided pin assignments to synthesize and program the Verilog design onto a compatible FPGA board.

Connect Peripherals: Connect the 8×8 LED matrix and 7-segment display as per the circuit diagrams and pin assignments in the report.

Connect with Me
Feel free to connect on LinkedIn to discuss FPGA-based systems, Verilog, or other projects!

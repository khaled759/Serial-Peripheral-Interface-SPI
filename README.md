# SPI Wrapper with RAM
This repository contains a Verilog implementation of an SPI (Serial Peripheral Interface) wrapper that integrates an SPI slave module with a RAM module. The SPI slave facilitates communication with an SPI master, enabling data to be written to and read from the RAM through the SPI protocol.

# Module Interface
The SPI_wrapper module provides the following interface:

Inputs:

clk: System clock.

rst_n: Active-low reset.

MOSI: Serial data input from the SPI master.

SS_n: Slave select signal (active low).


Outputs:

MISO: Serial data output to the SPI master.



# Internal Architecture
The architecture of the SPI wrapper consists of two primary components:

## SPI Slave Module:

Handles the SPI communication protocol.

Decodes commands from the SPI master to perform read and write operations on the RAM.

Operates using a finite state machine with the following states:

IDLE: Initial state, waiting for SS_n to go low.

CHK_CMD: Checks the command type from the incoming data.

WRITE: Handles writing data to the RAM.

READ_ADD: Manages reading the address for subsequent read operations.

READ_DATA: Facilitates reading data from the RAM and transmitting it via MISO.




## RAM Module:

A synchronous RAM that stores data.

Supports read and write operations based on the address provided.



[Insert Block Diagram Here]

Caption: Block diagram showing the interaction between the SPI slave and RAM modules.
[Insert State Machine Diagram Here]

Caption: State machine diagram detailing the operation of the SPI slave module.
## Operation

The SPI slave interprets 10-bit data frames from the SPI master, where the two most significant bits indicate the command:

00: Write Address - Sets the address for the next write operation.

01: Write Data - Writes the accompanying 8-bit data to the specified address in RAM.

10: Read Address - Sets the address for the next read operation.

11: Read Data - Reads the 8-bit data from the specified address and sends it back to the master via MISO.


The SS_n signal controls the activation of the slave; when low, the slave processes incoming data.
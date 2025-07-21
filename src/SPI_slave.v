module SPI_slave(
    input clk,
    input rst_n,
    input tx_valid,
    input SS_n,
    input [7:0] tx_data,
    input MOSI, 

    output rx_valid,
    output [9:0] rx_data,
    output MISO
);
// TODO
endmodule
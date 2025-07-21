module SPI_wrapper(
    input clk,
    input rst_n,
    input MOSI,
    input SS_n,
    output MISO
);

wire rx_valid, tx_valid;
wire [9:0] rx_data;
wire [7:0] tx_data;



// slave module instentiation
SPI_slave SPI (
    .clk(clk),
    .rst_n(rst_n),
    .tx_valid(tx_valid),
    .SS_n(SS_n),
    .tx_data(tx_data),
    .MOSI(MOSI),
    .rx_valid(rx_valid),
    .rx_data(rx_data),
    .MISO(MISO)
);

// RAM module instentiation
RAM #(.MEM_DEPTH(256), .ADDR_SIZE(8)) Ram (
    .clk(clk),
    .rst_n(rst_n),
    .rx_valid(rx_valid),
    .din(rx_data),
    .dout(tx_data),
    .tx_valid(tx_valid)
);    
endmodule
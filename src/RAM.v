module RAM #(
    parameter MEM_DEPTH = 256,
    parameter ADDR_SIZE = 8
) (
    input wire clk,
    input wire rst_n, // active low reset 
    input wire rx_valid,
    input wire [9:0] din,
    output reg [7:0] dout,
    output reg tx_valid // high in read case only
);

reg [ADDR_SIZE - 1:0] mem [0:MEM_DEPTH - 1]; // memort declaration
reg [ADDR_SIZE - 1:0] WR_ADDR, RD_ADDR; // to hold the write and read address


always @(posedge clk, negedge rst_n) begin
    if(!rst_n) begin
        dout <= 0;
        tx_valid <= 0;
        WR_ADDR <= 0;
        RD_ADDR <= 0;
    end
    else if (rx_valid)
    begin
        case (din[9:8])
            2'b00: // write address
            begin
                WR_ADDR <= din[7:0];
                tx_valid <= 0;
            end
            2'b01: // write data
            begin
                mem[WR_ADDR] <= din[7:0];
                tx_valid <= 0;
            end
            2'b10: // read address
            begin
                RD_ADDR <= din[7:0];
                tx_valid <= 0;
            end
            2'b11: // read data
            begin
                dout <= mem[RD_ADDR];
                tx_valid <= 1;
            end
        endcase
    end
    else 
    begin
        tx_valid <= 0;
    end
end
endmodule
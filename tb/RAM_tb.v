module RAM_tb();
    reg clk;
    reg rst_n; // active low reset 
    reg rx_valid;
    reg [9:0] din;
    wire [7:0] dout;
    wire tx_valid; // high in read case only

    RAM DUT (clk, rst_n, rx_valid, din, dout, tx_valid);

    initial begin
        clk = 0;
        forever begin
            #5 clk = ~clk; // clk period = 10 ns
        end
    end


    initial begin
        rst_n = 0;
        #20;
        rst_n = 1;
        rx_valid = 1;
        din = 10'b0000000001;
        #10;
        din = 10'b0110101010;
        #10;
        din = 10'b1000000001;
        #10;
        din = 10'b1100000001;
    end

endmodule
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
    //FSM states
    localparam [2:0] IDEL = 3'b000, CHK_CMD = 3'b001, WRITE = 3'b010, READ_ADD = 3'b011, READ_DATA = 3'b100; 
    reg [2:0] state = IDEL;

    // counters
    reg [3:0] count = 4'b0;


    always @(posedge clk, negedge rst_n) begin
        if (!rst_n) begin
            rx_valid <= 1'b0;
            rx_data <= 10'b0;
            MISO <= 1'b0;
            state <= IDEL;
        end
        else begin 
            case (state)
                IDEL: begin
                    if(!SS_n) 
                        state <= CHK_CMD;
                    else 
                        state<= IDEL;
                end

                CHK_CMD: begin
                    if ((!SS_n) && (!MOSI)) 
                        state <= WRITE;
                    else if ((!SS_n) && MOSI)
                    // DO SOMETHING
                end

                WRITE : begin
                   if (!SS_n) begin
                        rx_data[9 - count] <= MOSI
                        if(count == 9)begin
                            rx_valid <= 1'b1;
                            count <= 4'b0;
                            state <= IDEL;
                        end
                        else begin
                            count <= count + 1;
                        end
                   end 
                   else begin
                        state <= IDEL;
                   end 
                end

                READ_ADD: begin

                end

                READ_DATA: begin
                    
                end
            endcase
        end
    end

endmodule
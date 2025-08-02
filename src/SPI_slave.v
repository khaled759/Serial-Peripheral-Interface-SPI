module SPI_slave(
    input clk,
    input rst_n,
    input tx_valid,
    input SS_n,
    input [7:0] tx_data,
    input MOSI, 

    output reg rx_valid,
    output reg [9:0] rx_data,
    output reg MISO
);
    //FSM states
    localparam [2:0] IDEL = 3'b000, CHK_CMD = 3'b001, WRITE = 3'b010, READ_ADD = 3'b011, READ_DATA = 3'b100; 
    reg [2:0] state = IDEL;

    // counters
    reg get_in = 1'b1; // control signal
    reg ADD_on = 1'b0;
    reg [3:0] count = 4'b0;

    always @(posedge clk, negedge rst_n) begin
        if (!rst_n) begin
            rx_valid <= 1'b0;
            rx_data <= 10'b0;
            MISO <= 1'b0;
            state <= IDEL;
            get_in <= 1'b1;
            ADD_on <= 1'b0;
            count <= 4'b0;
        end
        else begin 
            case (state)
                IDEL: begin
                    count <= 4'b0;
                    rx_valid <= 1'b0;
                    rx_data <= 10'b0;
                    MISO <= 1'b0;
                    get_in = 1'b1;
                    if(!SS_n) 
                        state <= CHK_CMD;
                    else 
                        state<= IDEL;
                end

                CHK_CMD: begin
                    if ((!SS_n) && (!MOSI)) 
                        state <= WRITE;
                    else if ((!SS_n) && MOSI) begin
                        if (!ADD_on) state <= READ_ADD;
                        else state <= READ_DATA;
                    end
                    else state <= IDEL;
                end

                WRITE : begin
                   if (!SS_n) begin
                        rx_data[9 - count] <= MOSI;
                        if(count == 9)begin
                            rx_valid <= 1'b1;
                            count <= 4'b0;
                            state <= IDEL;
                        end
                        else begin
                            count <= count + 1;
                            rx_valid <= 1'b0;
                        end
                   end 
                   else begin
                        state <= IDEL;
                   end 
                end

                READ_ADD: begin
                    if(!SS_n) begin
                        rx_data[9 - count] <= MOSI;
                        if(count == 9)begin
                            rx_valid <= 1'b1;
                            ADD_on <= 1'b1;
                            count <= 4'b0;
                            state <= IDEL;
                        end
                        else begin
                            count <= count + 1;
                            rx_valid <= 1'b0;
                        end
                    end
                    else state <= IDEL;
                end

                READ_DATA: begin
                    if(!SS_n) begin
                        // Input logic - only when get_in is true
                        if (get_in) begin
                            rx_data[9 - count] <= MOSI;
                            if(count == 9)begin
                                rx_valid <= 1'b1;
                                count <= 0;
                                get_in <= 0;
                            end
                            else begin
                                count <= count + 1;
                                rx_valid <= 1'b0;
                            end
                        end
                        else begin
                            rx_valid <= 1'b0;
                        end
                        
                        // Output logic - start AFTER input is complete
                        if (tx_valid && !get_in) begin  // Only after get_in = 0
                            MISO <= tx_data[7 - count];
                            if (count == 7) begin
                                count <= 4'b0;
                                ADD_on <= 1'b0;
                                get_in <= 1'b1;  // Reset for next time
                                state <= IDEL;
                            end
                            else begin
                                count <= count + 1;
                            end
                        end
                        else begin
                            MISO <= 1'b0;
                        end
                    end
                    else begin
                        state <= IDEL;
                    end
                end
            endcase
        end
    end
endmodule
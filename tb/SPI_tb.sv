`timescale 1ns/1ps

module SPI_tb();

    // Testbench signals
    reg clk;
    reg rst_n;
    reg MOSI;
    reg SS_n;
    wire MISO;
    
    // Instantiate the DUT (Device Under Test)
    SPI_wrapper DUT (
        .clk(clk),
        .rst_n(rst_n),
        .MOSI(MOSI),
        .SS_n(SS_n),
        .MISO(MISO)
    );
    
    // Clock generation - 10ns period (100MHz)
    always #5 clk = ~clk;
    
    // Hardcoded test sequence
    initial begin
        // Initialize
        clk = 0;
        rst_n = 0;
        MOSI = 0;
        SS_n = 1;
        $display("Address: 0x0A, Data: 0x55");
        
        // Reset sequence
        #50 rst_n = 1;
        #50;
        
        // ============================================
        // TEST 1: Write Address (13 cycles)
        // Command: 0 + 00 + 00001010 (address 0x0A)
        // ============================================
        
        @(posedge clk); SS_n = 0;          // Cycle 1: Assert SS_n
        @(posedge clk); MOSI = 0;          // Cycle 2: Command bit (0=write)
        @(posedge clk); MOSI = 0;          // Cycle 3: Control bit 9 (0)
        @(posedge clk); MOSI = 0;          // Cycle 4: Control bit 8 (0)
        @(posedge clk); MOSI = 0;          // Cycle 5: Address bit 7 (0)
        @(posedge clk); MOSI = 0;          // Cycle 6: Address bit 6 (0)
        @(posedge clk); MOSI = 0;          // Cycle 7: Address bit 5 (0)
        @(posedge clk); MOSI = 0;          // Cycle 8: Address bit 4 (0)
        @(posedge clk); MOSI = 1;          // Cycle 9: Address bit 3 (1)
        @(posedge clk); MOSI = 0;          // Cycle 10: Address bit 2 (0)
        @(posedge clk); MOSI = 1;          // Cycle 11: Address bit 1 (1)
        @(posedge clk); MOSI = 0;          // Cycle 12: Address bit 0 (0)
        @(posedge clk); SS_n = 1;          // Cycle 13: Deassert SS_n
        
        #50; // Wait between commands
        
        // ============================================
        // TEST 2: Write Data (13 cycles)  
        // Command: 0 + 01 + 01010101 (data 0x55)
        // ============================================
        
        @(posedge clk); SS_n = 0;          // Cycle 1: Assert SS_n
        @(posedge clk); MOSI = 0;          // Cycle 2: Command bit (0=write)
        @(posedge clk); MOSI = 0;          // Cycle 3: Control bit 9 (0)
        @(posedge clk); MOSI = 1;          // Cycle 4: Control bit 8 (1)
        @(posedge clk); MOSI = 0;          // Cycle 5: Data bit 7 (0)
        @(posedge clk); MOSI = 1;          // Cycle 6: Data bit 6 (1)
        @(posedge clk); MOSI = 0;          // Cycle 7: Data bit 5 (0)
        @(posedge clk); MOSI = 1;          // Cycle 8: Data bit 4 (1)
        @(posedge clk); MOSI = 0;          // Cycle 9: Data bit 3 (0)
        @(posedge clk); MOSI = 1;          // Cycle 10: Data bit 2 (1)
        @(posedge clk); MOSI = 0;          // Cycle 11: Data bit 1 (0)
        @(posedge clk); MOSI = 1;          // Cycle 12: Data bit 0 (1)
        @(posedge clk); SS_n = 1;          // Cycle 13: Deassert SS_n
        
        #50; // Wait between commands
        
        // ============================================
        // TEST 3: Read Address (13 cycles)
        // Command: 1 + 10 + 00001010 (address 0x0A)
        // ============================================
        
        @(posedge clk); SS_n = 0;          // Cycle 1: Assert SS_n
        @(posedge clk); MOSI = 1;          // Cycle 2: Command bit (1=read)
        @(posedge clk); MOSI = 1;          // Cycle 3: Control bit 9 (1)
        @(posedge clk); MOSI = 0;          // Cycle 4: Control bit 8 (0)
        @(posedge clk); MOSI = 0;          // Cycle 5: Address bit 7 (0)
        @(posedge clk); MOSI = 0;          // Cycle 6: Address bit 6 (0)
        @(posedge clk); MOSI = 0;          // Cycle 7: Address bit 5 (0)
        @(posedge clk); MOSI = 0;          // Cycle 8: Address bit 4 (0)
        @(posedge clk); MOSI = 1;          // Cycle 9: Address bit 3 (1)
        @(posedge clk); MOSI = 0;          // Cycle 10: Address bit 2 (0)
        @(posedge clk); MOSI = 1;          // Cycle 11: Address bit 1 (1)
        @(posedge clk); MOSI = 0;          // Cycle 12: Address bit 0 (0)
        @(posedge clk); SS_n = 1;          // Cycle 13: Deassert SS_n
        
        #50; // Wait between commands
        
        // ============================================
        // TEST 4: Read Data (22 cycles)
        // Command: 1 + 11 + 8 dummy bits + 8 MISO data bits
        // ============================================
        
        @(posedge clk); SS_n = 0;          // Cycle 1: Assert SS_n
        @(posedge clk); MOSI = 1;          // Cycle 2: Command bit (1=read)
        @(posedge clk); MOSI = 1;          // Cycle 3: Control bit 9 (1)
        @(posedge clk); MOSI = 1;          // Cycle 4: Control bit 8 (1)
        
        // 8 dummy input bits (cycles 5-12)
        @(posedge clk); MOSI = 0;          // Cycle 5: Dummy bit 7
        @(posedge clk); MOSI = 0;          // Cycle 6: Dummy bit 6
        @(posedge clk); MOSI = 0;          // Cycle 7: Dummy bit 5
        @(posedge clk); MOSI = 0;          // Cycle 8: Dummy bit 4
        @(posedge clk); MOSI = 0;          // Cycle 9: Dummy bit 3
        @(posedge clk); MOSI = 0;          // Cycle 10: Dummy bit 2
        @(posedge clk); MOSI = 0;          // Cycle 11: Dummy bit 1
        @(posedge clk); MOSI = 0;          // Cycle 12: Dummy bit 0
        
        // Wait few cycles for processing (optional)
        @(posedge clk); MOSI = 0;          // Cycle 13: Processing time
        @(posedge clk); MOSI = 0;          // Cycle 14: Processing time
        
        // 8 cycles to collect MISO data (cycles 15-22)
        @(posedge clk);                    // Cycle 15: MISO bit 7
        $display("Time %0t: MISO[7] = %b", $time, MISO);
        @(posedge clk);                    // Cycle 16: MISO bit 6
        $display("Time %0t: MISO[6] = %b", $time, MISO);
        @(posedge clk);                    // Cycle 17: MISO bit 5
        $display("Time %0t: MISO[5] = %b", $time, MISO);
        @(posedge clk);                    // Cycle 18: MISO bit 4
        $display("Time %0t: MISO[4] = %b", $time, MISO);
        @(posedge clk);                    // Cycle 19: MISO bit 3
        $display("Time %0t: MISO[3] = %b", $time, MISO);
        @(posedge clk);                    // Cycle 20: MISO bit 2
        $display("Time %0t: MISO[2] = %b", $time, MISO);
        @(posedge clk);                    // Cycle 21: MISO bit 1
        $display("Time %0t: MISO[1] = %b", $time, MISO);
        @(posedge clk);                    // Cycle 22: MISO bit 0
        $display("Time %0t: MISO[0] = %b", $time, MISO);
        
        @(posedge clk); SS_n = 1;          // End transaction
        #100;
        $finish;
    end
endmodule
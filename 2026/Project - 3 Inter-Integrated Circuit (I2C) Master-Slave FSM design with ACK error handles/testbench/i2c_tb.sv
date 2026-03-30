// i2c_tb.sv
`timescale 1ns/1ps

module i2c_tb;

    localparam CLK_PERIOD = 10;
    localparam CLK_DIV    = 4;
    localparam SLAVE_ADDR = 7'h55;

    logic       clk, rst_n;
    logic       start, rw;
    logic [6:0] addr;
    logic [7:0] wdata;
    logic [7:0] rdata;
    logic       done, ack_err;
    wire        sda;
    logic       scl;

    i2c_master #(.CLK_DIV(CLK_DIV)) dut_master (
        .clk     (clk),
        .rst_n   (rst_n),
        .start   (start),
        .rw      (rw),
        .addr    (addr),
        .wdata   (wdata),
        .rdata   (rdata),
        .done    (done),
        .ack_err (ack_err),
        .sda     (sda),
        .scl     (scl)
    );

    i2c_slave #(.SLAVE_ADDR(SLAVE_ADDR)) dut_slave (
        .clk   (clk),
        .rst_n (rst_n),
        .sda   (sda),
        .scl   (scl)
    );

    pullup (sda);

    // Clock
    initial clk = 1'b0;
    always #(CLK_PERIOD/2) clk = ~clk;

    // Transfer task - no fork/join, simple wait
    task automatic i2c_transfer(
        input logic [6:0] a,
        input logic       r,
        input logic [7:0] wd
    );
        @(posedge clk);
        addr  = a;
        rw    = r;
        wdata = wd;
        start = 1'b1;
        @(posedge clk);
        start = 1'b0;
        wait (done === 1'b1);
        @(posedge clk);
    endtask

    // Main stimulus
    initial begin
        $dumpfile("i2c_tb.vcd");
        $dumpvars(0, i2c_tb);

        // Reset
        rst_n = 1'b0;
        start = 1'b0;
        addr  = 7'h00;
        rw    = 1'b0;
        wdata = 8'h00;      // ← no XX, clean init
        repeat(4) @(posedge clk);
        rst_n = 1'b1;
        repeat(4) @(posedge clk);

        // Test 1: Write 0xAB
        $display("[%0t] TEST 1: Write 0xAB to addr 0x55", $time);
        i2c_transfer(SLAVE_ADDR, 1'b0, 8'hAB);
        if (!ack_err)
            $display("[%0t] PASS: Write ACK received", $time);
        else
            $display("[%0t] FAIL: No ACK on write", $time);

        repeat(20) @(posedge clk);

        // Test 2: Read back
        $display("[%0t] TEST 2: Read from addr 0x55", $time);
        i2c_transfer(SLAVE_ADDR, 1'b1, 8'hFF);  // ← FF not XX
        if (!ack_err)
            $display("[%0t] PASS: Read data = 0x%0h (expect ab)", $time, rdata);
        else
            $display("[%0t] FAIL: No ACK on read", $time);

        repeat(20) @(posedge clk);

        // Test 3: Wrong address - expect ack_err
        $display("[%0t] TEST 3: Wrong address 0x7F (Test Outbound Limit)", $time);
        i2c_transfer(7'h7F, 1'b0, 8'hFF);
        if (ack_err)
            $display("[%0t] PASS: ACK error detected (Test Outbound Limit Unfound)", $time);
        else
            $display("[%0t] FAIL: Expected ACK error (Test Outbound Limit Found)", $time);

        repeat(20) @(posedge clk);
        $display("[%0t] ===== ALL TESTS DONE =====", $time);
        $finish;
    end

    // Watchdog
    initial begin
        #2000000;
        $display("[%0t] WATCHDOG TIMEOUT", $time);
        $finish;
    end

endmodule

//use run 30 us in the tcl console
`timescale 1ns / 1ps

module uart_tb;

    parameter CLK_PERIOD = 10;
    parameter FREQUENCY = 87;

    reg         clk;
    reg         i_DV;
    reg  [7:0]  i_Byte;
    wire        o_Sig_Active;
    wire        o_Sig_Done;
    wire        o_DV;
    wire [7:0]  o_Byte;

    // Clock Generation
    initial clk = 0;
    always #(CLK_PERIOD/2) clk = ~clk;

    // DUT instantiation
    uart_top uut (
        .clk(clk),
        .i_DV(i_DV),
        .i_Byte(i_Byte),
        .o_Sig_Active(o_Sig_Active),
        .o_Sig_Done(o_Sig_Done),
        .o_DV(o_DV),
        .o_Byte(o_Byte)
    );

    // Test sequence
    initial begin
        $display("Time\tTX Done\tRX Valid\tReceived Byte");
        $monitor("%0t\t%b\t%b\t\t%h", $time, o_Sig_Done, o_DV, o_Byte);

        i_DV = 0;
        i_Byte = 8'h00;
        #(10 * CLK_PERIOD);

        // First transmission: 0xC3
        i_Byte = 8'hC3;
        i_DV = 1;
        #(CLK_PERIOD);
        i_DV = 0;

        @(posedge o_DV);  // Wait for RX

        #(20 * CLK_PERIOD); // Delay between transmissions

        // Second transmission: 0x5A
        i_Byte = 8'h5A;
        i_DV = 1;
        #(CLK_PERIOD);
        i_DV = 0;

        @(posedge o_DV);  // Wait for RX

        #(20 * CLK_PERIOD);
    end
initial begin
        #30000;  // 30 us
        $display("Simulation done at %0t", $time);
        $finish;
    end
endmodule




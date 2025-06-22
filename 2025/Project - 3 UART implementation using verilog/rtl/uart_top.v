//use run 30 us in the tcl console
`timescale 1ns / 1ps
module uart_top (
    input        clk,
    input        i_DV,
    input  [7:0] i_Byte,
    output       o_Sig_Active,
    output       o_Sig_Done,
    output       o_DV,
    output [7:0] o_Byte
);

    wire serial_line;

    // Instantiate Transmitter
    transmitter #(.FREQUENCY(87)) tx_inst (
        .clk(clk),
        .i_DV(i_DV),
        .i_Byte(i_Byte),
        .o_Sig_Active(o_Sig_Active),
        .o_Serial_Data(serial_line),
        .o_Sig_Done(o_Sig_Done)
    );

    // Instantiate Receiver
    receiver #(.FREQUENCY(87)) rx_inst (
        .clk(clk),
        .i_Serial_Data(serial_line),
        .o_DV(o_DV),
        .o_Byte(o_Byte)
    );

endmodule

`timescale 1ns / 1ps

module IFU(
    input clk,
    input reset,
    output reg [31:0] PC
);

always @(posedge clk or posedge reset) begin
    if (reset)
        PC <= 0;
    else
        PC <= PC + 4;
end

endmodule
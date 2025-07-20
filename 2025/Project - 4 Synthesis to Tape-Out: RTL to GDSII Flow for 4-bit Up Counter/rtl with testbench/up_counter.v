`timescale 1ns / 1ps
module up_counter (
    input wire clk,
    input wire rst,      // synchronous reset
    output reg [3:0] count
);

always @(posedge clk) begin
    if (rst)
        count <= 4'b0000;
    else
        count <= count + 1;
end

endmodule






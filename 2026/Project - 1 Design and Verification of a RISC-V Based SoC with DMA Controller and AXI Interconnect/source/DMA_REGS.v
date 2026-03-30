`timescale 1ns / 1ps

module DMA_REGS(
    input clk,
    input reset,
    input [31:0] addr,
    input [31:0] wdata,
    input write,
    output reg [31:0] rdata,

    output reg [31:0] src,
    output reg [31:0] dst,
    output reg [31:0] len,
    output reg start
);

always @(posedge clk or posedge reset) begin
    if(reset) begin
        src   <= 0;
        dst   <= 0;
        len   <= 0;
        start <= 0;
    end else if(write) begin
        case(addr[5:2])
            0: src   <= wdata;
            1: dst   <= wdata;
            2: len   <= wdata;
            3: start <= wdata[0];
        endcase
    end
end

always @(*) begin
    case(addr[5:2])
        0: rdata = src;
        1: rdata = dst;
        2: rdata = len;
        3: rdata = {31'b0, start};
        default: rdata = 0;
    endcase
end

endmodule
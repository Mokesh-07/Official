`timescale 1ns / 1ps
module AXI_MASTER_CPU(
    input clk,
    input reset,

    input [31:0] mem_addr,
    input [31:0] mem_wdata,
    output [31:0] mem_rdata,
    input mem_read,
    input mem_write,

    output [31:0] M_ADDR,
    output [31:0] M_WDATA,
    input  [31:0] M_RDATA,
    output M_READ,
    output M_WRITE
);

assign M_ADDR  = (mem_read || mem_write) ? mem_addr : 32'h0;
assign M_WDATA = (mem_write) ? mem_wdata : 32'h0;
assign M_READ  = (mem_read  === 1'b1);
assign M_WRITE = (mem_write === 1'b1);
assign mem_rdata = M_RDATA;

endmodule

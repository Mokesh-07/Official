`timescale 1ns / 1ps
module AXI_INTERCONNECT(
    input clk,
    input reset,

    // CPU
    input [31:0] CPU_ADDR,
    input [31:0] CPU_WDATA,
    input CPU_READ,
    input CPU_WRITE,

    // DMA
    input [31:0] DMA_ADDR,
    input [31:0] DMA_WDATA,
    input DMA_READ,
    input DMA_WRITE,

    // Memory
    output reg [31:0] M_ADDR,
    output reg [31:0] M_WDATA,
    output reg M_READ,
    output reg M_WRITE
);

// Priority: DMA > CPU

always @(posedge clk or posedge reset) begin
    if(reset) begin
        M_ADDR  <= 0;
        M_WDATA <= 0;
        M_READ  <= 0;
        M_WRITE <= 0;
    end
    else begin
        if (DMA_READ || DMA_WRITE) begin
            M_ADDR  <= DMA_ADDR;
            M_WDATA <= DMA_WDATA;
            M_READ  <= DMA_READ;
            M_WRITE <= DMA_WRITE;
        end 
        else begin
            M_ADDR  <= CPU_ADDR;
            M_WDATA <= CPU_WDATA;
            M_READ  <= CPU_READ;
            M_WRITE <= CPU_WRITE;
        end
    end
end

endmodule

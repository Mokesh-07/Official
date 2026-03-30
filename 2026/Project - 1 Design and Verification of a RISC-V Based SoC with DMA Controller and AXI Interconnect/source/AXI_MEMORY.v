`timescale 1ns / 1ps

module AXI_MEMORY(
    input clk,
    input [31:0] M_ADDR,
    input [31:0] M_WDATA,
    output reg [31:0] M_RDATA,
    input M_READ,
    input M_WRITE
);

reg [31:0] MEM [0:255];

integer i;

initial begin
    for(i=0; i<256; i=i+1)
        MEM[i] = 0;

    // preload some data
    MEM[0] = 32'h11111111;
    MEM[1] = 32'h22222222;
    MEM[2] = 32'h33333333;
    MEM[3] = 32'h44444444;
end
always @(posedge clk) begin
    if(M_WRITE)
        MEM[M_ADDR[9:2]] <= M_WDATA;   

    if(M_READ)
        M_RDATA <= MEM[M_ADDR[9:2]];
        
    else
        M_RDATA <= 0;
end

endmodule

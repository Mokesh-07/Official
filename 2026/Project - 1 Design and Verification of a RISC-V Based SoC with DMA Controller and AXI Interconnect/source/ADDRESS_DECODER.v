`timescale 1ns / 1ps

module ADDRESS_DECODER(
    input [31:0] addr,
    output reg sel_mem,
    output reg sel_dma
);

always @(*) begin
    if(addr < 32'h1000) begin
        sel_mem = 1;
        sel_dma = 0;
    end else begin
        sel_mem = 0;
        sel_dma = 1;
    end
end

endmodule

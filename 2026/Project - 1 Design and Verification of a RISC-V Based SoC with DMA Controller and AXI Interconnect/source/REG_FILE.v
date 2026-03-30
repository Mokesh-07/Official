`timescale 1ns / 1ps
module REG_FILE(
    input clk,
    input reg_write,
    input [4:0] rs1, rs2, rd,
    input [31:0] write_data,
    output [31:0] read_data1,
    output [31:0] read_data2
);

reg [31:0] regfile [0:31];

integer i;

initial begin
    for(i=0;i<32;i=i+1)
        regfile[i] = 0;
end

assign read_data1 = regfile[rs1];
assign read_data2 = regfile[rs2];

always @(posedge clk) begin
    if(reg_write && rd != 0)
        regfile[rd] <= write_data;
end

endmodule
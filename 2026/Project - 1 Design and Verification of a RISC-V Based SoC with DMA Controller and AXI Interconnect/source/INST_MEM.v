`timescale 1ns / 1ps

module INST_MEM(
    input [31:0] PC,
    output [31:0] Instruction_Code
);

reg [7:0] Memory [0:255];

assign Instruction_Code = {
    Memory[PC+3],
    Memory[PC+2],
    Memory[PC+1],
    Memory[PC]
};
integer i;
initial begin
    for(i = 0; i < 256; i = i + 1)
        Memory[i] = 8'h00;
    Memory[0] = 8'h13;
    Memory[1] = 8'h00;
    Memory[2] = 8'h00;
    Memory[3] = 8'h00;
end

endmodule
`timescale 1ns / 1ps

module PROCESSOR(
    input clk,
    input reset,
    output [31:0] mem_addr,
    output [31:0] mem_wdata,
    input  [31:0] mem_rdata,
    output mem_read,
    output mem_write
);

wire [31:0] PC, Instruction_Code;

// Decode fields
wire [6:0] opcode = Instruction_Code[6:0];
wire [4:0] rs1 = Instruction_Code[19:15];
wire [4:0] rs2 = Instruction_Code[24:20];
wire [4:0] rd  = Instruction_Code[11:7];

// Control signals
wire reg_write;
wire [3:0] alu_control;

// Register file outputs
wire [31:0] reg_data1, reg_data2;

// ALU output
wire [31:0] alu_result;

// Modules
IFU ifu(.clk(clk), .reset(reset), .PC(PC));

INST_MEM imem(.PC(PC), .Instruction_Code(Instruction_Code));

CONTROL ctrl(
    .opcode(opcode),
    .mem_read(mem_read),
    .mem_write(mem_write),
    .reg_write(reg_write),
    .alu_control(alu_control)
);

REG_FILE rf(
    .clk(clk),
    .reg_write(reg_write),
    .rs1(rs1),
    .rs2(rs2),
    .rd(rd),
    .write_data(mem_rdata),
    .read_data1(reg_data1),
    .read_data2(reg_data2)
);

ALU alu(
    .A(reg_data1),
    .B(reg_data2),
    .ALU_Sel(alu_control),
    .ALU_Out(alu_result)
);

// Outputs
assign mem_addr  = alu_result;
assign mem_wdata = reg_data2;

endmodule
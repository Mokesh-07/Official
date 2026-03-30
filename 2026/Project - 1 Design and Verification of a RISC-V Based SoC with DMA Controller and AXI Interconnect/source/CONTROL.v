`timescale 1ns / 1ps

module CONTROL(
    input [6:0] opcode,
    output reg mem_read,
    output reg mem_write,
    output reg reg_write,
    output reg [3:0] alu_control
);

always @(*) begin
            reg_write = 0;
            mem_read  = 0;
            mem_write = 0;
            alu_control = 4'b0000;
            
    case(opcode)

        7'b0110011: begin // R-type
            reg_write = 1;
            //mem_read  = 0;
            //mem_write = 0;
            //alu_control = 4'b0000;
        end

        7'b0000011: begin // LW
            reg_write = 1;
            mem_read  = 1;
            //mem_write = 0;
            //alu_control = 4'b0000;
        end

        7'b0100011: begin // SW
            //reg_write = 0;
            //mem_read  = 0;
            mem_write = 1;
            //alu_control = 4'b0000;
        end

        default: begin
            reg_write = 0;
            mem_read  = 0;
            mem_write = 0;
            alu_control = 4'b0000;
        end
    endcase
end

endmodule
`timescale 1ns / 1ps
module fifo(
  output reg [31:0] data_op,
  output reg full, empty,
  input [31:0] data_in,
  input wr_en, rd_en, clk, rst
);
  reg [31:0] ram[0:31]; // 32 x 32-bit FIFO
  integer wr_ptr, rd_ptr, count;
  always @(posedge clk) begin
    if (rst) begin
      wr_ptr <= 1'b0;
      rd_ptr <= 1'b0;
      count <= 0;
      full <= 0;
      empty <= 1;
      data_op <= 32'b0;
    end else begin
      // WRITE
      if (wr_en && !full) begin
        ram[wr_ptr] <= data_in;
        wr_ptr <= (wr_ptr + 1) % 32;
        count <= count + 1;
      end
      // READ
      if (rd_en && !empty) begin
        data_op <= ram[rd_ptr];
        rd_ptr <= (rd_ptr + 1) % 32;
        count <= count - 1;
      end
      // STATUS FLAGS
      full <= (count == 32);
      empty <= (count == 0);
    end
  end
endmodule

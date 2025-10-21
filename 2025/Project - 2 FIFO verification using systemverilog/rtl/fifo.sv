`timescale 1ns / 1ps
module fifo(
  output reg [31:0] data_op,
  output reg full, empty,
  input [31:0] data_in,
  input wr_en, rd_en, clk, rst
);

  reg [31:0] ram[0:31]; // 32 x 32-bit FIFO memory
  integer wr_ptr, rd_ptr, count;
  integer i; // for loop variable

  always @(posedge clk) begin
    if (rst) begin
      //  Reset all internal pointers and flags
      wr_ptr <= 0;
      rd_ptr <= 0;
      count  <= 0;
      full   <= 0;
      empty  <= 1;
      data_op <= 32'b0;

      //  Initialize all FIFO memory entries to zero
      for (i = 0; i < 32; i = i + 1) begin
        ram[i] <= 32'b0;
      end

    end else begin
      //  WRITE operation
      if (wr_en && !full) begin
        ram[wr_ptr] <= data_in;
        wr_ptr <= (wr_ptr + 1) % 32;
        count <= count + 1;
      end

      //  READ operation
      if (rd_en && !empty) begin
        data_op <= ram[rd_ptr];
        rd_ptr <= (rd_ptr + 1) % 32;
        count <= count - 1;
      end

      //  STATUS flag updates
      full  <= (count == 32);
      empty <= (count == 0);
    end
  end
endmodule

`timescale 1ns / 1ps
module DMA_CONTROLLER(
    input clk,
    input reset,
    input start,
    input [31:0] src,
    input [31:0] dst,
    input [31:0] len,
    output reg done,

    output reg [31:0] M_ADDR,
    output reg [31:0] M_WDATA,
    input  [31:0] M_RDATA,
    output reg M_READ,
    output reg M_WRITE
);

reg [2:0] state;
reg [31:0] count;
reg [31:0] temp;

parameter IDLE=0, READ=1, WAIT=2, CAPTURE=3, WRITE=4, WRITE_WAIT=5, DONE=6;

always @(posedge clk or posedge reset) begin
    if(reset) begin
        state   <= IDLE;
        count   <= 0;
        done    <= 0;
        M_READ  <= 0;
        M_WRITE <= 0;
        M_ADDR  <= 0;
        M_WDATA <= 0;
        temp    <= 0;
    end 
    else begin
        case(state)

            IDLE: begin
                done    <= 0;
                M_READ  <= 0;
                M_WRITE <= 0;

                if(start) begin
                    count <= 0;
                    state <= READ;
                end
            end

            // 🔹 Issue read
            READ: begin
                M_ADDR  <= src + count;
                M_READ  <= 1;
                M_WRITE <= 0;
                state   <= WAIT;
            end

            // 🔹 Wait 1 cycle for memory latency
            WAIT: begin
                M_READ <= 0;
                state  <= CAPTURE;
            end

            // 🔹 Capture valid data
            CAPTURE: begin
                temp  <= M_RDATA;
                state <= WRITE;
            end

            // 🔹 Issue write
            WRITE: begin
                M_ADDR  <= dst + count;
                M_WDATA <= temp;
                M_WRITE <= 1;
                state   <= WRITE_WAIT;
            end

            // 🔹 Complete write
            WRITE_WAIT: begin
                M_WRITE <= 0;
                count   <= count + 4;

                if(count >= len - 4)
                    state <= DONE;
                else
                    state <= READ;
            end

            DONE: begin
                done    <= 1;
                M_READ  <= 0;
                M_WRITE <= 0;
            end

        endcase
    end
end

endmodule

`timescale 1ns/1ps

// ======================================================
// DUT: ROUND ROBIN ARBITER (DFT FRIENDLY)
// ======================================================
module rr_arbiter #(
    parameter N = 32
)(
    input clk,
    input rst_n,
    input [N-1:0] req,
    output reg [N-1:0] grant
);

    reg [$clog2(N)-1:0] pointer;
    reg [N-1:0] grant_comb;
    reg [N-1:0] grant_reg;

    integer i;
    integer idx;
    integer found;

    // Combinational grant logic (no modulo)
    always @(*) begin
        grant_comb = 0;
        found = 0;

        for (i = 0; i < N; i = i + 1) begin
            idx = pointer + i;

            if (idx >= N)
                idx = idx - N;

            if (!found && req[idx]) begin
                grant_comb[idx] = 1;
                found = 1;
            end
        end
    end

    // Sequential logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pointer <= 0;
            grant_reg <= 0;
        end else begin
            grant_reg <= grant_comb;

            // Update pointer based on granted index
            for (i = 0; i < N; i = i + 1) begin
                if (grant_comb[i]) begin
                    if (i == N-1)
                        pointer <= 0;
                    else
                        pointer <= i + 1;
                end
            end
        end
    end

    // Output assignment
    always @(*) begin
        grant = grant_reg;
    end

endmodule
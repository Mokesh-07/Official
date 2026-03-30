// ======================================================
// TESTBENCH
// ======================================================
module tb_rr_arbiter;

    parameter N = 32;

    reg clk, rst_n;
    reg [N-1:0] req;
    wire [N-1:0] grant;

    rr_arbiter #(N) uut (
        .clk(clk),
        .rst_n(rst_n),
        .req(req),
        .grant(grant)
    );

    // Clock
    always #5 clk = ~clk;

    integer k;

    initial begin
        clk = 0;
        rst_n = 0;
        req = 0;

        #20 rst_n = 1;

        // Test 1: Single request rotating
        for (k = 0; k < N; k = k + 1) begin
            @(posedge clk);
            req = (1 << k);
        end

        // Test 2: Multiple requests
        @(posedge clk);
        req = 32'hF0F0F0F0;

        repeat (10) @(posedge clk);

        // Test 3: All requests active
        @(posedge clk);
        req = 32'hFFFFFFFF;

        repeat (20) @(posedge clk);

        // Test 4: Random pattern
        repeat (20) begin
            @(posedge clk);
            req = $random;
        end

        #50 $finish;
    end

    initial begin
        $monitor("T=%0t | req=%h | grant=%h | ptr=%0d",
                  $time, req, grant, uut.pointer);
    end

endmodule
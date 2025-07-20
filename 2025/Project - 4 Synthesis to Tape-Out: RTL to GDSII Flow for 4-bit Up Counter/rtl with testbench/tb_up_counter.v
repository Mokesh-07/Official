`timescale 1ns / 1ps

module tb_up_counter;

// Testbench signals
reg clk;
reg rst;
wire [3:0] count;

// Instantiate the counter
up_counter uut (
    .clk(clk),
    .rst(rst),
    .count(count)
);

// Clock generation
initial begin
    clk = 0;
    forever #5 clk = ~clk; // 10ns clock period
end

// Stimulus
initial begin
    $display("Time\tReset\tCount");
    $monitor("%0dns\t%b\t%0d", $time, rst, count);

    // Initial values
    rst = 1;
    #12;
    rst = 0;

    // Let the counter run
    #100;

    // Apply reset again
    rst = 1;
    #10;
    rst = 0;

    // Run for a while
    #50;

    $finish;
end

endmodule

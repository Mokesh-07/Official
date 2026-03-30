`timescale 1ns / 1ps
module tb_TOP;
// Inputs
reg clk;
reg reset;

// Instantiate DUT
TOP uut (
    .clk(clk),
    .reset(reset)
);

// Clock generation
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

// ================= MAIN TEST =================
initial begin
    $display("===== Starting Simulation =====");

    // Reset
    reset = 1;
    #50;
    reset = 0;

    // Wait some cycles
    #50;

    // ================= CONFIGURE DMA =================
    // Since CPU program is basic, we directly write to DMA regs

    // SRC = 0
    uut.dma_regs.src = 0;

    // DST = 16
    uut.dma_regs.dst = 16;

    // LEN = 16 bytes (4 words)
    uut.dma_regs.len = 16;

    // START DMA
    uut.dma_regs.start = 1;

    #10;
    uut.dma_regs.start = 0;

    // ================= WAIT FOR DMA =================
    wait(uut.done == 1);

    $display("===== DMA COMPLETED =====");

    // ================= CHECK MEMORY =================
    $display("Checking Memory Copy:");

    $display("MEM[0]  = %h", uut.mem.MEM[0]);
    $display("MEM[1]  = %h", uut.mem.MEM[1]);
    $display("MEM[2]  = %h", uut.mem.MEM[2]);
    $display("MEM[3]  = %h", uut.mem.MEM[3]);

    $display("MEM[4]  = %h", uut.mem.MEM[4]);
    $display("MEM[5]  = %h", uut.mem.MEM[5]);
    $display("MEM[6]  = %h", uut.mem.MEM[6]);
    $display("MEM[7]  = %h", uut.mem.MEM[7]);

    $display("===== Simulation Finished =====");
    $stop;
end

// ================= MONITOR =================
initial begin
    $monitor("T=%0t | PC=%h | DMA_STATE=%d | BUS_ADDR=%h | BUS_WDATA=%h",
        $time,
        uut.cpu.PC,
        uut.dma.state,
        uut.ic_addr,
        uut.ic_wdata
    );
end

// ================= WAVEFORM =================
initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, tb_TOP);
end

initial begin
    force uut.mem_read = 0;
    force uut.mem_write = 0;
    #30;
    release uut.mem_read;
    release uut.mem_write;
end
endmodule

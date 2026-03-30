`timescale 1ns / 1ps

module TOP(
    input clk,
    input reset
);

// ================= CPU ↔ SYSTEM =================
wire [31:0] mem_addr;
wire [31:0] mem_wdata;
wire [31:0] mem_rdata;
wire mem_read;
wire mem_write;

// ================= ADDRESS DECODER =================
wire sel_mem, sel_dma;

ADDRESS_DECODER decoder(
    .addr(mem_addr),
    .sel_mem(sel_mem),
    .sel_dma(sel_dma)
);

// ================= DMA REGISTER BLOCK =================
wire dma_start;
wire [31:0] dma_src, dma_dst, dma_len;
wire [31:0] dma_rdata;

DMA_REGS dma_regs(
    .clk(clk),
    .reset(reset),
    .addr(mem_addr),
    .wdata(mem_wdata),
    .write(mem_write && sel_dma),   // CPU writes only when DMA selected
    .rdata(dma_rdata),
    .src(dma_src),
    .dst(dma_dst),
    .len(dma_len),
    .start(dma_start)
);

// ================= CPU =================
PROCESSOR cpu(
    .clk(clk),
    .reset(reset),
    .mem_addr(mem_addr),
    .mem_wdata(mem_wdata),
    .mem_rdata(mem_rdata),
    .mem_read(mem_read),
    .mem_write(mem_write)
);

// ================= AXI BUS =================
wire [31:0] bus_addr;
wire [31:0] bus_wdata;
wire [31:0] bus_rdata;
wire bus_read;
wire bus_write;

// CPU accesses only memory region
//assign bus_read  = mem_read  && sel_mem;
//assign bus_write = mem_write && sel_mem;

wire safe_mem_read  = (mem_read  === 1'b1);
wire safe_mem_write = (mem_write === 1'b1);



// ================= AXI MASTER =================
AXI_MASTER_CPU master(
    .clk(clk),
    .reset(reset),
    .mem_addr(mem_addr),
    .mem_wdata(mem_wdata),
    .mem_rdata(mem_rdata),
    .mem_read(bus_read),
    .mem_write(bus_write),
    .M_ADDR(bus_addr),
    .M_WDATA(bus_wdata),
    .M_RDATA(bus_rdata),
    .M_READ(bus_read),
    .M_WRITE(bus_write)
);

// ================= DMA =================
wire [31:0] dma_addr;
wire [31:0] dma_wdata;
wire dma_read;
wire dma_write;
wire done;

DMA_CONTROLLER dma(
    .clk(clk),
    .reset(reset),
    .start(dma_start),
    .src(dma_src),
    .dst(dma_dst),
    .len(dma_len),
    .done(done),
    .M_ADDR(dma_addr),
    .M_WDATA(dma_wdata),
    .M_RDATA(bus_rdata),
    .M_READ(dma_read),
    .M_WRITE(dma_write)
);

// ================= AXI INTERCONNECT =================
wire [31:0] ic_addr;
wire [31:0] ic_wdata;
wire ic_read;
wire ic_write;

AXI_INTERCONNECT interconnect(
    .clk(clk),
    .reset(reset),
    .CPU_ADDR(bus_addr),
    .CPU_WDATA(bus_wdata),
    .CPU_READ(bus_read),
    .CPU_WRITE(bus_write),
    .DMA_ADDR(dma_addr),
    .DMA_WDATA(dma_wdata),
    .DMA_READ(dma_read),
    .DMA_WRITE(dma_write),
    .M_ADDR(ic_addr),
    .M_WDATA(ic_wdata),
    .M_READ(ic_read),
    .M_WRITE(ic_write)
);

// ================= MEMORY =================
AXI_MEMORY mem(
    .clk(clk),
    .M_ADDR(ic_addr),
    .M_WDATA(ic_wdata),
    .M_RDATA(bus_rdata),
    .M_READ(ic_read),
    .M_WRITE(ic_write)
);

// ================= READ DATA MUX =================
// CPU reads from either memory or DMA registers
// ✅ Force CPU signals to safe values during instability

assign bus_read  = (done) ? (mem_read  && sel_mem) : 0;
assign bus_write = (done) ? (mem_write  && sel_mem) : 0;
assign mem_rdata = (sel_dma) ? dma_rdata : bus_rdata;
endmodule
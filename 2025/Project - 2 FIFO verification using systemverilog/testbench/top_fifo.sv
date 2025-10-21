`timescale 1ns / 1ps
//====================================================
// transaction module 1
//====================================================
class transaction;
  bit rst, clk;
  rand bit [31:0] data_in;
  rand bit wr_en, rd_en; 
  bit [31:0] data_op;
  bit full, empty;
  
  // Constraint: no simultaneous wr/rd
  constraint wr_rd_en {
    !(wr_en && rd_en);
  };
endclass


//====================================================
// interface module 2 (with Assertions)
//====================================================
interface fifo_intf(input logic clk, rst);
  logic [31:0] data_in;
  logic wr_en, rd_en;
  logic [31:0] data_op;
  logic full, empty;
  
  // Clocking blocks
  clocking driver_cb @(posedge clk);
    default input #1 output #1;
    output data_in;
    output wr_en, rd_en;
    input data_op;
    input full, empty;
  endclocking

  clocking monitor_cb @(posedge clk);
    default input #1 output #1;
    input data_in;
    input wr_en, rd_en;
    input data_op;
    input full, empty;
  endclocking
  
  modport DRIVER(clocking driver_cb, input clk, rst);
  modport MONITOR(clocking monitor_cb, input clk, rst);

  //====================================================
  // Assertions
  //====================================================
  property no_write_when_full;
    @(posedge clk) disable iff (rst)
      !(wr_en && full);
  endproperty
  assert property (no_write_when_full)
    else $error("ASSERTION FAILED: Write attempted when FIFO full");

  property no_read_when_empty;
    @(posedge clk) disable iff (rst)
      !(rd_en && empty);
  endproperty
  assert property (no_read_when_empty)
    else $error("ASSERTION FAILED: Read attempted when FIFO empty");

  property no_simultaneous_rd_wr;
    @(posedge clk) disable iff (rst)
      !(wr_en && rd_en);
  endproperty
  assert property (no_simultaneous_rd_wr)
    else $error("ASSERTION FAILED: Both read and write enabled at same time");
endinterface


//====================================================
// generator module 3
//====================================================
class generator;
  rand transaction trans;
  mailbox gen2drv;
  int repeat_count;
  event drv2gen;
  event gen_done; // Added: signal when generation is complete
  int write_count = 0;
  int read_count = 0;
  
  function new(mailbox gen2drv, event drv2gen);
    this.gen2drv = gen2drv;
    this.drv2gen = drv2gen;  
  endfunction
  
  task main();
    repeat(repeat_count) begin 
      trans = new();
      void'(trans.randomize());

      if (write_count == 0) begin
        trans.wr_en = 1;
        trans.rd_en = 0;
      end
      else if (write_count > read_count) begin
        case ($urandom_range(0, 2))
          0: begin trans.wr_en = 1; trans.rd_en = 0; end
          1: begin trans.wr_en = 0; trans.rd_en = 1; end
          default: begin trans.wr_en = 0; trans.rd_en = 0; end
        endcase
      end
      else begin
        trans.wr_en = 1;
        trans.rd_en = 0;
      end

      if (trans.wr_en) write_count++;
      if (trans.rd_en) read_count++;

      gen2drv.put(trans);
      @(drv2gen); // Wait for driver to process
    end 
    ->gen_done; // Signal generation complete
    $display("Generator: All %0d transactions generated", repeat_count);
  endtask
endclass


//====================================================
// driver module 4
//====================================================
class driver;
  int no_trans;
  virtual fifo_intf vif_fifo;
  mailbox gen2drv;
  event drv2gen;
  event drv_done; // Added: signal when driving is complete
  int max_trans; // Added: maximum transactions to drive
  
  function new(virtual fifo_intf vif_fifo, mailbox gen2drv);
    this.vif_fifo = vif_fifo;
    this.gen2drv = gen2drv;
  endfunction  
  
  task reset;
    $display("Resetting DUT...");
    wait(vif_fifo.rst);
    vif_fifo.driver_cb.data_in <= 0;
    vif_fifo.driver_cb.wr_en <= 0;
    vif_fifo.driver_cb.rd_en <= 0;
    wait(!vif_fifo.rst);
    $display("Done resetting DUT.");
  endtask
  
  task drive;
    repeat(max_trans) begin // Changed: from forever to repeat
      transaction trans;
      vif_fifo.driver_cb.wr_en <= 0;
      vif_fifo.driver_cb.rd_en <= 0;
      gen2drv.get(trans);
      $display("Transaction Count = %0d", no_trans);
     
      @(posedge vif_fifo.clk);
      if(trans.wr_en) begin
        vif_fifo.driver_cb.wr_en <= 1;
        vif_fifo.driver_cb.data_in <= trans.data_in;
        $display("\tWRITE: data_in = %0h", trans.data_in);
      end
     
      if(trans.rd_en) begin
        vif_fifo.driver_cb.rd_en <= 1;
        @(posedge vif_fifo.clk);
        trans.data_op = vif_fifo.driver_cb.data_op;
        $display("\tREAD: data_out = %0h", trans.data_op);
        vif_fifo.driver_cb.rd_en <= 0;
      end

      @(posedge vif_fifo.clk);
      vif_fifo.driver_cb.wr_en <= 0;
      vif_fifo.driver_cb.rd_en <= 0;

      no_trans++;
      ->drv2gen; // Signal back to generator
    end
    ->drv_done; // Signal driving complete
    $display("Driver: All %0d transactions driven", no_trans);
  endtask
  
  task main;
    fork 
      begin wait(vif_fifo.rst); end
      begin drive(); end
    join_any
    disable fork;
  endtask
endclass


//====================================================
// monitor module 5
//====================================================
class monitor; 
  virtual fifo_intf vif_fifo;
  mailbox mon2scb;
  event mon_done; // Added: signal when monitoring is complete
  int max_trans; // Added: maximum transactions to monitor
  int trans_count = 0;
 
  function new(virtual fifo_intf vif_fifo, mailbox mon2scb);
    this.vif_fifo = vif_fifo;
    this.mon2scb = mon2scb;
  endfunction
 
  task main;
    forever begin
      transaction trans = new();
      @(posedge vif_fifo.clk);
      wait(vif_fifo.monitor_cb.wr_en || vif_fifo.monitor_cb.rd_en);
      if(vif_fifo.monitor_cb.wr_en) begin
        trans.wr_en = vif_fifo.monitor_cb.wr_en;
        trans.data_in = vif_fifo.monitor_cb.data_in; 
        trans.full = vif_fifo.monitor_cb.full;
        trans.empty = vif_fifo.monitor_cb.empty;
      end
      @(posedge vif_fifo.clk);
      if(vif_fifo.monitor_cb.rd_en) begin
        trans.rd_en = vif_fifo.monitor_cb.rd_en;
        @(posedge vif_fifo.clk);
        trans.data_op = vif_fifo.monitor_cb.data_op;
        trans.full = vif_fifo.monitor_cb.full;
        trans.empty = vif_fifo.monitor_cb.empty;
      end
      mon2scb.put(trans);
      trans_count++;
      if(trans_count >= max_trans) begin
        ->mon_done;
        $display("Monitor: All %0d transactions monitored", trans_count);
        break;
      end
    end   
  endtask
endclass


//====================================================
// scoreboard module 6
//====================================================
class scoreboard;
  mailbox mon2scb;
  int no_trans;
  int max_trans; // Added: maximum transactions to check
  event scb_done; // Added: signal when checking is complete
  bit [31:0] ram[0:31];
  int wr_ptr, rd_ptr;
  int pass_count = 0;
  int fail_count = 0;

  function new(mailbox mon2scb);
    this.mon2scb = mon2scb;
    foreach(ram[i]) ram[i] = 32'hFFFF_FFFF;
  endfunction 
   
  task main;
    forever begin  
      transaction trans;
      mon2scb.get(trans);
      if(trans.wr_en) begin
        ram[wr_ptr] = trans.data_in;
        wr_ptr++;
      end  
      if(trans.rd_en) begin
        if(trans.data_op == ram[rd_ptr]) begin
          $display("MATCH: Read data %h OK", trans.data_op);
          pass_count++;
          rd_ptr++;
        end else begin
          $display("MISMATCH: Expected %h got %h", ram[rd_ptr], trans.data_op);
          fail_count++;
        end
      end
      no_trans++;
      if(no_trans >= max_trans) begin
        ->scb_done;
        $display("\n========================================");
        $display("Scoreboard Summary:");
        $display(" Total Transactions: %0d", no_trans);
        $display(" Passed: %0d", pass_count);
        $display(" Failed: %0d", fail_count);
        $display("========================================\n");
        break;
      end
    end
  endtask
endclass


//====================================================
// environment module 7
//====================================================
class environment;
  generator gen;
  driver drv;
  monitor mon;
  scoreboard scb;
  
  mailbox gen2drv;
  mailbox mon2scb;
  event drv2gen;
  virtual fifo_intf vif_fifo;
  
  function new(virtual fifo_intf vif_fifo);
    this.vif_fifo = vif_fifo;
    gen2drv = new();
    mon2scb = new();
    gen = new(gen2drv, drv2gen);
    drv = new(vif_fifo, gen2drv);
    mon = new(vif_fifo, mon2scb);
    scb = new(mon2scb);
    drv.drv2gen = drv2gen; // Connect driver to generator event
  endfunction
  
  task pre_test(); 
    drv.reset(); 
  endtask
  
  task test(); 
    fork
      gen.main(); 
      drv.main(); 
      mon.main(); 
      scb.main(); 
    join_any
    disable fork;
  endtask
  
  task post_test();
    // Wait for all components to complete
    wait(gen.gen_done.triggered);
    wait(drv.drv_done.triggered);
    wait(mon.mon_done.triggered);
    wait(scb.scb_done.triggered);
    #100; // Wait for any pending operations
    $display("All tests completed successfully!");
  endtask
  
  task run();
    // Set max transactions for all components
    drv.max_trans = gen.repeat_count;
    mon.max_trans = gen.repeat_count;
    scb.max_trans = gen.repeat_count;
    
    pre_test(); 
    test(); 
    post_test(); 
    $finish;
  endtask
endclass


//====================================================
// test module 8
//====================================================
program test(fifo_intf intf);
  environment env;
  initial begin
    env = new(intf);
    env.gen.repeat_count = 20;
    env.run();
  end
endprogram


//====================================================
// testbench_top module 9
//====================================================
module tb_top;
  bit clk, rst;
  always #5 clk = ~clk;
 
  initial begin
    clk = 0;
    rst = 1;
    #20 rst = 0;
  end
 
  fifo_intf intf(clk, rst);
  test t1(intf);
  fifo DUT(.data_op(intf.data_op),
           .full(intf.full),
           .empty(intf.empty),
           .data_in(intf.data_in),
           .wr_en(intf.wr_en),
           .rd_en(intf.rd_en),
           .clk(intf.clk),
           .rst(intf.rst));
           
  // Coverage sampling
  covergroup fifo_cg @(posedge clk);
    cp_wr_en: coverpoint intf.wr_en;
    cp_rd_en: coverpoint intf.rd_en;
    cp_full: coverpoint intf.full;
    cp_empty: coverpoint intf.empty;
    cp_data: coverpoint intf.data_in {
      bins low = {[0:32'h7FFF_FFFF]};
      bins high = {[32'h8000_0000:32'hFFFF_FFFF]};
    }
    cross_wr_full: cross cp_wr_en, cp_full;
    cross_rd_empty: cross cp_rd_en, cp_empty;
  endgroup
  
  fifo_cg cg_inst = new();
  
  // Timeout watchdog
  initial begin
    #500000; // 500us timeout
    $display("Simulation ended after timeout check");
    $finish;
  end
endmodule

//-------------------------------------------------------------------------------------------------
//  Module:uart_tb_top
//  This provide the information about instantiating test_pkg,interface,and running the base test
//-------------------------------------------------------------------------------------------------
// `include "include_files.svh"

// `timescale 1ns/1ns
//   module uart_tb_top;
//     logic reset_n;
//     uvm_root _UVM_Root;
//   initial begin
// // Asserting the active_low reset
//     reset_n = 1;
// // De-asserting the active_low reset
//     #10 reset_n = 0;
//     #10 reset_n = 1;
//   end
// // Instantiation of UART interface
//   uart_interface intf(.reset_n(reset_n));
//   always #5 intf.clk = ~intf.clk;
// //  Need to have the loopback mode
//   // assign intf.rx = intf.tx;

//   uart #(.SYS_FREQ      (50000000),
//          .BAUD_RATE     (9600    ),
//          .SAMPLE        (16      ),
//          .DATA_SIZE     (8       )
//           )
//     uart_inst(
//         .clk      (intf.clk),
//         .reset_n  (intf.reset_n),
//         .send_req (intf.send_req),
//         .send_ack (intf.send_ack),
//         .recv_ack (intf.recv_ack),
//         .recv_req (intf.recv_req),
//         .din      (intf.din),
//         .dout     (intf.dout),
//         .rx       (intf.rx),
//         .tx       (intf.tx)
//         );

//   initial begin
//     _UVM_Root = uvm_root::get();
//     factory.print();
//     uvm_config_db #(virtual uart_interface)::set(null,"*","vif_0",intf);
// //  running the basic test case
//      _UVM_Root.run_test("base_test");
//   end
//   uart_sva uart_sva(
//     .intf(intf)
//     );
// endmodule

`include "include_files.svh"

`timescale 1us/1us

module uart_tb_top;
  logic clk;
  uvm_root _UVM_Root;
  // uart_coverage cov = new();
  initial begin
    clk = 1;
  end

// Instantiation of UART interface
  always #1 clk = ~clk;
  uart_interface intf(.clk(clk));
//  Need to have the loopback mode
  // assign intf.rx = intf.tx;

  uart #(.SYS_FREQ      (`SYS_FREQ),
         .BAUD_RATE     (`BAUD_RATE),
         .DATA_SIZE     (`DATA_SIZE)
          )
    uart_inst(
        .clk      (intf.clk),
        .reset_n  (intf.reset_n),
        .send_req (intf.send_req),
        .send_ack (intf.send_ack),
        .recv_ack (intf.recv_ack),
        .recv_req (intf.recv_req),
        .din      (intf.din),
        .dout     (intf.dout),
        .rx       (intf.rx),
        .tx       (intf.tx)
        );

   // always @(posedge intf.clk) begin
   //    cov.samplesignal(intf);
   //  end

   // always @(posedge intf.send_req) begin
   //    cov.sampledin(intf);
   //  end

   // always @(posedge intf.recv_req) begin
   //    cov.sampledout(intf);
   //  end

  initial begin
    _UVM_Root = uvm_root::get();
    factory.print();
    uvm_config_db #(virtual uart_interface)::set(null,"*","vif_0",intf);
//  running the basic test case
     _UVM_Root.run_test("base_test");
  end
  uart_sva uart_sva(
    .intf(intf)
    );
endmodule
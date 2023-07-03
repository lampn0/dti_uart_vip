module uart 
#(
  parameter SYS_FREQ        = 50000000                   ,
  parameter BAUD_RATE       = 9600                       ,
  parameter SAMPLE          = 16                         ,
  parameter CLOCK           = SYS_FREQ/(BAUD_RATE)       ,
  parameter BAUD_DV         = SYS_FREQ/(SAMPLE*BAUD_RATE),
  parameter DATA_SIZE       = 8,
  parameter BIT_COUNT_SIZE  = $clog2(DATA_SIZE+1)
)(
  input                  clk     ,    // Clock
  input                  reset_n ,  // Asynchronous reset active low
  input                  send_req,
  output                 send_ack,
  input                  recv_ack,
  output                 recv_req,
  input  [DATA_SIZE-1:0] din     ,
  output [DATA_SIZE-1:0] dout    ,
  input                  rx      ,
  output                 tx       
);

wire en, en_sample;


uart_transmitter #(
  .SYS_FREQ       (SYS_FREQ      ),
  .BAUD_RATE      (BAUD_RATE     ),
  .SAMPLE         (SAMPLE        ),
  .CLOCK          (CLOCK         ),
  .BAUD_DV        (BAUD_DV       ),
  .DATA_SIZE      (DATA_SIZE     ),
  .BIT_COUNT_SIZE (BIT_COUNT_SIZE)
) uart_transmitter (
  .clk     (clk     ),
  .reset_n (reset_n ),
  .din     (din     ),
  .tx      (tx      ),
  .send_req(send_req),
  .send_ack(send_ack)
);

uart_receiver #(
  .SYS_FREQ       (SYS_FREQ      ),
  .BAUD_RATE      (BAUD_RATE     ),
  .SAMPLE         (SAMPLE        ),
  .CLOCK          (CLOCK         ),
  .BAUD_DV        (BAUD_DV       ),
  .DATA_SIZE      (DATA_SIZE     ),
  .BIT_COUNT_SIZE (BIT_COUNT_SIZE)
) uart_receiver (
  .clk      (clk      ),
  .reset_n  (reset_n  ),
  .rx       (rx       ),
  .dout     (dout     ),
  .recv_req (recv_req ),
  .recv_ack (recv_ack )
);



endmodule
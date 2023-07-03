module uart_receiver
#(
  parameter SYS_FREQ        = 50000000                   ,
  parameter BAUD_RATE       = 9600                       ,
  parameter SAMPLE          = 16                         ,
  parameter CLOCK           = SYS_FREQ/(BAUD_RATE)       ,
  parameter BAUD_DV         = SYS_FREQ/(SAMPLE*BAUD_RATE),
  parameter DATA_SIZE       = 8                          ,
  parameter BIT_COUNT_SIZE  = $clog2(DATA_SIZE+1)        
)(
  input                      clk        ,    // Clock
  input                      reset_n    ,  // Asynchronous reset active low
  input                      rx         ,
  output reg [DATA_SIZE-1:0] dout       ,
  output reg                 recv_req   ,
  input                      recv_ack   
);

// -------------------------------------------------------------
// Signal Declaration
// -------------------------------------------------------------
reg [SAMPLE-1           : 0]  check_start       ; //

reg [BIT_COUNT_SIZE - 1 : 0]  bit_count         ; // 
reg                           bit_count_done    ; // 
reg                           load_rx_shift_reg ; // 
reg                           clear             ; // 
wire                          start             ;

reg [$clog2(CLOCK  ) - 1 : 0] count_clk;
reg [$clog2(BAUD_DV) - 1 : 0] count_sample_clk;


// -------------------------------------------------------------
// State Encoding
// -------------------------------------------------------------
localparam IDLE      = 2'b00,
           RECEIVING = 2'b01,
           WAIT_ACK  = 2'b10;

reg [1:0] state, next_state;

// -------------------------------------------------------------
// Data out
// -------------------------------------------------------------
always @(posedge clk or negedge reset_n) begin : proc_dout
  if(~reset_n) begin
    dout <= 0;
  end else if ((state == RECEIVING) & (count_clk == (CLOCK - 1)) & (bit_count != DATA_SIZE)) begin
    dout <= {rx, dout[DATA_SIZE-1:1]};
  end
end



// -------------------------------------------------------------
// Counter
// -------------------------------------------------------------
always @(posedge clk or negedge reset_n) begin
  if(~reset_n) begin
    count_sample_clk <= 0;
  end else if (state == IDLE) begin
    count_sample_clk <= (count_sample_clk == (BAUD_DV - 1) ? 0 : (count_sample_clk + 1));
  end
  else begin 
    count_sample_clk <= 0;
  end
end

always @(posedge clk or negedge reset_n) begin
  if(~reset_n) begin
    count_clk <= 0;
  end else begin
    if (state == IDLE | state == WAIT_ACK) begin
      count_clk <= 0;
    end
    else begin 
      count_clk <= (count_clk == (CLOCK - 1) ? 0 : (count_clk + 1));
    end
  end
end

always @(posedge clk or negedge reset_n) begin : proc_check_start
  if(~reset_n) begin
    check_start <= '1;
  end else if ((state == IDLE) & (count_sample_clk == (BAUD_DV - 1))) begin
    check_start <= {rx, check_start[SAMPLE-1 : 1]};
  end
  else if (state == RECEIVING | state == WAIT_ACK) begin 
    check_start <= '1;
  end
end

assign start = (~(|check_start[SAMPLE-1 : SAMPLE/2])) & (&check_start[SAMPLE/2-1 : 0]);



always @(posedge clk or negedge reset_n) begin : proc_counter
  if(~reset_n) begin
    bit_count <= 0;
  end
  else if (state == RECEIVING) begin
    if(count_clk == (CLOCK - 1)) begin
      bit_count <= bit_count + 1'b1;
    end
    else if (clear) begin
      bit_count <= 0;
    end
    else begin
      bit_count <= bit_count;
    end
  end
  else begin 
    bit_count <= 0;
  end
end

always @(*) begin : proc_count_done
  bit_count_done = (bit_count == (DATA_SIZE + 1));
end


// -------------------------------------------------------------
// FSM
// -------------------------------------------------------------
always @(posedge clk or negedge reset_n) begin : proc_state
  if(~reset_n) begin
    state <= IDLE;
  end
  else begin
    state <= next_state;
  end
end




// -------------------------------------------------------------
// FSM ouput signal
// -------------------------------------------------------------
always @(*) begin : proc_output_fsm
  load_rx_shift_reg = 0;
  clear = 0;
  recv_req = 0;
  case (state)
    IDLE: begin
      if (start) begin
        next_state = RECEIVING;
      end
    end
    RECEIVING: begin
      if (bit_count_done) begin
        clear = 1;
        next_state = WAIT_ACK;
      end
      else begin
        next_state = RECEIVING;
      end
    end
    WAIT_ACK: begin
      recv_req = 1;

      if (recv_ack) begin
        recv_req = 0;
        next_state = IDLE;
      end
      else begin 
        next_state = WAIT_ACK;
      end
    end
    default : next_state = IDLE;
  endcase
end




endmodule
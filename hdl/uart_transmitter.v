module uart_transmitter
#(
  parameter SYS_FREQ        = 50000000                   ,
  parameter BAUD_RATE       = 9600                       ,
  parameter SAMPLE          = 16                         ,
  parameter CLOCK           = SYS_FREQ/(BAUD_RATE)       ,
  parameter BAUD_DV         = SYS_FREQ/(SAMPLE*BAUD_RATE),
  parameter DATA_SIZE       = 8,
  parameter BIT_COUNT_SIZE  = $clog2(DATA_SIZE+1)
)(
  input                      clk     ,    // Clock
  input                      reset_n ,  // Asynchronous reset active low
  input      [DATA_SIZE-1:0] din     ,
  output                     tx      ,
  input                      send_req,
  output reg                 send_ack
);

// -------------------------------------------------------------
// Signal Declaration
// -------------------------------------------------------------
reg [DATA_SIZE      + 1 : 0]  tx_shift_reg      ; // 
reg [BIT_COUNT_SIZE - 1 : 0]  bit_count         ; // 
reg                           bit_count_done    ; // 
reg                           load_tx_shift_reg ; // 
reg                           shift             ; // 
reg                           clear             ; // 


// -------------------------------------------------------------
// State Encoding
// -------------------------------------------------------------
localparam IDLE    = 2'b00,
           SENDING = 2'b01;

reg [1:0] state, next_state;


assign tx = tx_shift_reg[0];


// -------------------------------------------------------------
// Clock
// -------------------------------------------------------------
reg [$clog2(CLOCK  ) - 1 : 0] count_clk;

always @(posedge clk or negedge reset_n) begin
  if(~reset_n) begin
    count_clk <= 0;
  end else begin
    if (state == IDLE) begin
      count_clk <= 0;
    end
    else begin 
      count_clk <= (count_clk == (CLOCK - 1) ? 0 : (count_clk + 1));
    end
  end
end


// -------------------------------------------------------------
// FSM
// -------------------------------------------------------------
always @(posedge clk or negedge reset_n) begin 
  if(~reset_n) begin
    state <= IDLE;
  end
  // else if (en) begin
  else begin
    state <= next_state;
  end
end




// -------------------------------------------------------------
// FSM ouput signal
// -------------------------------------------------------------
always @(*)  begin
  load_tx_shift_reg = 0;
  shift = 0;
  clear = 0;
  // next_state = state;

  case (state)
    IDLE: begin
      if (send_req) begin
        load_tx_shift_reg = 1;
        next_state = SENDING;
      end
      else begin 
        next_state = IDLE;
      end
    end

    SENDING: begin
      if (count_clk == (CLOCK - 1)) begin
        if (bit_count_done) begin
          clear = 1;
          // shift = 0;
          next_state = IDLE;
        end
        else begin
          shift = 1;
          // clear = 0;
          next_state = SENDING;
        end
      end
      else begin 
        next_state = SENDING;
      end
    end

    default : next_state = IDLE;
  endcase
end


// -------------------------------------------------------------
// Counter
// -------------------------------------------------------------
always @(posedge clk or negedge reset_n) begin 
  if(~reset_n) begin
    bit_count <= 0;
  end
  // else if (en) begin
  else begin
    if(shift) begin
      bit_count <= bit_count + 1'b1;
    end
    else if (clear) begin
      bit_count <= 0;
    end
    else begin
      bit_count <= bit_count;
    end
  end
end

always @(*) begin : proc_count_done
  bit_count_done = (bit_count == (DATA_SIZE + 2));
end

// assign send_ack = bit_count_done;

always @(posedge clk or negedge reset_n) begin
  if(~reset_n) begin
    send_ack <= 0;
  end else begin
    send_ack <= ((bit_count == (DATA_SIZE + 2)) & (count_clk == (CLOCK - 1))) ? 1'b1 : 1'b0;
  end
end

// -------------------------------------------------------------
// TX Shift Register
// -------------------------------------------------------------
always @(posedge clk or negedge reset_n) begin 
  if(~reset_n) begin
    tx_shift_reg <= {(DATA_SIZE+2){1'b1}};
  end
  // else if (en) begin
  else begin
    if(load_tx_shift_reg) begin
      tx_shift_reg <= {1'b1, din,1'b0};  end
    else if (shift) begin
      tx_shift_reg <= {1'b1,tx_shift_reg[DATA_SIZE:1]};
    end
    else begin
      tx_shift_reg <= tx_shift_reg;
    end
  end
end



endmodule

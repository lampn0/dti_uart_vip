/*
 *-----------------------------------------------------------------------------
 *     Copyright (C) 2022 by Dolphin Technology
 *     All right reserved.
 *
 *     Copyright Notification
 *     No part may be reproduced except as authorized by written permission.
 *
 *     Module/Class: uart_interface
 *     Project     : Verification Traning
 *     Author      : haint1
 *     Created     : 2022-10-01 11:04:18
 *     Description :
 *
 *     @Last Modified by:   
 *     @Last Modified time:
 *-----------------------------------------------------------------------------
 */
interface uart_interface
#(
  parameter SYS_FREQ        = `SYS_FREQ  ,
  parameter BAUD_RATE       = `BAUD_RATE ,
  parameter DATA_SIZE       = `DATA_SIZE 
)
  (input clk);
  logic reset_n;
  logic tx;
  logic rx;
  // logic en;
  // logic en_sample;
  logic [DATA_SIZE-1:0] din;
  logic [DATA_SIZE-1:0] dout;
  logic [DATA_SIZE-1:0] rx_sample;
  logic [DATA_SIZE-1:0] frame_tx;
  logic send_req;
  logic send_ack;
  logic recv_req;
  logic recv_ack;
  int bit_time = ((SYS_FREQ/BAUD_RATE)/2);
endinterface








/*
 *-----------------------------------------------------------------------------
 *     Copyright (C) 2022 by Dolphin Technology
 *     All right reserved.
 *
 *     Copyright Notification
 *     No part may be reproduced except as authorized by written permission.
 *
 *     Module/Class: uart_receiver_sequence
 *     Project     : Verification Traning
 *     Author      : haint1
 *     Created     : 2022-10-01 11:04:18
 *     Description :
 *
 *     @Last Modified by:   
 *     @Last Modified time:
 *-----------------------------------------------------------------------------
 */
//------------------------------------------------------------------------------------------------//
//  Class: uart_receiver_sequence
//  uart_receiver_sequence is extended from uvm_sequence. The uvm_sequence class provides the interfaces
//  necessary in order to create streams of sequence items and/or other sequences.
//------------------------------------------------------------------------------------------------//
class uart_receiver_sequence extends uvm_sequence #(uart_receiver_sequence_item);

//------------------------------------------------------------------------------------------------//
//  Factory registration is done by passing class name as argument.
//  Factory Method in UVM enables us to register a class, object and variables inside the factory 
//  so that we can override their type (if needed) from the test bench without needing to make any
//  significant change in component structure.
//------------------------------------------------------------------------------------------------//
  `uvm_object_utils(uart_receiver_sequence)
//  Creating handle for master transaction
    uart_receiver_sequence_item req;
//------------------------------------------------------------------------------------------------//
//  The extern qualifier indicates that the body of the method (its implementation) is to be found 
//  outside the declaration.
//------------------------------------------------------------------------------------------------//
  extern function new(string name="uart_receiver_sequence");
  extern task body();
endclass:uart_receiver_sequence 

//----------------------------------------New_Constructor-----------------------------------------//
//  The new function is called as class constructor. On calling the new method it allocates the 
//  memory and returns the address to the class handle.
//------------------------------------------------------------------------------------------------//
  function uart_receiver_sequence::new(string name="uart_receiver_sequence");
    super.new(name);
  endfunction:new

//-----------------------------------------------------------------------------------------------
//  Task:body
//  This gives the information about the starting of driver sequencer handshake mechanism
//-----------------------------------------------------------------------------------------------
  task uart_receiver_sequence::body();
    req = uart_receiver_sequence_item::type_id::create("req");
    `uvm_do_with(req, { rx_sample == 8'b10110110; act == RESET; })
    `uvm_do_with(req, { rx_sample == 8'b01010101; act == NORMAL; })
    `uvm_do_with(req, { rx_sample == 8'b01001001; act == NORMAL; })
    // `uvm_do_with(req, { rx_sample == 8'b11111111; act == NORMAL; })
    // `uvm_do_with(req, { recv_ack == 0; rx_sample == 8'b11110000; act == RESET; })
    // repeat(10) begin
    //   req = uart_receiver_sequence_item::type_id::create("req");
    //   start_item(req);
    //   assert(req.randomize());
    //   finish_item(req);
    //   end
    // for(int i = 5; i < 256; i += 16) begin
    //   `uvm_do_with(req, { rx_sample == i; act == NORMAL; })
    // end
endtask
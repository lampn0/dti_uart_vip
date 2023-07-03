/*
 *-----------------------------------------------------------------------------
 *     Copyright (C) 2022 by Dolphin Technology
 *     All right reserved.
 *
 *     Copyright Notification
 *     No part may be reproduced except as authorized by written permission.
 *
 *     Module/Class: uart_transmitter_sequence
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
//  Class: uart_transmitter_sequence
//  uart_transmitter_sequence is extended from uvm_sequence. The uvm_sequence class provides the interfaces
//  necessary in order to create streams of sequence items and/or other sequences.
//------------------------------------------------------------------------------------------------//
class uart_transmitter_sequence extends uvm_sequence #(uart_transmitter_sequence_item);

//  Factory Method in UVM enables us to register a class, object and variables inside the factory 
  `uvm_object_utils(uart_transmitter_sequence)
//  Creating handle for master transaction
    uart_transmitter_sequence_item req;
//  The extern qualifier indicates that its implementation is to be found outside the declaration.
  extern function new(string name="uart_transmitter_sequence");
  extern task body();
endclass:uart_transmitter_sequence 

//-----------------------------------------------------------------------------------------------//
//  constructor:new
//  The new function is called as class constructor. On calling the new method it allocates the 
//  memory and returns the address to the class handle.
//------------------------------------------------------------------------------------------------//
  function uart_transmitter_sequence::new(string name="uart_transmitter_sequence");
    super.new(name);
  endfunction:new
//-----------------------------------------------------------------------------------------------
//  Task:body
//  This gives the information about the starting of driver sequencer handshake mechanism
//-----------------------------------------------------------------------------------------------
  task uart_transmitter_sequence::body();
    req = uart_transmitter_sequence_item::type_id::create("req");
    `uvm_do_with(req, {send_req == 1; act == RESET; din == 8'b11001100;})
    `uvm_do_with(req, {send_req == 1; din == 8'b11001101; })
    #5;
    `uvm_do_with(req, {send_req == 1; din == 8'b11000011; })
    // `uvm_do_with(req, {send_req == 1; din == 8'b01010101; })
    // `uvm_do_with(req, {send_req == 1; din == 8'b00000000; })
    // `uvm_do_with(req, {send_req == 1; din == 8'b10000001; })
    // `uvm_do_with(req, {send_req == 1; din == 8'b10011001; })
    // `uvm_do_with(req, {send_req == 0; act == RESET; })
    // repeat(10) begin
    //   req = uart_transmitter_sequence_item::type_id::create("req");
    //   start_item(req);
    //   assert(req.randomize());
    //   finish_item(req);
    //   end
    // for(int i = 5; i < 256; i += 16) begin
    //   `uvm_do_with(req, { din == i; act == NORMAL; })
    // end
endtask



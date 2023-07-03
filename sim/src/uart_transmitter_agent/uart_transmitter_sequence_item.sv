/*
 *-----------------------------------------------------------------------------
 *     Copyright (C) 2022 by Dolphin Technology
 *     All right reserved.
 *
 *     Copyright Notification
 *     No part may be reproduced except as authorized by written permission.
 *
 *     Module/Class: uart_transmitter_sequence_item
 *     Project     : Verification Traning
 *     Author      : haint1
 *     Created     : 2022-10-01 11:04:18
 *     Description :
 *
 *     @Last Modified by:   
 *     @Last Modified time:
 *-----------------------------------------------------------------------------
 */

//-------------------------------------------------------------------------------------------------
//  Class:uart_transmitter_sequence_item
//  This class provide information about the sequences that are present
//-------------------------------------------------------------------------------------------------
class uart_transmitter_sequence_item extends uvm_sequence_item;
  //---------------------------------------
  //Action
  //---------------------------------------
  typedef enum { RESET = 0, NORMAL = 1} action;

    rand action                   act           ;
    rand bit                      reset_n       ;
    rand bit [7:0]                din           ;
         bit                      tx            ;
    rand bit                      send_req      ;
         bit                      send_ack      ;
         bit [7:0]                frame_tx      ;
//------------------------------------------------------------------------------------------------
//  Factory registration is done by passing class name as argument.
//  Factory Method in UVM enables us to register a class, object and variables inside the factory 
//  so that we can override their type (if needed) from the test bench without needing to make any
//  significant change in component structure.
//  Factory Method in UVM enables us to register a class, object and variables inside the factory
//-------------------------------------------------------------------------------------------------
  `uvm_object_utils_begin(uart_transmitter_sequence_item)
    `uvm_field_int(reset_n          ,UVM_ALL_ON)
    `uvm_field_int(din              ,UVM_ALL_ON)
    `uvm_field_int(tx               ,UVM_ALL_ON)
    `uvm_field_int(send_req         ,UVM_ALL_ON)
    `uvm_field_int(send_ack         ,UVM_ALL_ON)
    `uvm_field_int(frame_tx         ,UVM_ALL_ON)
    `uvm_field_enum(action, act     ,UVM_ALL_ON | UVM_PRINT)
  `uvm_object_utils_end
  // ---------------------------------------
  // Constraints of signals
  // ---------------------------------------
  constraint reset_n_c      {(act == RESET)   -> (reset_n == 0); }
  constraint normal_c       {(act == NORMAL)  -> (reset_n == 1); }
  constraint act_c          { soft act == NORMAL; }
  // constraint ratio          {act dist {RESET := 2,NORMAL := 10}; }

//---------------------------------------------------------------------------------------------
//  Defining external tasks and functions
//---------------------------------------------------------------------------------------------
  extern function new(string name = "uart_transmitter_sequence_item");
//  extern function void do_print(uvm_printer printer);
endclass:uart_transmitter_sequence_item

//------------------------------------------------------------------------------------------------
//  new:constructor
//  The new function is called as class constructor. On calling the new method it allocates the 
//  memory and returns the address to the class handle. For the component class two arguments to be 
//  passed.
//-----------------------------------------------------------------------------------------------
  function uart_transmitter_sequence_item::new(string name="uart_transmitter_sequence_item");
    super.new(name);
  endfunction

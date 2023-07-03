/*
 *-----------------------------------------------------------------------------
 *     Copyright (C) 2022 by Dolphin Technology
 *     All right reserved.
 *
 *     Copyright Notification
 *     No part may be reproduced except as authorized by written permission.
 *
 *     Module/Class: uart_transmitter_sequencer
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
//  Class: uart_transmitter_sequencer
//  uart_transmitter_sequencer is extended from uvm_sequencer. The sequencer controls the flow of request and
//  response sequence items between sequences and the driver. Sequencer and driver uses TLM 
//  Interface to communicate transactions. uvm_sequencer and uvm_driver base classes have 
//  seq_item_export and seq_item_port defined respectively. User needs to connect them using TLM 
//  connect method.
//------------------------------------------------------------------------------------------------//
class uart_transmitter_sequencer extends uvm_sequencer #(uart_transmitter_sequence_item);

  virtual uart_interface vif;
  uart_transmitter_config w_cfg;

//  Factory Method in UVM enables us to register a class, object and variables inside the factory 
  `uvm_component_utils(uart_transmitter_sequencer)

  extern           function new(string name="uart_transmitter_sequencer", uvm_component parent);
  extern           virtual function void connect_phase(uvm_phase phase);
endclass:uart_transmitter_sequencer

//-----------------------------------------------------------------------------------------------//
//  constructor:new
//  The new function is called as class constructor. On calling the new method it allocates the 
//  memory and returns the address to the class handle.
//------------------------------------------------------------------------------------------------//
  function uart_transmitter_sequencer::new(string name = "uart_transmitter_sequencer", uvm_component parent);
    super.new(name, parent);
  endfunction:new

  function void uart_transmitter_sequencer::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    this.vif = w_cfg.vif;
  endfunction

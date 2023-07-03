/*
 *-----------------------------------------------------------------------------
 *     Copyright (C) 2022 by Dolphin Technology
 *     All right reserved.
 *
 *     Copyright Notification
 *     No part may be reproduced except as authorized by written permission.
 *
 *     Module/Class: uart_transmitter_monitor
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
//  Class: uart_transmitter_monitor
//  The user-defined monitor is extended from uvm_monitor, uvm_monitor is inherited by uvm_component.
//  A monitor is a passive entity that samples the DUT signals through the virtual interface and 
//  converts the signal level activity to the transaction level. Monitor samples DUT signals but 
//  does not drive them.
//------------------------------------------------------------------------------------------------//
class uart_transmitter_monitor extends uvm_monitor;

//  Factory Method in UVM enables us to register a class, object and variables inside the factory 
    `uvm_component_utils(uart_transmitter_monitor)

//  Virtual interface holds the pointer to the Interface.  
  virtual uart_interface vif;

//  w_cfg is the handle of uart_transmitter_config which is extended from the configuration class
  uart_transmitter_config w_cfg;
  uart_transmitter_driver m_drv;
  uart_transmitter_sequence_item data_sent;
//  TLM Port:uvm_analysis port consisting of inbuilt write method
  uvm_analysis_port #(uart_transmitter_sequence_item) monitor_port;

//------------------------------------------------------------------------------------------------//
//  The extern qualifier indicates that the body of the method (its implementation) is to be found 
//  outside the declaration.
//------------------------------------------------------------------------------------------------//
  extern function new(string name = "uart_transmitter_monitor", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase (uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern task collect_data();
endclass:uart_transmitter_monitor

//------------------------------------------------------------------------------------------------//
//  Constructor:new
//  The new function is called as class constructor. On calling the new method it allocates the 
//  memory and returns the address to the class handle. For the component class two arguments to be 
//  passed. 
//------------------------------------------------------------------------------------------------//
  function uart_transmitter_monitor :: new(string name ="uart_transmitter_monitor",uvm_component parent);
      super.new(name, parent);
    monitor_port = new("monitor_port", this);
  endfunction:new

//-----------------------------------------------------------------------------------------------//
//  Phase:build
//  The build phases are executed at the start of the UVM Testbench simulation and their overall 
//  purpose is to construct, configure and connect the Testbench component hierarchy.
//  All the build phase methods are functions and therefore execute in zero simulation time.  
//------------------------------------------------------------------------------------------------//
  function void uart_transmitter_monitor::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db #(uart_transmitter_config)::get(this,"","uart_transmitter_config",w_cfg))
    `uvm_fatal("CONFIG","Cannot get() w_cfg from uvm_config_db. Have you set() it?")
  endfunction:build_phase

//------------------------------------------------------------------------------------------------//
//  phase:connect
//  The connect phase is used to make TLM connections between components or to assign handles to 
//  testbench resources. It has to occur after the build method so that Testbench component 
//  hierarchy could be in place and it works from the bottom-up of the hierarchy upwards.
//------------------------------------------------------------------------------------------------//
  function void uart_transmitter_monitor::connect_phase(uvm_phase phase);
     vif = w_cfg.vif;
  endfunction:connect_phase

//-----------------------------------------------------------------------------------------------//
//  Phase:run
//  The run phase is used for the stimulus generation and checking activities of the Testbench. 
//  The run phase is implemented as a task, and all uvm_component run tasks are executed in parallel.
//------------------------------------------------------------------------------------------------//
  task uart_transmitter_monitor::run_phase(uvm_phase phase);
    collect_data();
  endtask:run_phase

//-------------------------------------------------------------------------------------------------------------------//
//  Task: collect_data
//  Collect_data will collect the data from the interface and converts it to class uart_transmitter_sequence_item type
//  which will be used by the sva and coverage
//-------------------------------------------------------------------------------------------------------------------//
  task uart_transmitter_monitor::collect_data();
    data_sent = uart_transmitter_sequence_item::type_id::create("data_sent");
    forever begin
      wait (vif.reset_n === 1'b1 && vif.send_req === 1'b1)
      @(posedge vif.clk);
      `uvm_info("TRANSMITTER_MONITOR", "COLLECT DATA", UVM_LOW);
      data_sent.reset_n   = vif.reset_n           ;
      data_sent.din       = vif.din               ;
      data_sent.send_req  = vif.send_req          ;
      data_sent.send_ack  = vif.send_ack          ;
      repeat(vif.bit_time*3) @(posedge vif.clk)  ;
      // `uvm_info("TRANSMITTER_MONITOR", "CAPTURE BIT 0", UVM_LOW);
      for(int i = 0; i < 8; i++) begin
        data_sent.tx          = vif.tx            ; // compare 1 bit
        data_sent.frame_tx[i] = vif.tx            ; // compare pattern
      // `uvm_info("TRANSMITTER_MONITOR", $sformatf("vif.tx = %0b", vif.tx), UVM_LOW);
      // `uvm_info("TRANSMITTER_MONITOR", $sformatf("frame_tx[%0d] = %0b", i, data_sent.frame_tx[i]), UVM_LOW);
        repeat(vif.bit_time*2)@(posedge vif.clk);
      end
      `uvm_info("TRANSMITTER_MONITOR", "SEND DATA TO SVA", UVM_LOW);
      `uvm_info("TRANSMITTER_MONITOR", $sformatf("frame_tx = %8b", data_sent.frame_tx), UVM_LOW);
        vif.frame_tx = data_sent.frame_tx;
      monitor_port.write(data_sent)               ;
    end
  endtask:collect_data
/*
 *-----------------------------------------------------------------------------
 *     Copyright (C) 2022 by Dolphin Technology
 *     All right reserved.
 *
 *     Copyright Notification
 *     No part may be reproduced except as authorized by written permission.
 *
 *     Module/Class: uart_receiver_monitor
 *     Project     : Verification Traning
 *     Author      : haint1
 *     Created     : 2022-10-01 11:04:18
 *     Description :
 *
 *     @Last Modified by:   
 *     @Last Modified time:
 *-----------------------------------------------------------------------------
 */
//  Class: uart_receiver_monitor
//  The user-defined monitor is extended from uvm_monitor, uvm_monitor is inherited by uvm_component.
//  A monitor is a passive entity that samples the DUT signals through the virtual interface and 
//  converts the signal level activity to the transaction level. Monitor samples DUT signals but does
//  not drive them.
//-------------------------------------------------------------------------------------------------
class uart_receiver_monitor extends uvm_monitor;

//----------------------------------------------------------------------------------------------
//  Factory registration is done by passing class name as argument.
//  Factory Method in UVM enables us to register a class, object and variables inside the factory 
//  so that we can override their type (if needed) from the test bench without needing to make any
//  significant change in component structure.
//-----------------------------------------------------------------------------------------------
  `uvm_component_utils(uart_receiver_monitor)
  //-----------------------------------------------------------------------------------------------
  //Virtual interface holds the pointer to the Interface.  
  //s_cfg is the handle of uart_receiver_config which is extended from the configuration class    
  //-----------------------------------------------------------------------------------------------  
  virtual uart_interface vif;
  uart_receiver_config s_cfg;
  uart_receiver_driver s_drv;
  uart_receiver_sequence_item data_recv;

  //  The uvm_analysis_port is a specialized TLM based class whose interface consists of a single 
  //  function write ().
  uvm_analysis_port #(uart_receiver_sequence_item) monitor_port;

//-----------------------------------------------------------------------------------------------
//  Defining external tasks and functions
//-----------------------------------------------------------------------------------------------
  extern function new(string name = "uart_receiver_monitor", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase (uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern task collect_data();
endclass: uart_receiver_monitor

//-------------------------------------------------------------------------------------------------
//  Constructor:new
//  The new function is called as class constructor. On calling the new method it allocates the 
//  memory and returns the address to the class handle. For the component class two arguments to be 
//  passed. 
//-----------------------------------------------------------------------------------------------
  function uart_receiver_monitor :: new(string name ="uart_receiver_monitor",uvm_component parent);
    super.new(name, parent);
    monitor_port = new("monitor_port", this);
  endfunction:new

//------------------------------------------------------------------------------------------------
//  Phase:build
//  The build phases are executed at the start of the UVM Testbench simulation and their overall 
//  purpose is to construct, configure and connect the Testbench component hierarchy.
//  All the build phase methods are functions and therefore execute in zero simulation time.
  //-----------------------------------------------------------------------------------------------
  function void uart_receiver_monitor::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db #(uart_receiver_config)::get(this,"","uart_receiver_config",s_cfg))
    `uvm_fatal("CONFIG","Cannot get() s_cfg from uvm_config_db. Have you set() it?")
  endfunction:build_phase

//------------------------------------------------------------------------------------------------
//  Phase:connect
//  The connect phase is used to make TLM connections between components or to assign handles to 
//  testbench resources. It has to occur after the build method so that Testbench component 
//  hierarchy could be in place and it works from the bottom-up of the hierarchy upwards.
//-----------------------------------------------------------------------------------------------
  function void uart_receiver_monitor::connect_phase(uvm_phase phase);
     vif = s_cfg.vif;
  endfunction:connect_phase

//------------------------------------------------------------------------------------------------
//  Phase:run
//  The run phase is used for the stimulus generation and checking activities of the Testbench. 
//  The run phase is implemented as a task, and all uvm_component run tasks are executed in parallel.
//-------------------------------------------------------------------------------------------------
  task uart_receiver_monitor::run_phase(uvm_phase phase);
    forever begin
      collect_data();
    end 
  endtask: run_phase

//------------------------------------------------------------------------------------------------ 
//collect_phase
//The collect phase is used to collect the data comming from dut
//-------------------------------------------------------------------------------------------------
  task uart_receiver_monitor::collect_data();
    forever begin
    data_recv = uart_receiver_sequence_item::type_id::create("data_recv");
    @(negedge vif.clk);
      if(!vif.reset_n) begin
        data_recv.reset_n    <= vif.reset_n         ;
        data_recv.rx         <= vif.rx              ;
        data_recv.recv_req   <= vif.recv_req        ;
        data_recv.recv_ack   <= vif.recv_ack        ;
        repeat((vif.bit_time)/2)@(posedge vif.clk);
        for (int i = 0; i < 8; i++) begin
          data_recv.dout[i]  <= vif.rx              ;
          repeat(vif.bit_time)@(posedge vif.clk);
        end
        monitor_port.write(data_recv);
      end
    end
  endtask:collect_data 


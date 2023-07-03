/*
 *-----------------------------------------------------------------------------
 *     Copyright (C) 2022 by Dolphin Technology
 *     All right reserved.
 *
 *     Copyright Notification
 *     No part may be reproduced except as authorized by written permission.
 *
 *     Module/Class: uart_receiver_driver
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
//  Class:uart_receiver_driver
//  A driver is written by extending the uvm_driver.uvm_driver is inherited from uvm_component, 
//  Methods and TLM port (seq_item_port) are defined for communication between sequencer and driver.
//  The uvm_driver is a parameterized class and it is parameterized with the type of the request
//  sequence_item and the type of the response sequence_item.
//-------------------------------------------------------------------------------------------------
class uart_receiver_driver extends uvm_driver #(uart_receiver_sequence_item);

//  Factory Method in UVM enables us to register a class, object and variables inside the factory 
  `uvm_component_utils(uart_receiver_driver)

//  Virtual interface holds the pointer to the Interface.
  virtual uart_interface vif;
  uart_receiver_config s_cfg;

//------------------------------------------------------------------------------------------
//  Defining external tasks and functions
//------------------------------------------------------------------------------------------
  extern function new (string name="uart_receiver_driver", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);  
  extern task drive_data(uart_receiver_sequence_item req);
endclass:uart_receiver_driver

//-------------------------------------------------------------------------------------------------
//  Constructor:new
//  The new function is called as class constructor. On calling the new method it allocates the 
//  memory and returns the address to the class handle. For the component class two arguments to be 
//  passed. 
//-----------------------------------------------------------------------------------------------
  function uart_receiver_driver::new(string name = "uart_receiver_driver", uvm_component parent);
    super.new(name, parent);
  endfunction:new

//-------------------------------------------------------------------------------------------------
//  Phase:build
//  The build phases are executed at the start of the UVM Testbench simulation and their overall 
//  purpose is to construct, configure and connect the Testbench component hierarchy.
//  All the build phase methods are functions and therefore execute in zero simulation time.
//-----------------------------------------------------------------------------------------------
  function void uart_receiver_driver::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db #(uart_receiver_config)::get(this,"","uart_receiver_config",s_cfg))
      `uvm_fatal("CONFIG","Cannot get() s_cfg from uvm_config_db. Have you set() it?")
  endfunction:build_phase

//-----------------------------------------------------------------------------------------------
//  Phase:connect
//  The connect phase is used to make TLM connections between components or to assign handles to 
//  testbench resources. It has to occur after the build method so that Testbench component 
//  hierarchy could be in place and it works from the bottom-up of the hierarchy upwards.
//-----------------------------------------------------------------------------------------------
  function void uart_receiver_driver::connect_phase(uvm_phase phase);
    vif = s_cfg.vif;
  endfunction:connect_phase

//------------------------------------------------------------------------------------------------
//  Task:run
//  The run phase is used for the stimulus generation and checking activities of the Testbench. 
//  The run phase is implemented as a task, and all uvm_component run tasks are executed in parallel.
//-------------------------------------------------------------------------------------------------
  task uart_receiver_driver::run_phase(uvm_phase phase);
    super.run_phase(phase);
    @(negedge vif.clk) begin
    // Driving the reset values
      vif.reset_n   <= 1'b1;
      vif.rx        <= 1'b1;
      vif.recv_ack  <= 1'b0; 
    end
   //for transmission
    forever begin
      uart_receiver_sequence_item req;
      seq_item_port.get_next_item(req);
      drive_data(req);
      // req.print();
      seq_item_port.item_done();
    end 
  endtask:run_phase

//-----------------------------------------------------------------------------
// Task: drive_data
//-----------------------------------------------------------------------------
  task uart_receiver_driver::drive_data(uart_receiver_sequence_item req);
    @(negedge vif.clk)
    vif.reset_n     = req.reset_n  ;
    if (req.reset_n) begin
      req.frame_rx     <= {1'b1, req.rx_sample, 1'b0};
      vif.rx_sample    <= req.rx_sample;
      `uvm_info("RECEIVER_DRIVER", "RX START", UVM_LOW);
      for(int i = 0; i < 10; i++) begin
        req.rx        <= req.frame_rx[i];
        vif.rx        <= req.frame_rx[i];
        repeat(vif.bit_time*2)@(negedge vif.clk);
      end
      wait (vif.recv_req);
      repeat($urandom_range(0,5)) @(posedge vif.clk);
      vif.recv_ack <= 1'b1;
      @(posedge vif.clk);
      `uvm_info("RECEIVER_DRIVER", "RECEIVER ACK", UVM_LOW);
      vif.recv_ack <= 1'b0;
    end
    #53; // wait 53 time unit for reset_n
  endtask: drive_data
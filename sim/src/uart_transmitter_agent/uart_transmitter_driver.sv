/*
 *-----------------------------------------------------------------------------
 *     Copyright (C) 2022 by Dolphin Technology
 *     All right reserved.
 *
 *     Copyright Notification
 *     No part may be reproduced except as authorized by written permission.
 *
 *     Module/Class: uart_transmitter_driver
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
//  Class: uart_transmitter_driver
//  A driver is written by extending the uvm_driver.uvm_driver is inherited from uvm_component, 
//  Methods and TLM port (seq_item_port) are defined for communication between sequencer and driver.
//  The uvm_driver is a parameterized class and it is parameterized with the type of the request
//  sequence_item and the type of the response sequence_item. 
//------------------------------------------------------------------------------------------------//
class uart_transmitter_driver extends uvm_driver #(uart_transmitter_sequence_item);

//  Factory Method in UVM enables us to register a class, object and variables inside the factory 
  `uvm_component_utils(uart_transmitter_driver)

//  Virtual interface holds the pointer to the Interface.
  virtual uart_interface vif;
  uart_transmitter_config w_cfg;
  bit timeout_ack;

 
//  The extern qualifier indicates that the body of the method (its implementation) is to be found 
//  outside the declaration
  extern function new (string name="uart_transmitter_driver", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern task drive_data(uart_transmitter_sequence_item req);

endclass:uart_transmitter_driver

//-----------------------------------------------------------------------------------------------//
//  Constructor:new
//  The new function is called as class constructor. On calling the new method it allocates the 
//  memory and returns the address to the class handle. For the component class two arguments to be 
//  passed. 
//------------------------------------------------------------------------------------------------//
function uart_transmitter_driver::new(string name = "uart_transmitter_driver", uvm_component parent);
  super.new(name, parent);
endfunction:new

//-----------------------------------------------------------------------------------------------//
//  phase:Build
//  The build phases are executed at the start of the UVM Testbench simulation and their overall 
//  purpose is to construct, configure and connect the Testbench component hierarchy.
//  All the build phase methods are functions and therefore execute in zero simulation time.
//------------------------------------------------------------------------------------------------//
  function void uart_transmitter_driver::build_phase(uvm_phase phase);
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
  function void uart_transmitter_driver::connect_phase(uvm_phase phase);
    vif = w_cfg.vif;
  endfunction:connect_phase

//-----------------------------------------------------------------------------------------------//
//  Phase:run
//  The run phase is used for the stimulus generation and checking activities of the Testbench. 
//  The run phase is implemented as a task, and all uvm_component run tasks are executed in parallel.
//------------------------------------------------------------------------------------------------//
  task uart_transmitter_driver::run_phase(uvm_phase phase);
    super.run_phase(phase);
    @(negedge vif.clk) begin
      vif.reset_n   <= 1'b1;
      vif.din       <= 8'b0;
      vif.send_req  <= 1'b0;
      timeout_ack   <= 1'b1;
    end
  //for transmission
    forever begin
      uart_transmitter_sequence_item req;
      seq_item_port.get_next_item(req);
      // req.print();
      drive_data(req);
      seq_item_port.item_done();
    end 
  endtask:run_phase

//-----------------------------------------------------------------------------
// Task: drive_data
//-----------------------------------------------------------------------------
task uart_transmitter_driver::drive_data(uart_transmitter_sequence_item req);
  @(negedge vif.clk)
  if (~req.reset_n) begin
    vif.reset_n   <= req.reset_n;
    vif.send_req  <= req.send_req;
    vif.din       <= req.din;
    #53; // wait 53 time unit for reset_n
    vif.reset_n   <= 1'b1;
  end
  else begin
    fork
      begin
        vif.send_req  <= req.send_req;
        @(negedge vif.clk)
        vif.send_req  <= 1'b0;
      end
    join_none
    vif.reset_n   <= req.reset_n;
    vif.din       <= req.din;
    fork
      begin
        repeat((vif.bit_time)*2*11+2) @(posedge vif.clk);
        if (timeout_ack) begin
          `uvm_error("TRANSMITTER_DRIVER", "SEND_ACK TIMEOUT");
          #100;
        end
      end
      begin
        @(posedge vif.send_ack);
        timeout_ack <= 1'b0;
        `uvm_info("TRANSMITTER_DRIVER", "SEND_ACK ACTIVE", UVM_LOW);
      end
    join
  end
endtask: drive_data
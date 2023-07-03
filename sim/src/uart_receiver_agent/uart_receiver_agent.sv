/*
 *-----------------------------------------------------------------------------
 *     Copyright (C) 2022 by Dolphin Technology
 *     All right reserved.
 *
 *     Copyright Notification
 *     No part may be reproduced except as authorized by written permission.
 *
 *     Module/Class: uart_receiver_agent
 *     Project     : Verification Traning
 *     Author      : haint1
 *     Created     : 2022-10-01 11:04:18
 *     Description :
 *
 *     @Last Modified by:   
 *     @Last Modified time:
 *-----------------------------------------------------------------------------
 */
//  uart_receiver_agent is extended from uvm_agent, uvm_agent is inherited by uvm_component.
//  An agent typically contains: a driver,sequencer, and monitor. Agents can be configured either
//  active or passive.
//-------------------------------------------------------------------------------------------------
class uart_receiver_agent extends uvm_agent;
 `uvm_component_utils(uart_receiver_agent)

  //s_cfg is the handle of uart_receiver_agent_config which is extended from the configuration class  
  uart_receiver_config s_cfg;

//  Handles for the driver, monitor, sequencer is also defined here
  uart_receiver_driver drvh;
  uart_receiver_monitor monh;
  uart_receiver_sequencer m_sequencer;

//  The extern qualifier indicates that the body of the method (its implementation) is to be found 
//  outside the declaration.
  extern function new(string name="uart_receiver_agent", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase (uvm_phase phase);
endclass:uart_receiver_agent

//------------------------------------------------------------------------------------------------
//  Constructor:new
//  The new function is called as class constructor. On calling the new method it allocates the 
//  memory and returns the address to the class handle.
//-----------------------------------------------------------------------------------------------
  function uart_receiver_agent::new(string name="uart_receiver_agent", uvm_component parent);
    super.new(name, parent);
  endfunction:new

//-------------------------------------------------------------------------------------------------
//  Phase:build
//  The build phases are executed at the start of the UVM Testbench simulation and their overall 
//  purpose is to construct, configure and connect the Testbench component hierarchy.
//  All the build phase methods are functions and therefore execute in zero simulation time.
//-----------------------------------------------------------------------------------------------
  function void uart_receiver_agent::build_phase(uvm_phase phase);
    super.build_phase(phase);

    //---------------------------------------------------------------------------------------------
    //The configuration database provides access to a centralized database, where type specific 
    //information can be stored and received. config_db can contain class handles, virtual 
    //interfaces and etc.
    //---------------------------------------------------------------------------------------------
    if(!uvm_config_db #(uart_receiver_config)::get(this,"","uart_receiver_config",s_cfg))
      `uvm_fatal("CONFIG", "cannot get() s_cfg from uvm_config_db. Have you set it?")

//  For Active UVM Agent monitor class is created along with the Sequencer and Driver but for the
//  Passive UVM Agent only Monitor is created
    monh=uart_receiver_monitor::type_id::create("monh", this);
    if(s_cfg.is_active==UVM_ACTIVE) begin
        drvh=uart_receiver_driver::type_id::create("drvh", this);
        m_sequencer=uart_receiver_sequencer::type_id::create("m_sequencer", this);
        drvh.s_cfg=s_cfg;
        m_sequencer.s_cfg=s_cfg;
      end
    endfunction:build_phase


//-------------------------------------------------------------------------------------------------
//  Phase:connect
//  The connect phase is used to make TLM connections between components or to assign handles to 
//  testbench resources. It has to occur after the build method so that Testbench component 
//  hierarchy could be in place and it works from the bottom-up of the hierarchy upwards.
//-----------------------------------------------------------------------------------------------
  function void uart_receiver_agent::connect_phase(uvm_phase phase);
    if(s_cfg.is_active == UVM_ACTIVE)
      drvh.seq_item_port.connect(m_sequencer.seq_item_export);
  endfunction:connect_phase

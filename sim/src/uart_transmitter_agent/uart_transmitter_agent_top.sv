/*
 *-----------------------------------------------------------------------------
 *     Copyright (C) 2022 by Dolphin Technology
 *     All right reserved.
 *
 *     Copyright Notification
 *     No part may be reproduced except as authorized by written permission.
 *
 *     Module/Class: uart_transmitter_agent_top
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
//  Class:uart_transmitter_agent_top
//  uart_transmitter_agent_top is extended from uvm_env. It contains the agent. Configuration of 
//  agent_congif_db is done in agent_top.
//------------------------------------------------------------------------------------------------//
class uart_transmitter_agent_top extends uvm_env;

//  Factory Method in UVM enables us to register a class, object and variables inside the factory 
  `uvm_component_utils(uart_transmitter_agent_top)
//------------------------------------------------------------------------------------------------//
//  Master_agent class is defined as dynamic so multiple agents can be instantiated. But in UART 
//  only one master is enough since it is one to one transmission. Hence Master_agent should always 
//  set to be one.
//------------------------------------------------------------------------------------------------//
  uart_transmitter_agent wagent[];
  env_config e_cfg;

//  The extern qualifier indicates that its implementation is to be found outside the declaration.
  extern function new(string name= "uart_transmitter_agent_top", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
endclass:uart_transmitter_agent_top


//------------------------------------------------------------------------------------------------//
//  Constructor:new
//  The new function is called as class constructor. On calling the new method it allocates the 
//  memory and returns the address to the class handle. For the component class two arguments to be 
//  passed. 
//------------------------------------------------------------------------------------------------//
  function uart_transmitter_agent_top::new(string name= "uart_transmitter_agent_top", uvm_component parent);
    super.new(name, parent);
  endfunction:new

//-----------------------------------------------------------------------------------------------//
//  Phase:Build
//  The build phases are executed at the start of the UVM Testbench simulation and their overall 
//  purpose is to construct, configure and connect the Testbench component hierarchy.
//  All the build phase methods are functions and therefore execute in zero simulation time.
//------------------------------------------------------------------------------------------------//
  function void uart_transmitter_agent_top::build_phase(uvm_phase phase);
    if(!uvm_config_db #(env_config)::get(this,"","env_config", e_cfg))
      `uvm_fatal("CONFIG_ENV","cannot get() env_config from uvm_config_db. Have you set() it?")
      wagent = new[e_cfg.no_of_wagent];
      foreach(wagent[i]) begin
        uvm_config_db #(uart_transmitter_config)::set(this,$sformatf("wagent[%0d]*",i), "uart_transmitter_config",e_cfg.w_cfg[i]);
        wagent[i]= uart_transmitter_agent::type_id::create($sformatf("wagent[%0d]",i), this);
      end
    super.build_phase(phase);
  endfunction:build_phase 


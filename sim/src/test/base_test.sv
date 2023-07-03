/*
 *-----------------------------------------------------------------------------
 *     Copyright (C) 2022 by Dolphin Technology
 *     All right reserved.
 *
 *     Copyright Notification
 *     No part may be reproduced except as authorized by written permission.
 *
 *     Module/Class: base_test
 *     Project     : Verification Traning
 *     Author      : haint1
 *     Created     : 2022-10-01 11:04:18
 *     Description :
 *
 *     @Last Modified by:   
 *     @Last Modified time:
 *-----------------------------------------------------------------------------
 */

//-----------------------------------------------------------------------------------------------
//  Class:base_test
//  In this we provide information about setting env_config and starting the base test
//------------------------------------------------------------------------------------------------
class base_test extends uvm_test;
  `uvm_component_utils(base_test)
  virtual uart_interface vif;
//Declaring handles for different components
  uart_env envh;
  env_config e_cfg;
  uart_transmitter_config w_cfg[];
  uart_receiver_config s_cfg[];
  int no_of_ragent = 1;
  int no_of_wagent=1;
  int has_ragent = 1;
  int has_wagent = 1;
  //---------------------------------------------
  // Externally defined tasks and functions
  //---------------------------------------------
  extern function new(string name = "base_test" , uvm_component parent);
  extern function void configuration();
  extern function void build_phase(uvm_phase phase);
  virtual function void end_of_elaboration();
    //print's the topology
    print();
  endfunction
  extern task run_phase(uvm_phase phase);
endclass:base_test


//-----------------------------------------------------------------------------
//  Constructor: new
//  Initializes the config_template class object
//  Parameters:
//  name - instance name of the config_template
//  parent - parent under which this component is created
//-----------------------------------------------------------------------------
function base_test::new(string name = "base_test" , uvm_component parent);
  super.new(name,parent);
endfunction:new

//------------------------------------------------------------------------------------------------
//  Function:configuration()
//  This gives information about creating a component abd regestring the id to factory
//--------------------------------------------------------------------------------------------------
function void base_test::configuration();
  e_cfg.w_cfg=new[no_of_wagent];
  e_cfg.s_cfg=new[no_of_ragent];

  if (has_wagent) begin
    w_cfg = new[no_of_wagent];
    foreach(w_cfg[i]) begin
      w_cfg[i]=uart_transmitter_config::type_id::create($sformatf("w_cfg[%0d]", i));
        if(!uvm_config_db #(virtual uart_interface)::get(this,"", $sformatf("vif_%0d",i),w_cfg[i].vif))
          `uvm_fatal("VIF CONFIG","cannot get()interface vif from uvm_config_db. Have you set() it?") 
      w_cfg[i].is_active = UVM_ACTIVE;
      e_cfg.w_cfg[i] = w_cfg[i];
    end
  end
  
  if (has_ragent) begin
    s_cfg=new[no_of_ragent];
    foreach(s_cfg[i]) begin
      s_cfg[i]=uart_receiver_config::type_id::create($sformatf("s_cfg[%0d]",i));
        if(!uvm_config_db #(virtual uart_interface)::get(this,"",$sformatf("vif_%0d",i),s_cfg[i].vif))
          `uvm_fatal("VIF CONFIG","cannot get() interface vif from uvm_config_db. Have you set() it?")
      s_cfg[i].is_active = UVM_ACTIVE;
      e_cfg.s_cfg[i]=s_cfg[i]; 
    end
  end
        e_cfg.no_of_ragent = no_of_ragent;
        e_cfg.no_of_wagent = no_of_wagent;
        e_cfg.has_ragent = has_ragent;
        e_cfg.has_wagent = has_wagent;
  endfunction: configuration

//-----------------------------------------------------------------------------
//  Function: build_phase
//  Creates the required ports
//  Parameters:
//  phase - stores the current phase 
//-----------------------------------------------------------------------------
  function void base_test::build_phase(uvm_phase phase);
    e_cfg = env_config::type_id::create("e_cfg");
    if(has_wagent)
      e_cfg.w_cfg = new[no_of_wagent];
    if(has_ragent)
      e_cfg.s_cfg = new[no_of_ragent];
    configuration();
    super.build_phase(phase);
    uvm_config_db #(env_config)::set(this,"*","env_config",e_cfg);
    envh= uart_env::type_id::create("envh", this);
  endfunction:build_phase

  //--------------------------------------------------------------------------------
  //Task:run_phase
  //--------------------------------------------------------------------------------
  task base_test::run_phase(uvm_phase phase);
    uart_transmitter_sequence send_req;
    uart_receiver_sequence recv_req;
    send_req = new("send_seq");
    recv_req = new("recv_req");
    phase.raise_objection(this);
    send_req.start(envh.wtop.wagent[0].m_sequencer);
    recv_req.start(envh.rtop.ragent[0].m_sequencer);
    phase.drop_objection(this);
  endtask
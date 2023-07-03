//------------------------------------------------------------------------------------------------//
//  Class: uart_env
//  Class uart_env is derived from uvm_env, contains all the components such as agent, scoreboard, 
//  coverage, virtual sequencer.
//------------------------------------------------------------------------------------------------//
// `include "include_files.svh"
class uart_env extends uvm_env;
  `uvm_component_utils(uart_env)

//Declaring  handles different components
  env_config e_cfg;
  uart_transmitter_agent_top wtop;
  uart_receiver_agent_top rtop;
  virtual_sequencer v_seqrh;

//---------------------------------------------
//  Externally defined tasks and functions
//---------------------------------------------
  extern function new ( string name="uart_env", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
endclass


//-----------------------------------------------------------------------------
//  Constructor: new
//  Initializes the config_template class object
//  Parameters:
//  name - instance name of the config_template
//  parent - parent under which this component is created
//-----------------------------------------------------------------------------
function uart_env::new(string name = "uart_env", uvm_component parent);
  super.new(name, parent);
endfunction:new

//-----------------------------------------------------------------------------
//  Function: build_phase
//  Creates the required ports
//  Parameters:
//  phase - stores the current phase 
//----------------------------------------------------------------------------- 
function void uart_env::build_phase(uvm_phase phase);
  if(!uvm_config_db #(env_config)::get(this, "","env_config",e_cfg))
    `uvm_fatal("CONFIG", "Cannot get() e_cfg  from uvm_config")
   super.build_phase(phase);

  if(e_cfg.has_wtop==1) 
    wtop=uart_transmitter_agent_top::type_id::create("wtop",this);

  if(e_cfg.has_rtop==1) 
    rtop=uart_receiver_agent_top::type_id::create("rtop",this);
              
  if(e_cfg.has_virtual_sequencer)
    v_seqrh=virtual_sequencer::type_id::create("v_seqrh",this);

endfunction:build_phase

//------------------------------------------------------------------------------------------------
//  Phase:connect
//  Here the connection is done between virtual sequences in test and environment
//------------------------------------------------------------------------------------------------
  function void uart_env::connect_phase (uvm_phase phase);
    if(e_cfg.has_wtop == 1) begin
      for(int i=0; i < e_cfg.no_of_wagent; i++) begin
        v_seqrh.master_seqrh[i] = wtop.wagent[i].m_sequencer;
       end
    end
    if(e_cfg.has_rtop == 1) begin
      for(int i=0; i < e_cfg.no_of_ragent; i++) begin
        v_seqrh.slave_seqrh[i] = rtop.ragent[i].m_sequencer;
      end
    end
  endfunction:connect_phase



//------------------------------------------------------------------------------------------------//
//  Class: virtual_sequencer
//  A virtual sequence is a container to start multiple sequences on different sequencers in
//  the environment. 
//------------------------------------------------------------------------------------------------//
  class virtual_sequencer extends uvm_sequencer #(uvm_sequence_item);
    `uvm_component_utils(virtual_sequencer)
    virtual uart_interface vif;
    uart_transmitter_sequencer master_seqrh[];
    uart_receiver_sequencer slave_seqrh[];
    env_config e_cfg;
    extern function new(string name = "virtual_sequencer", uvm_component parent);
    extern function void build_phase(uvm_phase phase);
  endclass

//----------------------------------------------------------------------------------------------------
//  Constructor: new
//  Initializes the config_template class object
//  Parameters:
//  name - instance name of the config_template
//  parent - parent under which this component is created
//---------------------------------------------------------------------------------------------------
  function virtual_sequencer::new(string name= "virtual_sequencer", uvm_component parent);
    super.new(name, parent);
  endfunction

//--------------------------------------------------------------------------------
//  Phase:build
//  The build phase has to be that way because the parent component's build_phase constructs
//  the child components. You couldn't call the child's build_phase before the parent's 
//  build_phase because they the child objects haven't been constructed yet. And you need
//  a constructed object to call its method.
//---------------------------------------------------------------------------------
function void virtual_sequencer::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if(!uvm_config_db #(env_config)::get(this,"","env_config",e_cfg))
    `uvm_fatal("CONFIG","Cannot get() e_cfg from uvm_congig_db. Have you set it?")
    vif = e_cfg.intf;
    master_seqrh = new[e_cfg.no_of_wagent];
    slave_seqrh = new[e_cfg.no_of_ragent];
endfunction

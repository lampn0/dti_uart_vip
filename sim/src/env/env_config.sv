//------------------------------------------------------------------------------------------------//
//  Class: env_config
//  A env_config is written by extending the uvm_object. 
//------------------------------------------------------------------------------------------------//
class env_config extends uvm_object;
  `uvm_object_utils(env_config)

  virtual uart_interface intf;
  uart_transmitter_config w_cfg[];
  uart_receiver_config s_cfg[];

  bit has_wagent = 1;
  bit has_ragent = 1;
  bit has_wtop = 1;
  bit has_rtop = 1;

  bit has_virtual_sequencer = 1;
  int no_of_wagent = 1;
  int no_of_ragent = 1;
  int no_of_wtop;
  int no_of_rtop;
//---------------------------------------------
// Externally defined tasks and functions
//---------------------------------------------
  extern function new(string name = "env_config");

endclass: env_config

//-----------------------------------------------------------------------------
//  Constructor: new
//  Initializes the config_template class object
//  Parameters:
//  name - instance name of the config_template
//-----------------------------------------------------------------------------
function env_config::new(string name = "env_config");
  super.new(name);
endfunction:new



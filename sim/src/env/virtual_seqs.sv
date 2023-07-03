//-----------------------------------------------------------------------------
//  Class: virtual_seqs
//  A virtual sequence is a container to start multiple sequences on different sequencers in the
//  environment.
//-----------------------------------------------------------------------------
class virtual_seqs extends uvm_sequence #(uvm_sequence_item);
  `uvm_object_utils(virtual_seqs)
  `uvm_declare_p_sequencer(virtual_sequencer)
//---------------------------------------------
//  Externally defined tasks and functions
//---------------------------------------------
  extern function new(string name="virtual_seqs");
endclass

//------------------------------------------------------------------------------------------------------
//  Constructor: new
//  Initializes the config_template class object
//  Parameters:
//  name instance name of the config_template
//  parent parent under which this component is created
//-------------------------------------------------------------------------------------------------------
function virtual_seqs::new(string name="virtual_seqs");
  super.new(name);
endfunction



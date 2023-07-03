
`ifndef SYS_FREQ
`define SYS_FREQ 500000
`endif

`ifndef BAUD_RATE
`define BAUD_RATE 9600
`endif

`ifndef DATA_SIZE
`define DATA_SIZE 8
`endif

`include "uvm.sv"
`include "uvm_macros.svh"
import  uvm_pkg::*;

`include "../src/env/uart_interface.sv"

`include "../src/uart_transmitter_agent/uart_transmitter_sequence_item.sv"
`include "../src/uart_transmitter_agent/uart_transmitter_config.sv"
`include "../src/uart_receiver_agent/uart_receiver_config.sv"
`include "../src/env/env_config.sv"
`include "../src/uart_transmitter_agent/uart_transmitter_driver.sv"
`include "../src/uart_transmitter_agent/uart_transmitter_monitor.sv"
`include "../src/uart_transmitter_agent/uart_transmitter_sequencer.sv"
`include "../src/uart_transmitter_agent/uart_transmitter_agent.sv"
`include "../src/uart_transmitter_agent/uart_transmitter_agent_top.sv"
`include "../src/uart_transmitter_agent/uart_transmitter_sequence.sv"

`include "../src/uart_receiver_agent/uart_receiver_sequence_item.sv"
`include "../src/uart_receiver_agent/uart_receiver_driver.sv"
`include "../src/uart_receiver_agent/uart_receiver_monitor.sv"
`include "../src/uart_receiver_agent/uart_receiver_sequencer.sv"
`include "../src/uart_receiver_agent/uart_receiver_sequence.sv"
`include "../src/uart_receiver_agent/uart_receiver_agent.sv"
`include "../src/uart_receiver_agent/uart_receiver_agent_top.sv"

`include "../src/env/virtual_sequencer.sv"
`include "../src/env/virtual_seqs.sv"
`include "../src/env/uart_env.sv"

`include "../src/test/base_test.sv"
`include "../src/env/uart_coverage.sv"
`include "../src/env/uart_sva.sv"
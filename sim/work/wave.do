onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group TRANS -radix unsigned /uart_tb_top/uart_inst/uart_transmitter/DATA_SIZE
add wave -noupdate -group TRANS -radix unsigned /uart_tb_top/uart_inst/uart_transmitter/BIT_COUNT_SIZE
add wave -noupdate -group TRANS /uart_tb_top/uart_inst/uart_transmitter/IDLE
add wave -noupdate -group TRANS /uart_tb_top/uart_inst/uart_transmitter/SENDING
add wave -noupdate -group TRANS /uart_tb_top/uart_inst/uart_transmitter/clk
add wave -noupdate -group TRANS /uart_tb_top/uart_inst/uart_transmitter/reset_n
add wave -noupdate -group TRANS -radix binary /uart_tb_top/uart_inst/uart_transmitter/din
add wave -noupdate -group TRANS /uart_tb_top/uart_inst/uart_transmitter/tx
add wave -noupdate -group TRANS /uart_tb_top/uart_inst/uart_transmitter/send_req
add wave -noupdate -group TRANS /uart_tb_top/uart_inst/uart_transmitter/send_ack
add wave -noupdate -group TRANS -radix binary /uart_tb_top/uart_inst/uart_transmitter/tx_shift_reg
add wave -noupdate -group TRANS /uart_tb_top/uart_inst/uart_transmitter/bit_count
add wave -noupdate -group TRANS /uart_tb_top/uart_inst/uart_transmitter/bit_count_done
add wave -noupdate -group TRANS /uart_tb_top/uart_inst/uart_transmitter/load_tx_shift_reg
add wave -noupdate -group TRANS /uart_tb_top/uart_inst/uart_transmitter/shift
add wave -noupdate -group TRANS /uart_tb_top/uart_inst/uart_transmitter/clear
add wave -noupdate -group TRANS /uart_tb_top/uart_inst/uart_transmitter/state
add wave -noupdate -group TRANS /uart_tb_top/uart_inst/uart_transmitter/next_state
add wave -noupdate -group TRANS /uart_tb_top/uart_inst/uart_gen_clk/count_sample_clk
add wave -noupdate -group TRANS -radix unsigned /uart_tb_top/uart_inst/uart_gen_clk/CLOCK
add wave -noupdate -group TRANS -radix unsigned /uart_tb_top/uart_inst/uart_gen_clk/BAUD_DV
add wave -noupdate -group TRANS /uart_tb_top/intf/bit_time
add wave -noupdate -group TRANS /uart_tb_top/intf/send_ack
add wave -noupdate /uart_tb_top/uart_sva/AP_SEND_ACK
add wave -noupdate -expand -group RECV -radix unsigned /uart_tb_top/uart_inst/uart_receiver/DATA_SIZE
add wave -noupdate -expand -group RECV -radix unsigned /uart_tb_top/uart_inst/uart_receiver/SAMPLE
add wave -noupdate -expand -group RECV -radix unsigned /uart_tb_top/uart_inst/uart_receiver/BIT_COUNT_SIZE
add wave -noupdate -expand -group RECV /uart_tb_top/uart_inst/uart_receiver/IDLE
add wave -noupdate -expand -group RECV /uart_tb_top/uart_inst/uart_receiver/RECEIVING
add wave -noupdate -expand -group RECV /uart_tb_top/uart_inst/uart_receiver/WAIT_ACK
add wave -noupdate -expand -group RECV /uart_tb_top/uart_inst/uart_receiver/count_clk
add wave -noupdate -expand -group RECV /uart_tb_top/uart_inst/uart_receiver/clk
add wave -noupdate -expand -group RECV /uart_tb_top/uart_inst/uart_receiver/reset_n
add wave -noupdate -expand -group RECV /uart_tb_top/uart_inst/uart_receiver/en_sample
add wave -noupdate -expand -group RECV /uart_tb_top/uart_inst/uart_receiver/rx
add wave -noupdate -expand -group RECV -radix binary /uart_tb_top/uart_inst/uart_receiver/dout
add wave -noupdate -expand -group RECV /uart_tb_top/uart_inst/uart_receiver/recv_req
add wave -noupdate -expand -group RECV /uart_tb_top/uart_inst/uart_receiver/recv_ack
add wave -noupdate -expand -group RECV -radix binary /uart_tb_top/uart_inst/uart_receiver/check_start
add wave -noupdate -expand -group RECV /uart_tb_top/uart_inst/uart_receiver/count_sample
add wave -noupdate -expand -group RECV /uart_tb_top/uart_inst/uart_receiver/center
add wave -noupdate -expand -group RECV /uart_tb_top/uart_inst/uart_receiver/bit_count
add wave -noupdate -expand -group RECV /uart_tb_top/uart_inst/uart_receiver/bit_count_done
add wave -noupdate -expand -group RECV /uart_tb_top/uart_inst/uart_receiver/load_rx_shift_reg
add wave -noupdate -expand -group RECV /uart_tb_top/uart_inst/uart_receiver/clear
add wave -noupdate -expand -group RECV /uart_tb_top/uart_inst/uart_receiver/start
add wave -noupdate -expand -group RECV /uart_tb_top/uart_inst/uart_receiver/state
add wave -noupdate -expand -group RECV /uart_tb_top/uart_inst/uart_receiver/next_state
add wave -noupdate /uart_tb_top/uart_sva/AP_RECV_REQ
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {364 us} 1} {{Cursor 2} {2468 us} 0}
quietly wave cursor active 2
configure wave -namecolwidth 150
configure wave -valuecolwidth 131
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {2095 us} {3971 us}

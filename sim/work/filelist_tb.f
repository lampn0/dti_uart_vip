+notimingchecks
-sv
-timescale "1us/1us"
-incr
-hazards

//  Include Path
+incdir+../inc
+incdir+../libs/uvm-1.1d/src
+incdir+../src

-y  ../inc
-y  ../libs/uvm-1.1d/src
-y  ../src

// -v  ../inc/include_files.svh
// ../inc/include_files.svh
///////////////////////////////////////////////////////////////////////////////
//  Top Testbench Level Module
///////////////////////////////////////////////////////////////////////////////

+define+SYS_FREQ=500000
+define+BAUD_RATE=9600
+define+DATA_SIZE=8

../src/uart_tb_top/uart_tb_top.sv
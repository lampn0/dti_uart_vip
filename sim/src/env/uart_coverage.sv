/*
 *-----------------------------------------------------------------------------
 *     Copyright (C) 2022 by Dolphin Technology
 *     All right reserved.
 *
 *     Copyright Notification
 *     No part may be reproduced except as authorized by written permission.
 *
 *     Module/Class: uart_coverage
 *     Project     : Verification Traning
 *     Author      : haint1
 *     Created     : 2022-10-01 11:04:18
 *     Description :
 *
 *     @Last Modified by:   
 *     @Last Modified time:
 *-----------------------------------------------------------------------------
 */

  class uart_coverage;
  virtual uart_interface intf;

  covergroup coverage ;
    CVP_RESET_N: coverpoint intf.reset_n{
      bins reset = {0};
      bins no_reset = {1};
    }
    CVP_SEND_REQ : coverpoint intf.send_req{
      bins have_req = {1};
      bins no_req = {0};
    }
    CVP_SEND_ACK : coverpoint intf.send_ack{
      bins send_done = {1};
      bins send_not_done = {0};
    }
    CVP_RECV_ACK : coverpoint intf.recv_ack{
      bins have_req = {1};
      bins no_req = {0};
    }
    CVP_RECV_REQ : coverpoint intf.recv_req{
      bins recv_done = {1};
      bins recv_not_done = {0};
    }
  endgroup : coverage

  covergroup din_cov ;
    CVP_DIN : coverpoint intf.din;
    option.auto_bin_max = 16;
  endgroup : din_cov

  covergroup dout_cov ;
    CVP_DOUT : coverpoint intf.dout;
    option.auto_bin_max = 16;
  endgroup : dout_cov

    function new(string sName = "coverage");
      coverage = new();
      din_cov = new();
      dout_cov = new();
      coverage.option.name = sName;
    endfunction

    function void samplesignal(virtual uart_interface intf);
      this.intf = intf;
      coverage.sample();
    endfunction

    function void sampledin(virtual uart_interface intf);
      this.intf = intf;
      din_cov.sample();
    endfunction

    function void sampledout(virtual uart_interface intf);
      this.intf = intf;
      dout_cov.sample();
    endfunction
  endclass
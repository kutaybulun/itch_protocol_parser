//ITCH PROTOCOL PARSER Verification
`timescale 1ns/1ns
import uvm_pkg::*;
`include "uvm_macros.svh"

//--------------------------------------------------------
//Include Files
//--------------------------------------------------------
`include "interface.sv"
`include "sequence_item.sv"
`include "sequence.sv"
`include "sequencer.sv"
`include "driver.sv"
`include "monitor.sv"
`include "agent.sv"
`include "scoreboard.sv"
`include "env.sv"
`include "test.sv"

module tb_top;

//--------------------------------------------------------
//Instantiation
//--------------------------------------------------------
logic clk;
tb_interface intf(.clk(clk));

top dut(
.clk(intf.clk),
.rst(intf.rst),
.rx_data_net(intf.rx_data_net),
.counterOut(intf.counterOut),
.dMac_out(intf.dMac_out),
.sMac_out(intf.sMac_out),
.oTag_out(intf.oTag_out),
.eType_out(intf.eType_out),
.version_out(intf.version_out),
.headerLength_out(intf.headerLength_out),
.typeOfService_out(intf.typeOfService_out),
.totalLength_out(intf.totalLength_out),
.identification_out(intf.identification_out),
.flags_out(intf.flags_out),
.fragmentOffset_out(intf.fragmentOffset_out),
.timeToLive_out(intf.timeToLive_out),
.protocol_out(intf.protocol_out),
.headerChecksum_out(intf.headerChecksum_out),
.srcIPAddress_out(intf.srcIPAddress_out),
.destIPAddress_out(intf.destIPAddress_out),
.srcPort_out(intf.srcPort_out),
.destPort_out(intf.destPort_out),
.length_out(intf.length_out),
.checksum_out(intf.checksum_out),
.sessionID_out(intf.sessionID_out),
.sequenceNumber_out(intf.sequenceNumber_out),
.messageCount_out(intf.messageCount_out)
);

//--------------------------------------------------------
//Interface Setting
//--------------------------------------------------------
initial begin
    uvm_config_db #(virtual tb_interface)::set(null, "*", "vif", intf );
end

//--------------------------------------------------------
//Start The Test
//--------------------------------------------------------
initial begin
    run_test("tb_test");
end
  
  
//--------------------------------------------------------
//Clock Generation
//--------------------------------------------------------
initial begin
    clk = 0;
    #10;
    forever #10 clk = ~clk;
end

//--------------------------------------------------------
//Maximum Simulation Time
//--------------------------------------------------------
initial begin
    #5000;
    $display("Sorry! Ran out of clock cycles!");
    $finish();
end

//--------------------------------------------------------
//Generate Waveforms
//--------------------------------------------------------
initial begin
    $dumpfile("d.vcd");
    $dumpvars();
end

endmodule : tb_top
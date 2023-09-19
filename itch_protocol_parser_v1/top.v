`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:59:26 09/18/2023 
// Design Name: 
// Module Name:    top 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module top(
	input clk,
	input rst,
	input [63:0] dataIn,
	input rx_sof_net,
	input rx_eof_net,
	input [2:0] rx_len_net,
	input rx_vld_net
 );
 
//wires
wire [6:0] counter;
wire [63:0] rx_data_net;
wire [47:0] dMac, sMac;
wire [15:0] oTag, eType;
wire [3:0] version, headerLength;
wire [7:0] typeOfService;
wire [15:0] totalLength, identification;
wire [2:0] flags;
wire [12:0] fragmentOffset;
wire [7:0] timeToLive, protocol;
wire [15:0] headerChecksum;
wire [31:0] srcIPAddress, destIPAddress;
wire [15:0] srcPort, destPort, length, checksum;
wire [79:0] sessionID;
wire [63:0] sequenceNumber;
wire [15:0] messageCount;

//modules
packetRx u_packetRx(
	.clk(clk),
	.rst(rst),
	.rx_data_net(dataIn),
	.rx_sof_net(rx_sof_net),
	.rx_eof_net(rx_eof_net),
	.rx_len_net(rx_len_net),
	.rx_vld_net(rx_vld_net),
	.dataOut(rx_data_net),
	.counterOut(counter)
);

ethernetDecoder u_ethernetDecoder (
	.clk(clk),
	.rst(rst),
	.counter(counter),
	.dataIn(rx_data_net), // Connect dataIn to rx_data_net of packetRx
	.dMac(dMac),
	.sMac(sMac),
	.oTag(oTag),
	.eType(eType)
);

ipDecoder u_ipDecoder (
    .clk(clk),
    .rst(rst),
    .counter(counter),
    .dataIn(rx_data_net), // Connect dataIn to rx_data_net of packetRx
    .version(version),
    .headerLength(headerLength),
    .typeOfService(typeOfService),
    .totalLength(totalLength),
    .identification(identification),
    .flags(flags),
    .fragmentOffset(fragmentOffset),
    .timeToLive(timeToLive),
    .protocol(protocol),
    .headerChecksum(headerChecksum),
    .srcIPAddress(srcIPAddress),
    .destIPAddress(destIPAddress)
);

udpDecoder u_udpDecoder (
    .clk(clk),
    .rst(rst),
    .dataIn(rx_data_net), // Connect dataIn to rx_data_net of packetRx
    .counter(counter),
    .srcPort(srcPort),
    .destPort(destPort),
    .length(length),
    .checksum(checksum)
);

moldUDP64Decoder u_moldUDP64Decoder (
	 .clk(clk),
	 .rst(rst),
	 .dataIn(rx_data_net), // Connect dataIn to rx_data_net of packetRx
	 .counter(counter),
	 .sessionID(sessionID),
	 .sequenceNumber(sequenceNumber),
	 .messageCount(messageCount)
);

messageParserTop u_messageParserTop (
	.clk(clk),
	.rst(rst),
	.dataIn(rx_data_net), // Connect dataIn to rx_data_net of packetRx
	.counter(counter)
);

endmodule

class tb_sequence_item extends uvm_sequence_item;

`uvm_object_utils(tb_sequence_item)

//--------------------------------------------------------
//Instantiation
//--------------------------------------------------------
rand logic rst;
rand logic [63:0] rx_data_net;
//outputs
logic [6:0] counterOut;
logic [47:0] dMac_out;
logic [47:0] sMac_out;
logic [15:0] oTag_out;
logic [15:0] eType_out;
logic [3:0] version_out;
logic [3:0] headerLength_out;
logic [7:0] typeOfService_out;
logic [15:0] totalLength_out;
logic [15:0] identification_out;
logic [2:0] flags_out;
logic [12:0] fragmentOffset_out;
logic [7:0] timeToLive_out;
logic [7:0] protocol_out;
logic [15:0] headerChecksum_out;
logic [31:0] srcIPAddress_out;
logic [31:0] destIPAddress_out;
logic [15:0] srcPort_out;
logic [15:0] destPort_out;
logic [15:0] length_out;
logic [15:0] checksum_out;
logic [79:0] sessionID_out;
logic [63:0] sequenceNumber_out;
logic [15:0] messageCount_out;

//--------------------------------------------------------
//Default Constraints
//--------------------------------------------------------
constraint rst_constraint {rst inside {0,1};}
//--------------------------------------------------------
//Constructor
//--------------------------------------------------------
function new(string name = "tb_sequence_item");
    super.new(name);
endfunction: new

endclass: tb_sequence_item
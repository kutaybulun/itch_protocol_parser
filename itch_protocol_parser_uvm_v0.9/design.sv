module top(
    input clk,
    input rst,
    input [63:0] rx_data_net,
    output [6:0] counterOut,
	 
	output [47:0] dMac_out,
    output [47:0] sMac_out,
    output [15:0] oTag_out,
    output [15:0] eType_out,
    output [3:0] version_out,
    output [3:0] headerLength_out,
    output [7:0] typeOfService_out,
    output [15:0] totalLength_out,
    output [15:0] identification_out,
    output [2:0] flags_out,
    output [12:0] fragmentOffset_out,
    output [7:0] timeToLive_out,
    output [7:0] protocol_out,
    output [15:0] headerChecksum_out,
    output [31:0] srcIPAddress_out,
    output [31:0] destIPAddress_out,
    output [15:0] srcPort_out,
    output [15:0] destPort_out,
    output [15:0] length_out,
    output [15:0] checksum_out,
    output [79:0] sessionID_out,
    output [63:0] sequenceNumber_out,
    output [15:0] messageCount_out
);

reg [6:0] counter;
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

always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 7'b0;
    end else begin
        counter <= counter + 1;
    end
end

assign counterOut = counter;

assign dMac_out = dMac;
assign sMac_out = sMac;
assign oTag_out = oTag;
assign eType_out = eType;
assign version_out = version;
assign headerLength_out = headerLength;
assign typeOfService_out = typeOfService;
assign totalLength_out = totalLength;
assign identification_out = identification;
assign flags_out = flags;
assign fragmentOffset_out = fragmentOffset;
assign timeToLive_out = timeToLive;
assign protocol_out = protocol;
assign headerChecksum_out = headerChecksum;
assign srcIPAddress_out = srcIPAddress;
assign destIPAddress_out = destIPAddress;
assign srcPort_out = srcPort;
assign destPort_out = destPort;
assign length_out = length;
assign checksum_out = checksum;
assign sessionID_out = sessionID;
assign sequenceNumber_out = sequenceNumber;
assign messageCount_out = messageCount;

endmodule

module ethernetDecoder (
    input clk, rst,
    input [6:0] counter,
    input [63:0] dataIn,
    output reg [47:0] dMac,
    output reg [47:0] sMac,
    output reg [15:0] oTag,
    output reg [15:0] eType
);

reg [47:0] dMacNext;
reg [47:0] sMacNext;
reg [15:0] oTagNext;
reg [15:0] eTypeNext;

always @(posedge clk) begin
    dMac <= dMacNext;
    sMac <= sMacNext;
    oTag <= oTagNext;
    eType <= eTypeNext;
end

always @* begin
    dMacNext = dMac;
    sMacNext = sMac;
    oTagNext = oTag;
    eTypeNext = eType;
    if (rst) begin
        dMacNext = 0;
        sMacNext = 0;
        oTagNext = 0;
        eTypeNext = 0;
    end else begin
        case (counter)
            0: begin
                dMacNext = dataIn[47:0];
                sMacNext[15:0] = dataIn[63:48];
            end
            1: begin
                sMacNext[47:16] = dataIn[31:0];
                oTagNext = dataIn[47:32];
                eTypeNext = dataIn[63:48];
            end
        endcase
    end
end
    
endmodule

module ipDecoder (
    input clk,
    input rst,
    input [6:0] counter,
    input [63:0] dataIn,
    output reg [3:0] version,
    output reg [3:0] headerLength,
    output reg [7:0] typeOfService,
    output reg [15:0] totalLength,
    output reg [15:0] identification,
    output reg [2:0] flags,
    output reg [12:0] fragmentOffset,
    output reg [7:0] timeToLive,
    output reg [7:0] protocol,
    output reg [15:0] headerChecksum,
    output reg [31:0] srcIPAddress,
    output reg [31:0] destIPAddress
);

reg [3:0] versionNext;
reg [3:0] headerLengthNext;
reg [7:0] typeOfServiceNext;
reg [15:0] totalLengthNext;
reg [15:0] identificationNext;
reg [2:0] flagsNext;
reg [12:0] fragmentOffsetNext;
reg [7:0] timeToLiveNext;
reg [7:0] protocolNext;
reg [15:0] headerChecksumNext;
reg [31:0] srcIPAddressNext;
reg [31:0] destIPAddressNext;

always @(posedge clk) begin
    version <= versionNext;
    headerLength <= headerLengthNext;
    typeOfService <= typeOfServiceNext;
    totalLength <= totalLengthNext;
    identification <= identificationNext;
    flags <= flagsNext;
    fragmentOffset <= fragmentOffsetNext;
    timeToLive <= timeToLiveNext;
    protocol <= protocolNext;
    headerChecksum <= headerChecksumNext;
    srcIPAddress <= srcIPAddressNext;
    destIPAddress <= destIPAddressNext;
end

always @* begin
    versionNext = version;
    headerLengthNext = headerLength;
    typeOfServiceNext = typeOfService;
    totalLengthNext = totalLength;
    identificationNext = identification;
    flagsNext = flags;
    fragmentOffsetNext = fragmentOffset;
    timeToLiveNext = timeToLive;
    protocolNext = protocol;
    headerChecksumNext = headerChecksum;
    srcIPAddressNext = srcIPAddress;
    destIPAddressNext = destIPAddress;
    if (rst) begin
        versionNext = 4'h0;
        headerLengthNext = 4'h0;
        typeOfServiceNext = 8'h0;
        totalLengthNext = 16'h0;
        identificationNext = 16'h0;
        flagsNext = 2'h0;
        fragmentOffsetNext = 13'h0;
        timeToLiveNext = 8'h0;
        protocolNext = 8'h0;
        headerChecksumNext = 16'h0;
        srcIPAddressNext = 32'h0;
        destIPAddressNext = 32'h0;
    end else begin
        case (counter)
            2: begin
                versionNext = dataIn[3:0];
                headerLengthNext = dataIn[7:4];
                typeOfServiceNext = dataIn[15:8];
                totalLengthNext = dataIn[31:16];
                identificationNext = dataIn[47:32];
                flagsNext = dataIn[50:48];
                fragmentOffsetNext = dataIn[63:51];
            end
            3: begin
                timeToLiveNext = dataIn[7:0];
                protocolNext = dataIn[15:8];
                headerChecksumNext = dataIn[31:16];
                srcIPAddressNext = dataIn[63:32];
            end
            4: begin
                destIPAddressNext = dataIn[31:0];
            end
        endcase
    end
end
    
endmodule

module moldUDP64Decoder (
    input clk, rst,
    input [63:0] dataIn,
    input [6:0] counter,
    output reg [79:0] sessionID,
    output reg [63:0] sequenceNumber,
    output reg [15:0] messageCount
);

reg [79:0] sessionIDNext;
reg [63:0] sequenceNumberNext;
reg [15:0] messageCountNext;

always @(posedge clk) begin
    sessionID <= sessionIDNext;
    sequenceNumber <= sequenceNumberNext;
    messageCount <= messageCountNext;
end

always @* begin
    sessionIDNext = sessionID;
    sequenceNumberNext = sequenceNumber;
    messageCountNext = messageCount;
    if (rst) begin
        sessionIDNext = 80'h0;
        sequenceNumberNext = 64'h0;
        messageCountNext = 16'h0;
    end else begin
        case (counter)
            5: begin
                sessionIDNext[31:0] = dataIn[63:32];
            end
            6: begin
                sessionIDNext[79:32] = dataIn[47:0];
                sequenceNumberNext[15:0] = dataIn[63:48];
					 //sequenceNumberNext = dataIn >> 48;
            end
            7: begin
                sequenceNumberNext[63:16] = dataIn[47:0];
					 //sequenceNumberNext = (dataIn << 15);
                messageCountNext = dataIn[63:48];
					 //messageCountNext = dataIn >> 48;
            end
        endcase
    end
end
    
endmodule

module udpDecoder (
    input clk, rst,
    input [63:0] dataIn,
    input [6:0] counter,
    output reg [15:0] srcPort,
    output reg [15:0] destPort,
    output reg [15:0] length,
    output reg [15:0] checksum
);

reg [15:0] srcPortNext;
reg [15:0] destPortNext;
reg [15:0] lengthNext;
reg [15:0] checksumNext;

always @(posedge clk) begin
    srcPort <= srcPortNext;
    destPort <= destPortNext;
    length <= lengthNext;
    checksum <= checksumNext;
end

always @* begin
    srcPortNext = srcPort;
    destPortNext = destPort;
    lengthNext = length;
    checksumNext = checksum;
    if (rst) begin
        srcPortNext = 16'h0;
        destPortNext = 16'h0;
        lengthNext = 16'h0;
        checksumNext = 16'h0;
    end else begin
        case (counter)
            4: begin
                srcPortNext = dataIn[47:32];
                destPortNext = dataIn[63:48];
            end
            5: begin
                lengthNext = dataIn[15:0];
                checksumNext = dataIn[31:16];
            end
        endcase
    end
end
    
endmodule
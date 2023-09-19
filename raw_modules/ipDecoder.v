module ipDecoder (
    input clk,
    input rst,
    input counter,
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
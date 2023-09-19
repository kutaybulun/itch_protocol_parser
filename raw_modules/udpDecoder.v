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
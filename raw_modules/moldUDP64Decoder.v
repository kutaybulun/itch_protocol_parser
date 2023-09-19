module moldUDP64Decoder (
    input clk, rst,
    input [63:0] dataIn,
    input counter,
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
            end
            7: begin
                sequenceNumberNext[63:16] = dataIn[47:0];
                messageCountNext = dataIn[63:48];
            end
        endcase
    end
end
    
endmodule
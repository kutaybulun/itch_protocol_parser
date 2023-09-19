`timescale 1ns / 1ps
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
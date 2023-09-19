`define R 8'b01010010
`define L 8'b01001100
`define O 8'b01001111
`define A 8'b01000001
`define F 8'b01000110
`define E 8'b01000101
`define C 8'b01000011
`define D 8'b01000100
module itchMessageTypeDecoder ( 
    input clk, rst,
    input start,
    input [63:0] dataIn,
    input [1:0] counter,
    input [5:0] trackerIn,
    output [5:0] trackerOut,
    output reg startAddOrderNoMPID,
    output reg startAddOrderMPID,
    output reg startOrderExecuted,
    output reg startOrderExecutedWithPrice,
    output reg startOrderDelete,
    output reg startOrderBookDirectory,
    output reg startOrderBookState,
    output reg startTickSizeTableEntry,
    output reg [15:0] messageLength,
    output reg [7:0] messageType
);
// field registers
reg [15:0] messageLengthNext;
reg [7:0] messageTypeNext;
// transition registers
reg [5:0] tracker, trackerNext;
reg state, stateNext;
// valid registers
reg startAddOrderNoMPIDNext;
reg startAddOrderMPIDNext;
reg startOrderExecutedNext;
reg startOrderExecutedWithPriceNext;
reg startOrderDeleteNext;
reg startOrderBookDirectoryNext;
reg startOrderBookStateNext;
reg startTickSizeTableEntryNext;

assign trackerOut = trackerNext;

always @(posedge clk) begin
    // valid registers
    startAddOrderMPID <= startAddOrderMPIDNext;
    startAddOrderNoMPID <= startAddOrderNoMPIDNext;
    startOrderExecuted <= startOrderExecutedNext;
    startOrderExecutedWithPrice <= startOrderExecutedWithPriceNext;
    startOrderDelete <= startOrderDeleteNext;
    startOrderBookDirectory <= startOrderBookDirectoryNext;
    startOrderBookState <= startOrderBookStateNext;
    startTickSizeTableEntry <= startTickSizeTableEntryNext;
    // field registers
    messageType <= messageTypeNext;
    messageLength <= messageLengthNext;
    // transition registers
    tracker <= trackerNext;
    state <= stateNext;
end

always @* begin
    // valid registers
    startAddOrderNoMPIDNext = 0;
    startAddOrderMPIDNext = 0;
    startOrderExecutedNext = 0;
    startOrderExecutedWithPriceNext = 0;
    startOrderDeleteNext = 0;
    startOrderBookDirectoryNext = 0;
    startOrderBookStateNext = 0;
    startTickSizeTableEntryNext = 0;
    // transition registers
    stateNext = state;
    trackerNext = tracker;
    // field registers
    messageLengthNext = messageLength;
    messageTypeNext = messageType;
    if (rst) begin
        // transition registers
        trackerNext = trackerIn;
        stateNext = 0;
        // field registers
        messageLengthNext = 0;
        messageTypeNext = 0;
        // valid registers
        startAddOrderNoMPIDNext = 0;
        startAddOrderMPIDNext = 0;
        startOrderExecutedNext = 0;
        startOrderExecutedWithPriceNext = 0;
        startOrderDeleteNext = 0;
        startOrderBookDirectoryNext = 0;
        startOrderBookStateNext = 0;
        startTickSizeTableEntryNext = 0;
    end else begin //message type is always reg out
        if (counter == 8) begin //wire out
            messageLengthNext = dataIn[15:0];
            messageTypeNext = dataIn[23:16];
            //trackerOut = 24;
				trackerNext = 24;
            case (messageTypeNext)
						8'b01010010: startOrderBookDirectoryNext = 1;
						8'b01001100: startTickSizeTableEntryNext = 1;
						8'b01001111: startOrderBookDirectoryNext = 1;
						8'b01000001: startAddOrderNoMPIDNext = 1;
						8'b01000110: startAddOrderMPIDNext = 1;
						8'b01000101: startOrderExecutedNext = 1;
						8'b01000011: startOrderExecutedWithPriceNext = 1;
						8'b01000100: startOrderDeleteNext = 1;
            endcase
        end
        if (start) begin
            if(64 - trackerIn >= 24) begin //wire out
                {messageTypeNext, messageLengthNext} = dataIn >> trackerIn;
                //trackerOut = trackerIn + 24;
					 trackerNext = trackerIn + 24;
            end
            else begin //reg out
                if(state == 0) begin
                    {messageTypeNext, messageLengthNext} = dataIn >> trackerIn;
                    stateNext = 1;
                    trackerNext = trackerIn + 24;
                    //trackerOut = trackerIn + 24;
                    case (messageTypeNext)
                        8'b01010010: startOrderBookDirectoryNext = 1;
                        8'b01001100: startTickSizeTableEntryNext = 1;
                        8'b01001111: startOrderBookDirectoryNext = 1;
                        8'b01000001: startAddOrderNoMPIDNext = 1;
                        8'b01000110: startAddOrderMPIDNext = 1;
                        8'b01000101: startOrderExecutedNext = 1;
                        8'b01000011: startOrderExecutedWithPriceNext = 1;
                        8'b01000100: startOrderDeleteNext = 1;
                    endcase
                end
                else if (state == 1) begin
                    {messageTypeNext, messageLengthNext} = {messageType, messageLength} + (dataIn << (24-1-tracker));
                    stateNext = 0;
                    //trackerOut = tracker;
                    case (messageTypeNext)
                        8'b01010010: startOrderBookDirectoryNext = 1;
                        8'b01001100: startTickSizeTableEntryNext = 1;
                        8'b01001111: startOrderBookDirectoryNext = 1;
                        8'b01000001: startAddOrderNoMPIDNext = 1;
                        8'b01000110: startAddOrderMPIDNext = 1;
                        8'b01000101: startOrderExecutedNext = 1;
                        8'b01000011: startOrderExecutedWithPriceNext = 1;
                        8'b01000100: startOrderDeleteNext = 1;
                    endcase
                end
            end
        end
    end
end
    
endmodule
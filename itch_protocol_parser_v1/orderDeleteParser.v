module orderDeleteParser ( // always signal to end one clock cycle before actual END. also assign trackerOut one cycle before actual END.
    input clk, rst,
    input [63:0] dataIn,
    input [5:0] trackerIn,
    input startOrderDelete,
    output reg signal_end,
    output reg [31:0] timeStamp,
    output reg [63:0] orderID,
    output reg [31:0] orderBookID,
    output reg [7:0] side,
    output reg [5:0] trackerOut
);

// transition registers
reg [1:0] counter, counterNext;
reg [5:0] tracker, trackerNext;
// field registers
reg [31:0] timeStampNext;
reg [63:0] orderIDNext;
reg [31:0] orderBookIDNext;
reg [7:0] sideNext;
// valid registers
reg timeStampValid, timeStampValidNext;
reg orderIDValid, orderIDValidNext;
reg orderBookIDValid, orderBookIDValidNext;
reg sideValid, sideValidNext;

always @(posedge clk) begin
    // transition registers
    counter <= counterNext;
    tracker <= trackerNext;
    // field registers
    timeStamp <= timeStampNext;
    orderID <= orderIDNext;
    orderBookID <= orderBookIDNext;
    side <= sideNext;
    // valid registers
    timeStampValid <= timeStampValidNext;
    orderBookIDValid <= orderBookIDValidNext;
    orderIDValid <= orderIDValidNext;
    sideValid <= sideValidNext;
end

always @* begin
    // transition registers
    counterNext = counter;
    trackerNext = tracker;
    signal_end = 0;
    // field registers
    timeStampNext = timeStamp;
    orderIDNext = orderID;
    orderBookIDNext = orderBookID;
    sideNext = side;
    // valid registers
    timeStampValidNext = timeStampValid;
    orderBookIDValidNext = orderBookIDValid;
    orderIDValidNext = orderIDValid;
    sideValidNext = sideValid;
    if (rst) begin
        // transition registers
        counterNext = 0;
        trackerNext = trackerIn;
        signal_end = 0;
        // field registers
        timeStampNext = 32'h0;
        orderIDNext = 64'h0;
        orderBookIDNext = 32'h0;
        sideNext = 8'h0;
        // valid registers
        timeStampValidNext = 0;
        orderBookIDValidNext = 0;
        orderIDValidNext = 0;
        sideValidNext = 0;
    end 
    else begin
        case (counter)
            0: begin
                if (trackerIn == 0) begin
                    {orderIDNext[31:0], timeStampNext} = dataIn;
                    timeStampValidNext = 1;
                    trackerNext = trackerIn;
                end
                else begin
                    {orderIDNext[31:0], timeStampNext} = dataIn >> trackerIn;
                    trackerNext = trackerIn;
                end
                counterNext = counter + 1;
            end
            1: begin
                if (startOrderDelete) begin
                    if (timeStampValid) begin
                        {orderBookIDNext, orderIDNext[63:32]} = dataIn;
                        orderIDValidNext = 1;
                        orderBookIDValidNext = 1;
                        //SIGNAL TO END.
                        trackerOut = 8;
                        signal_end = 1;
                    end
                    else begin
                        {orderIDNext[31:0], timeStampNext} = {orderID[31:0], timeStamp} + (dataIn << (64-1-tracker));
                        timeStampValidNext = 1;
                        {orderBookIDNext, orderIDNext[63:32]} = dataIn >> tracker;
                        if (64 - tracker >= 8) begin
                            //SIGNAL TO END.
                            trackerOut = tracker + 8;
                            signal_end = 1;
                        end
                    end
                    counterNext = counter + 1;
                end
                else begin
                    counterNext = 0;
                end
            end
            2: begin
                if (orderBookIDValid) begin
                    sideNext = dataIn;
                    sideValidNext = 1;
                    counterNext = 0; //GO TO INITIAL STATE.
                end
                else begin
                    {orderBookIDNext, orderIDNext[63:32]} = {orderBookID, orderID[63:32]} + (dataIn << (64-1-tracker));
                    orderIDValidNext = 1;
                    orderBookIDValidNext = 1;
                    sideNext = dataIn >> tracker;
                    if (64 - tracker >= 8) begin
                        sideValidNext = 1;
                        counterNext = 0; //GO TO INITIAL STATE.
                    end
                    else begin
                        trackerNext = tracker + 8;
                        counterNext = counter + 1;
                        //SIGNAL TO END.
                        signal_end = 1;
                        trackerOut = tracker + 8;
                    end
                end
            end
            3: begin
                sideNext = side + (dataIn << (8-1-tracker));
                sideValidNext = 1;
                counterNext = 0; //GO TO INITIAL STATE.
            end 
        endcase
    end
end

endmodule

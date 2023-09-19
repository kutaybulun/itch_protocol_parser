module orderBookStateParser ( // always signal to end one clock cycle before actual END. also assign trackerOut one cycle before actual END.
    input clk, rst,
    input [63:0] dataIn,
    input startOrderBookState,
    input [5:0] trackerIn,
    output reg signal_end,
    output reg [5:0] trackerOut,
    output reg [31:0] timeStamp,
    output reg [31:0] orderBookID,
    output reg [159:0] stateName
);
// transition registers
reg [2:0] counter, counterNext;
reg [5:0] tracker, trackerNext;
// field registers
reg [31:0] timeStampNext;
reg [31:0] orderBookIDNext;
reg [159:0] stateNameNext;
// valid registers
reg timeStampValid, timeStampValidNext;
reg orderBookIDValid, orderBookIDValidNext;
reg stateNameValid1, stateNameValid1Next;
reg stateNameValid2, stateNameValid2Next;
reg stateNameValid3, stateNameValid3Next;

always @(posedge clk) begin
    // transition registers
    tracker <= trackerNext;
    counter <= counterNext;
    // field registers
    timeStamp <= timeStampNext;
    orderBookID <= orderBookIDNext;
    stateName <= stateNameNext;
    // valid registers
    timeStampValid <= timeStampValidNext;
    orderBookIDValid <= orderBookIDValidNext;
    stateNameValid1 <= stateNameValid1Next;
    stateNameValid2 <= stateNameValid2Next;
    stateNameValid3 <= stateNameValid3Next;
end

always @* begin
    // transition registers
    trackerNext = tracker;
    counterNext = counter;
    signal_end = 0;
    // field registers
    timeStampNext = timeStamp;
    orderBookIDNext = orderBookID;
    stateNameNext = stateName;
    // valid registers
    timeStampValidNext = timeStampValid;
    orderBookIDValidNext = orderBookIDValid;
    stateNameValid1Next = stateNameValid1;
    stateNameValid2Next = stateNameValid2;
    stateNameValid3Next = stateNameValid3;

    if (rst) begin
        // transition registers
        trackerNext = trackerIn;
        counterNext = 0;
        signal_end = 0;
        // field registers
        timeStampNext = 32'h0;
        orderBookIDNext = 64'h0;
        stateNameNext = 160'h0;
        // valid registers
        timeStampValidNext = 0;
        orderBookIDValidNext = 0;
        stateNameValid1Next = 0;
        stateNameValid2Next = 0;
        stateNameValid3Next = 0;
    end else begin
        case (counter)
            0: begin
                if(trackerIn == 0)begin
                    {orderBookIDNext, timeStampNext} = dataIn;
                    timeStampValidNext = 1;
                    orderBookIDValidNext = 1;
                end
                else begin
                    {orderBookIDNext, timeStampNext} = dataIn >> tracker;
                    trackerNext = trackerIn + 64;
                end
                counterNext = counter + 1; 
            end
            1: begin
                if(startOrderBookState) begin
                    if(orderBookIDValid) begin
                        stateNameNext[63:0] = dataIn;
                        stateNameValid1Next = 1;
                    end
                    else begin
                        {orderBookIDNext, timeStampNext} = {orderBookID, timeStamp} + (dataIn << (64-1-tracker));
                        timeStampValidNext = 1;
                        orderBookIDValidNext = 1;
                        stateNameNext[63:0] = dataIn >> tracker;
                        trackerNext = tracker + 64;
                    end
                    counterNext = counter + 1;
                end
                else begin
                    counterNext = 0;
                end
            end
            2: begin
                if(stateNameValid1) begin
                    stateNameNext[127:64] = dataIn;
                    stateNameValid2Next = 1;
                    //SIGNAL TO END.
                    trackerOut = 32;
                    signal_end = 1;
                end
                else begin
                    stateNameNext[63:0] = stateName[63:0] + (dataIn << (64-1-tracker));
                    stateNameValid1Next = 1;
                    stateNameNext[127:64] = dataIn >> tracker;
                    if(64 - tracker >= 32) begin
                        //SIGNAL TO END.
                        trackerOut = tracker + 32;
                        signal_end = 1; 
                    end
                end
                counterNext = counter + 1;
            end 
            3: begin
                if (stateNameValid2) begin
                    stateNameNext[159:128] = dataIn;
                    stateNameValid3Next = 1;
                    counterNext = 0; //GO TO INITIAL STATE.
                end
                else begin
                    stateNameNext[127:64] = stateName[127:64] + (dataIn << (64-1-tracker));
                    stateNameValid2Next = 1;
                    if(64 - tracker >= 32) begin
                        stateNameNext[159:128] = dataIn >> tracker;
                        stateNameValid3Next = 1;
                        counterNext = 0; //GO TO INITIAL STATE.
                    end
                    else begin
                        stateNameNext[159:128] = dataIn >> tracker;
                        trackerNext = tracker + 32;
                        counterNext = counter + 1;
                        //SIGNAL TO END.
                        signal_end = 1;
                        trackerOut = tracker + 32;
                    end
                end
            end
            4: begin
                stateNameNext[159:128] = stateName[159:128] + (dataIn << (64-1-tracker));
                stateNameValid3Next = 1;
                counterNext = 0; //GO TO INITIAL STATE.
            end
        endcase
    end
end

endmodule

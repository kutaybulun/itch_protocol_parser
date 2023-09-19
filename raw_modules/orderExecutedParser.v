module orderExecutedParser (  // always signal to end one clock cycle before actual END. also assign trackerOut one cycle before actual END.
    input clk, rst,
    input [63:0] dataIn,
    input startOrderExecuted,
    input [5:0] trackerIn,
    output reg signal_end,
    output reg [5:0] trackerOut,
    output reg [31:0] timeStamp,
    output reg [63:0] orderID,
    output reg [31:0] orderBookID,
    output reg [7:0] side,
    output reg [63:0] executedQuantity,
    output reg [63:0] matchID,
    output reg [31:0] comboGroupID,
    output reg [31:0] reservedOne,
    output reg [31:0] reservedTwo
);
// transition registers
reg [2:0] counter, counterNext;
reg [5:0] tracker, trackerNext;
// field registers
reg [31:0] timeStampNext;
reg [63:0] orderIDNext;
reg [31:0] orderBookIDNext;
reg [7:0] sideNext;
reg [63:0] executedQuantityNext;
reg [63:0] matchIDNext;
reg [31:0] comboGroupIDNext;
reg [31:0] reservedOneNext;
reg [31:0] reservedTwoNext;
// valid registers
reg timeStampValid, timeStampValidNext;
reg orderIDValid, orderIDValidNext;
reg orderBookIDValid, orderBookIDValidNext;
reg sideValid, sideValidNext;
reg executedQuantityValid, executedQuantityValidNext;
reg matchIDValid, matchIDValidNext;
reg comboGroupIDValid, comboGroupIDValidNext;
reg reservedOneValid, reservedOneValidNext;
reg reservedTwoValid, reservedTwoValidNext;

always @(posedge clk) begin
    // transition registers
    tracker <= trackerNext;
    counter <= counterNext;
    // field registers
    timeStamp <= timeStampNext;
    orderID <= orderIDNext;
    orderBookID <= orderBookIDNext;
    side <= sideNext;
    executedQuantity <= executedQuantityNext;
    matchID <= matchIDNext;
    comboGroupID <= comboGroupIDNext;
    reservedOne <= reservedOneNext;
    reservedTwo <= reservedTwoNext;
    // valid registers
    timeStampValid <= timeStampValidNext;
    orderIDValid <= orderIDValidNext;
    orderBookIDValid <= orderBookIDValidNext;
    sideValid <= sideValidNext;
    executedQuantityValid <= executedQuantityValidNext;
    matchIDValid <= matchIDValidNext;
    comboGroupIDValid <= comboGroupIDValidNext;
    reservedOneValid <= reservedOneValidNext;
    reservedTwoValid <= reservedTwoValidNext;
end

always @* begin
    // transition registers
    trackerNext = tracker;
    counterNext = counter;
    signal_end = 0;
    // field registers
    timeStampNext = timeStamp;
    orderIDNext = orderID;
    orderBookIDNext = orderBookID;
    sideNext = side;
    executedQuantityNext = executedQuantity;
    matchIDNext = matchID;
    comboGroupIDNext = comboGroupID;
    reservedOneNext = reservedOne;
    reservedTwoNext = reservedTwo;
    // valid registers
    timeStampValidNext = timeStampValid;
    orderIDValidNext = orderIDValid;
    orderBookIDValidNext = orderBookIDValid;
    sideValidNext = sideValid;
    executedQuantityValidNext = executedQuantityValid;
    matchIDValidNext = matchIDValid;
    comboGroupIDValidNext = comboGroupIDValid;
    reservedOneValidNext = reservedOneValid;
    reservedTwoValidNext = reservedTwoValid;
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
        executedQuantityNext = 64'h0;
        matchIDNext = 64'h0;
        comboGroupIDNext = 32'h0;
        reservedOneNext = 32'h0;
        reservedTwoNext = 32'h0;
        // valid registers
        timeStampValidNext = 0;
        orderIDValidNext = 0;
        orderBookIDValidNext = 0;
        sideValidNext = 0;
        executedQuantityValidNext = 0;
        matchIDValidNext = 0;
        comboGroupIDValidNext = 0;
        reservedOneValidNext = 0;
        reservedTwoValidNext = 0;
    end else begin
        case (counter)
            0:begin
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
                if(startOrderExecuted) begin
                    if (timeStampValid) begin
                        {orderBookIDNext, orderIDNext[63:32]} = dataIn;
                        orderIDValidNext = 1;
                        orderBookIDValidNext = 1;
                    end
                    else begin
                        {orderIDNext[31:0], timeStampNext} = {orderID[31:0], timeStamp} + (dataIn << (64-1-tracker));
                        timeStampValidNext = 1;
                        {orderBookIDNext, orderIDNext[63:32]} = dataIn >> tracker;
                    end
                    counterNext = counter + 1;
                end
                else begin
                    counterNext = 0;
                end
            end
            2: begin
                if(orderBookIDValid) begin
                    {executedQuantityNext[55:0], sideNext} = dataIn;
                    sideValidNext = 1;
                end
                else begin
                    {orderBookIDNext, orderIDNext[63:32]} = {orderBookID, orderID[63:32]} + (dataIn << (64-1-tracker));
                    orderIDValidNext = 1;
                    orderBookIDValidNext = 1;
                    {executedQuantityNext[55:0], sideNext} = dataIn >> tracker;
                end
                counterNext = counter + 1;
            end
            3: begin
                if (sideValid) begin
                    {matchIDNext[55:0], executedQuantityNext[63:56]} = dataIn;
                    executedQuantityValidNext = 1;
                end
                else begin
                    {executedQuantityNext[55:0], sideNext} = {executedQuantity[55:0], side} + (dataIn << (64-1-tracker));
                    sideValidNext = 1;
                    {matchIDNext[55:0], executedQuantityNext[63:56]} = dataIn >> tracker;
                end
                counterNext = counter + 1;
            end
            4: begin
                if(executedQuantityValid) begin
                    {reservedOneNext[23:0], comboGroupIDNext, matchIDNext[63:56]} = dataIn;
                    matchIDValidNext = 1;
                    comboGroupIDValidNext = 1;
                    //SIGNAL TO END.
                    trackerOut = 40;
                    signal_end = 1;
                end
                else begin
                    {matchIDNext[55:0], executedQuantityNext[63:56]} = {matchID[55:0], executedQuantity[63:56]} + (dataIn << (64-1-tracker));
                    executedQuantityValidNext = 1;
                    {reservedOneNext[23:0], comboGroupIDNext, matchIDNext[63:56]} = dataIn >> tracker;
                    if (64 - tracker >= 40) begin
                        //SIGNAL TO END.
                        trackerOut = tracker + 40;
                        signal_end = 1;
                    end
                end
                counterNext = counter + 1;
            end
            5: begin
                if (comboGroupIDValid) begin
                    {reservedTwoNext, reservedOneNext[31:24]} = dataIn;
                    reservedOneValidNext = 1;
                    reservedTwoValidNext = 1;
                    counterNext = 0; //GO TO INITIAL STATE.
                end
                else begin
                    {reservedOneNext[23:0], comboGroupIDNext, matchIDNext[63:56]} = {reservedOne[23:0], comboGroupID, matchID[63:56]} + (dataIn << (64-1-tracker));
                    matchIDValidNext = 1;
                    comboGroupIDValidNext = 1;
                    {reservedTwoNext, reservedOneNext[31:24]} = dataIn >> tracker;
                    if (64 - tracker >= 40) begin
                        reservedOneValidNext = 1;
                        reservedTwoValidNext = 1;
                        counterNext = 0; //GO TO INITIAL STATE.
                    end
                    else begin
                        trackerNext = tracker + 40;
                        counterNext = counter + 1;
                        //SIGNAL TO END.
                        signal_end = 1;
                        trackerOut = tracker + 40;
                    end
                end
            end
            6: begin
                {reservedTwoNext, reservedOneNext[31:24]} = {reservedTwoNext, reservedOneNext[31:24]} + (dataIn << (40-1-tracker));
                reservedOneValidNext = 1;
                reservedTwoValidNext = 1;
                counterNext = 0; //GO TO INITIAL STATE.
            end
        endcase
    end
end

endmodule


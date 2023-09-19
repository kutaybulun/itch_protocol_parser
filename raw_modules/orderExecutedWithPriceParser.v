module orderExecutedWithPriceParser ( // always signal to end one clock cycle before actual END. also assign trackerOut one cycle before actual END.
    input clk, rst,
    input [63:0] dataIn,
    input startOrderExecutedWithPrice,
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
    output reg [31:0] reservedTwo,
    output reg [31:0] tradePrice,
    output reg [7:0] occuredAtCross,
    output reg [7:0] printable
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
reg [31:0] tradePriceNext;
reg [7:0] occuredAtCrossNext;
reg [7:0] printableNext;
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
reg tradePriceValid, tradePriceValidNext;
reg occuredAtCrossValid, occuredAtCrossValidNext;
reg printableValid, printableValidNext;

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
    tradePrice <= tradePriceNext;
    occuredAtCross <= occuredAtCrossNext;
    printable <= printableNext;
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
    tradePriceValid <= tradePriceValidNext;
    occuredAtCrossValid <= occuredAtCrossValidNext;
    printableValid <= printableValidNext;
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
    tradePriceNext = tradePrice;
    occuredAtCrossNext = occuredAtCross;
    printableNext = printable;
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
    tradePriceValidNext = tradePriceValid;
    occuredAtCrossValidNext = occuredAtCrossValid;
    printableValidNext = printableValid;

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
        tradePriceNext = 32'h0;
        occuredAtCrossNext = 8'h0;
        printableNext = 8'h0;
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
        tradePriceValidNext = 0;
        occuredAtCrossValidNext = 0;
        printableValidNext = 0;
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
                if(startOrderExecutedWithPrice) begin
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
                end
                else begin
                    {matchIDNext[55:0], executedQuantityNext[63:56]} = {matchID[55:0], executedQuantity[63:56]} + (dataIn << (64-1-tracker));
                    executedQuantityValidNext = 1;
                    {reservedOneNext[23:0], comboGroupIDNext, matchIDNext[63:56]} = dataIn >> tracker;
                end
                counterNext = counter + 1;
            end
            5: begin
                if (comboGroupIDValid) begin
                    {tradePriceNext[23:0], reservedTwoNext, reservedOneNext[31:24]} = dataIn;
                    reservedOneValidNext = 1;
                    reservedTwoValidNext = 1;
                    //SIGNAL TO END.
                    signal_end = 1;
                    trackerOut = 24;
                end
                else begin
                    {reservedOneNext[23:0], comboGroupIDNext, matchIDNext[63:56]} = {reservedOne[23:0], comboGroupID, matchID[63:56]} + (dataIn << (64-1-tracker));
                    matchIDValidNext = 1;
                    comboGroupIDValidNext = 1;
                    {tradePriceNext[23:0], reservedTwoNext, reservedOneNext[31:24]} = dataIn >> tracker;
                    if (64 - tracker >= 24) begin
                        //SIGNAL TO END.
                        signal_end = 1;
                        trackerOut = tracker + 24;                
                    end
                end
                counterNext = counter + 1;
            end
            6: begin
                if (reservedTwoValid) begin
                    {printableNext, occuredAtCrossNext, tradePriceNext[31:24]} = dataIn;
                    tradePriceValidNext = 1;
                    occuredAtCrossValidNext = 1;
                    printableValidNext = 1;
                    counterNext = 0; //GO TO INITIAL STATE.
                end
                else begin
                    {tradePriceNext[23:0], reservedTwoNext, reservedOneNext[31:24]} = {tradePrice[23:0], reservedTwo, reservedOne[31:24]} + (dataIn << (64-1-tracker));
                    reservedOneValidNext = 1;
                    reservedTwoValidNext = 1;
                    {printableNext, occuredAtCrossNext, tradePriceNext[31:24]} = dataIn >> tracker;
                    if (64 - tracker >= 24) begin
                        tradePriceValidNext = 1;
                        occuredAtCrossValidNext = 1;
                        printableValidNext = 1;
                        counterNext = 0; //GO TO INITIAL STATE.
                    end
                    else begin
                        trackerNext = tracker + 24;
                        counterNext = counter + 1;
                        //SIGNAL TO END.
                        signal_end = 1;
                        trackerOut = tracker + 24;
                    end
                end
            end
            7: begin
                {printableNext, occuredAtCrossNext, tradePriceNext[31:24]} = {printable, occuredAtCross, tradePrice[31:24]} + (dataIn << (24-1-tracker));
                tradePriceValidNext = 1;
                occuredAtCrossValidNext = 1;
                printableValidNext = 1;
                counterNext = 0; //GO TO INITIAL STATE.
            end
        endcase
    end
end

endmodule
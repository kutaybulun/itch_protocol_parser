module addOrderNoMPIDparser ( // always signal to end one clock cycle before actual END. also assign trackerOut one cycle before actual END.
    input clk, rst,
    input [63:0] dataIn,
    input startAddOrderNoMPID,
    input [5:0] trackerIn,
    output reg signal_end,
    output reg [5:0] trackerOut,
    output reg [31:0] timeStamp,
    output reg [63:0] orderID,
    output reg [31:0] orderBookID,
    output reg [7:0] side,
    output reg [31:0] orderBookPosition,
    output reg [63:0] quantity,
    output reg [31:0] price,
    output reg [15:0] orderAttributes,
    output reg [7:0] lotType
);
// transition registers
reg [2:0] counter, counterNext;
reg [5:0] tracker, trackerNext;
// field registers
reg [31:0] timeStampNext;
reg [63:0] orderIDNext;
reg [31:0] orderBookIDNext;
reg [7:0] sideNext;
reg [31:0] orderBookPositionNext;
reg [63:0] quantityNext;
reg [31:0] priceNext;
reg [15:0] orderAttributesNext;
reg [7:0] lotTypeNext;
// valid registers
reg timeStampValid, timeStampValidNext;
reg orderIDValid, orderIDValidNext;
reg orderBookIDValid, orderBookIDValidNext;
reg sideValid, sideValidNext;
reg orderBookPositionValid, orderBookPositionValidNext;
reg quantityValid, quantityValidNext;
reg priceValid, priceValidNext;
reg orderAttributesValid, orderAttributesValidNext;
reg lotTypeValid, lotTypeValidNext;

always @(posedge clk) begin
    // transition registers
    tracker <= trackerNext;
    counter <= counterNext;
    // field registers
    timeStamp <= timeStampNext;
    orderID <= orderIDNext;
    orderBookID <= orderBookIDNext;
    side <= sideNext;
    orderBookPosition <= orderBookPositionNext;
    quantity <= quantityNext;
    price <= priceNext;
    orderAttributes <= orderAttributesNext;
    lotType <= lotTypeNext;
    // valid registers
    timeStampValid <= timeStampValidNext;
    orderIDValid <= orderIDValidNext;
    orderBookIDValid <= orderBookIDValidNext;
    sideValid <= sideValidNext;
    orderBookPositionValid <= orderBookPositionValidNext;
    quantityValid <= quantityValidNext;
    priceValid <= priceValidNext;
    orderAttributesValid <= orderAttributesValidNext;
    lotTypeValid <= lotTypeValidNext;
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
    orderBookPositionNext = orderBookPosition;
    quantityNext = quantity;
    priceNext = price;
    orderAttributesNext = orderAttributes;
    lotTypeNext = lotType;
    // valid registers
    timeStampValidNext = timeStampValid;
    orderIDValidNext = orderIDValid;
    orderBookIDValidNext = orderBookIDValid;
    sideValidNext = sideValid;
    orderBookPositionValidNext = orderBookPositionValid;
    quantityValidNext = quantityValid;
    priceValidNext = priceValid;
    orderAttributesValidNext = orderAttributesValid;
    lotTypeValidNext = lotTypeValid;

    if (rst) begin
        // transition registers
        counterNext = 0;
        trackerNext = trackerIn;
        signal_end = 0;
        // field registers
        timeStampNext = 32'h0;
        orderIDNext = 64'h0;
        orderBookIDNext = 32'h0;
        sideNext = 0;
        orderBookPositionNext = 32'h0;
        quantityNext = 64'h0;
        priceNext = 32'h0;
        orderAttributesNext = 16'h0;
        lotTypeNext = 0;
    // valid registers
        timeStampValidNext = 0;
        orderIDValidNext = 0;
        orderBookIDValidNext = 0;
        sideValidNext = 0;
        orderBookPositionValidNext = 0;
        quantityValidNext = 0;
        priceValidNext = 0;
        orderAttributesValidNext = 0;
        lotTypeValidNext = 0;
    end else begin
        case (counter)
            0:begin
                if (trackerIn == 0) begin
                    {orderIDNext[31:0], timeStampNext} = dataIn;
                    timeStampValidNext = 1;
                end
                else begin
                    {orderIDNext[31:0], timeStampNext} = dataIn >> trackerIn;
                    trackerNext = trackerIn;
                end
                counterNext = counter + 1;
            end
            1: begin
                if(startAddOrderNoMPID) begin
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
                if (orderIDValid) begin
                    {quantityNext[23:0], orderBookPositionNext, sideNext} = dataIn;
                    sideValidNext = 1;
                    orderBookPositionValidNext = 1;
                end
                else begin
                    {orderBookIDNext, orderIDNext[63:32]} = {orderBookID, orderID[63:32]} + (dataIn << (64-1-tracker));
                    orderIDValidNext = 1;
                    orderBookIDValidNext = 1;
                    {quantityNext[23:0], orderBookPositionNext, sideNext} = dataIn >> tracker;
                end
                counterNext = counter + 1;
            end
            3: begin
                if (sideValid) begin
                    {priceNext[23:0], quantityNext[63:24]} = dataIn;
                    quantityValidNext = 1;
                    //SIGNAL TO END.
                    trackerOut = 32;
                    signal_end = 1;
                end
                else begin
                    {quantityNext[23:0], orderBookPositionNext, sideNext} = {quantity[23:0], orderBookPosition, side} + (dataIn << (64-1-tracker));
                    sideValidNext = 1;
                    orderBookPositionValidNext = 1;
                    {priceNext[23:0], quantityNext[63:24]} = dataIn >> tracker;
                    if(64 - tracker >= 32) begin
                        //SIGNAL TO END.
                        trackerOut = tracker + 32; 
                        signal_end = 1;
                    end
                end
                counterNext = counter + 1;
            end
            4: begin
                if (quantityValid) begin
                    {lotTypeNext, orderAttributesNext, priceNext[31:24]} = dataIn;
                    priceValidNext = 1;
                    orderAttributesValidNext = 1;
                    lotTypeValidNext = 1;
                    counterNext = 0; //GO TO INITIAL STATE.
                end
                else begin
                    {priceNext[23:0], quantityNext[63:24]} = {price[23:0], quantity[63:24]} + (dataIn << (64-1-tracker));
                    quantityValidNext = 1;
                    {lotTypeNext, orderAttributesNext, priceNext[31:24]} = dataIn >> tracker;
                    if(64 - tracker >= 32) begin
                        priceValidNext = 1;
                        orderAttributesValidNext = 1;
                        lotTypeValidNext = 1;
                        counterNext = 0; //GO TO INITIAL STATE.
                    end
                    else begin
                        trackerNext = tracker + 32;
                        counterNext = counter + 1;
                        //SIGNAL TO END.
                        signal_end = 1;
                        trackerOut = tracker + 32;
                    end
                end
            end
            5: begin
                {lotTypeNext, orderAttributesNext, priceNext[31:24]} = {lotType, orderAttributes, price[31:24]} + (dataIn << (32-1-tracker));
                priceValidNext = 1;
                orderAttributesValidNext = 1;
                lotTypeValidNext = 1;
                counterNext = 0; //GO TO INITIAL STATE.
            end   
        endcase
    end
end
    
endmodule
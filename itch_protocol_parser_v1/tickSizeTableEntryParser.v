module tickSizeTableEntryParser (
    input clk, rst,
    input [63:0] dataIn,
    input startTickSizeTableEntry,
    input [5:0] trackerIn,
    output reg signal_end,
    output reg [5:0] trackerOut,
    output reg [31:0] timeStamp,
    output reg [31:0] orderBookID,
    output reg [63:0] tickSize,
    output reg [31:0] priceFrom,
    output reg [31:0] priceTo
);
// transition registers
reg [1:0] counter, counterNext;
reg [5:0] tracker, trackerNext;
// field registers
reg [31:0] timeStampNext;
reg [31:0] orderBookIDNext;
reg [63:0] tickSizeNext;
reg [31:0] priceFromNext;
reg [31:0] priceToNext;
// valid registers
reg timeStampValid, timeStampValidNext;
reg orderBookIDValid, orderBookIDValidNext;
reg tickSizeValid, tickSizeValidNext;
reg priceFromValid, priceFromValidNext;
reg priceToValid, priceToValidNext;

always @(posedge clk) begin
    // transition registers
    tracker <= trackerNext;
    counter <= counterNext;
    // field registers
    timeStamp <= timeStampNext;
    orderBookID <= orderBookIDNext;
    tickSize <= tickSizeNext;
    priceFrom <= priceFromNext;
    priceTo <= priceToNext;
    // valid registers
    timeStampValid <= timeStampValidNext;
    orderBookIDValid <= orderBookIDValidNext;
    tickSizeValid <= tickSizeValidNext;
    priceFromValid <= priceFromValidNext;
    priceToValid <= priceToValidNext;
end

always @* begin
    // transition registers
    trackerNext = tracker;
    counterNext = counter;
    signal_end = 0;
    // field registers
    timeStampNext = timeStamp;
    orderBookIDNext = orderBookID;
    tickSizeNext = tickSize;
    priceFromNext = priceFrom;
    priceToNext = priceTo;
    // valid registers
    timeStampValidNext = timeStampValid;
    orderBookIDValidNext = orderBookIDValid;
    tickSizeValidNext = tickSizeValid;
    priceFromValidNext = priceFromValid;
    priceToValidNext = priceToValid;

    if (rst) begin
        // transition registers
        counterNext = 0;
        trackerNext = trackerIn;
        signal_end = 0;
        // field registers
        timeStampNext = 32'h0;
        orderBookIDNext = 64'h0;
        tickSizeNext = 64'h0;
        priceFromNext = 32'h0;
        priceToNext = 32'h0;
        // valid registers
        timeStampValidNext = 0;
        orderBookIDValidNext = 0;
        tickSizeValidNext = 0;
        priceFromValidNext = 0;
        priceToValidNext = 0;
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
                if(startTickSizeTableEntry) begin
                    if(orderBookIDValid) begin
                        tickSizeNext = dataIn;
                        tickSizeValidNext = 1;
                        //SIGNAL TO END.
                        trackerOut = 0;
                        signal_end = 1;
                    end
                    else begin
                        {orderBookIDNext, timeStampNext} = {orderBookID, timeStamp} + (dataIn << (64-1-tracker));
                        timeStampValidNext = 1;
                        orderBookIDValidNext = 1;
                        tickSizeNext = dataIn >> tracker;
                        trackerNext = tracker + 64;
                    end
                    counterNext = counter + 1;
                end
                else begin
                    counterNext = 0;
                end
            end
            2: begin
                if (tickSizeValid) begin
                    {priceToNext, priceFromNext} = dataIn;
                    priceFromValidNext = 1;
                    priceToValidNext = 1;
                    counterNext = 0; //GO TO INITAL STATE.
                end
                else begin
                    tickSizeNext = tickSize + (dataIn << (64-1-tracker));
                    tickSizeValidNext = 1;
                    {priceToNext, priceFromNext} = dataIn >> tracker;
                    trackerNext = tracker + 64;
                    counterNext = counter + 1;
                    //SIGNAL TO END.
                    trackerOut = tracker + 64;
                    signal_end = 1;
                end
            end
            3: begin
                {priceToNext, priceFromNext} = {priceTo, priceFrom} + (dataIn << (64-1-tracker));
                priceFromValidNext = 1;
                priceToValidNext = 1;
                counterNext = 0; //GO TO INITAL STATE.
            end 
        endcase
    end
end
    
endmodule

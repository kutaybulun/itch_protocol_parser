module orderBookDirectoryParser (
    input clk, rst,
    input [63:0] dataIn,
    input startOrderBookDirectory,
    input [5:0] trackerIn,
    output reg signal_end,
    output reg [5:0] trackerOut,
    output reg [31:0] timeStamp,
    output reg [31:0] orderBookID,
    output reg [255:0] symbol,
    output reg [255:0] longName,
    output reg [95:0] ISIN,
    output reg [7:0] financialProduct,
    output reg [23:0] tradingCurrency,
    output reg [15:0] numberOfDecimalsInPrice,
    output reg [15:0] numberOfDecimalsInNominalValue,
    output reg [31:0] oddLotSize,
    output reg [31:0] roundLotSize,
    output reg [31:0] blockLotSize,
    output reg [63:0] nominalValue,
    output reg [7:0] numberOfLegs,
    output reg [31:0] underlyingOrderBookID,
    output reg [31:0] expirationDate,
    output reg [15:0] numberOfDecimalsInStrikePrice,
    output reg [7:0] putOrCall
);
// transition registers
reg [4:0] counter, counterNext;
reg [5:0] tracker, trackerNext;
// field registers
reg [31:0] timeStampNext;
reg [31:0] orderBookIDNext;
reg [255:0] symbolNext;
reg [255:0] longNameNext;
reg [95:0] ISINNext;
reg [7:0] financialProductNext;
reg [23:0] tradingCurrencyNext;
reg [15:0] numberOfDecimalsInPriceNext;
reg [15:0] numberOfDecimalsInNominalValueNext;
reg [31:0] oddLotSizeNext;
reg [31:0] roundLotSizeNext;
reg [31:0] blockLotSizeNext;
reg [63:0] nominalValueNext;
reg [7:0] numberOfLegsNext;
reg [31:0] underlyingOrderBookIDNext;
reg [31:0] expirationDateNext;
reg [15:0] numberOfDecimalsInStrikePriceNext;
reg [7:0] putOrCallNext;
// valid registers
reg timeStampValid, timeStampValidNext;
reg orderBookIDValid, orderBookIDValidNext;
reg symbolValid1, symbolValid1Next, symbolValid2, symbolValid2Next, symbolValid3, symbolValid3Next, symbolValid4, symbolValid4Next;
reg longNameValid1, longNameValid1Next, longNameValid2, longNameValid2Next, longNameValid3, longNameValid3Next, longNameValid4, longNameValid4Next;
reg ISINValid1, ISINValid1Next, ISINValid2, ISINValid2Next;
reg financialProductValid, financialProductValidNext;
reg tradingCurrencyValid, tradingCurrencyValidNext;
reg numberOfDecimalsInPriceValid, numberOfDecimalsInPriceValidNext;
reg numberOfDecimalsInNominalValueValid, numberOfDecimalsInNominalValueValidNext;
reg oddLotSizeValid, oddLotSizeValidNext;
reg roundLotSizeValid, roundLotSizeValidNext;
reg blockLotSizeValid, blockLotSizeValidNext;
reg nominalValueValid, nominalValueValidNext;
reg numberOfLegsValid, numberOfLegsValidNext;
reg underlyingOrderBookIDValid, underlyingOrderBookIDValidNext;
reg expirationDateValid, expirationDateValidNext;
reg numberOfDecimalsInStrikePriceValid, numberOfDecimalsInStrikePriceValidNext;
reg putOrCallValid, putOrCallValidNext;

always @(posedge clk) begin
    // transition registers
    tracker <= trackerNext;
    counter <= counterNext;
    // field registers
    timeStamp <= timeStampNext;
    orderBookID <= orderBookIDNext;
    symbol <= symbolNext;
    longName <= longNameNext;
    ISIN <= ISINNext;
    financialProduct <= financialProductNext;
    tradingCurrency <= tradingCurrencyNext;
    numberOfDecimalsInPrice <= numberOfDecimalsInPriceNext;
    numberOfDecimalsInNominalValue <= numberOfDecimalsInNominalValueNext;
    oddLotSize <= oddLotSizeNext;
    roundLotSize <= roundLotSizeNext;
    blockLotSize <= blockLotSizeNext;
    nominalValue <= nominalValueNext;
    numberOfLegs <= numberOfLegsNext;
    underlyingOrderBookID <= underlyingOrderBookIDNext;
    expirationDate <= expirationDateNext;
    numberOfDecimalsInStrikePrice <= numberOfDecimalsInStrikePriceNext;
    putOrCall <= putOrCallNext;
    // valid registers
    timeStampValid <= timeStampValidNext;
    orderBookIDValid <= orderBookIDValidNext;
    symbolValid1 <= symbolValid1Next;
    symbolValid2 <= symbolValid2Next;
    symbolValid3 <= symbolValid3Next;
    symbolValid4 <= symbolValid4Next;
    longNameValid1 <= longNameValid1Next;
    longNameValid2 <= longNameValid2Next;
    longNameValid3 <= longNameValid3Next;
    longNameValid4 <= longNameValid4Next;
    ISINValid1 <= ISINValid1Next;
    ISINValid2 <= ISINValid2Next;
    financialProductValid <= financialProductValidNext;
    tradingCurrencyValid <= tradingCurrencyValidNext;
    numberOfDecimalsInPriceValid <= numberOfDecimalsInPriceValidNext;
    numberOfDecimalsInNominalValueValid <= numberOfDecimalsInNominalValueValidNext;
    oddLotSizeValid <= oddLotSizeValidNext;
    roundLotSizeValid <= roundLotSizeValidNext;
    blockLotSizeValid <= blockLotSizeValidNext;
    nominalValueValid <= nominalValueValidNext;
    numberOfLegsValid <= numberOfLegsValidNext;
    underlyingOrderBookIDValid <= underlyingOrderBookIDValidNext;
    expirationDateValid <= expirationDateValidNext;
    numberOfDecimalsInStrikePriceValid <= numberOfDecimalsInStrikePriceValidNext;
    putOrCallValid <= putOrCallValidNext;
end

always @* begin
    // transition registers
    trackerNext = tracker;
    counterNext = counter;
    signal_end = 0;
    // field registers
    timeStampNext = timeStamp;
    orderBookIDNext = orderBookID;
    symbolNext = symbol;
    longNameNext = longName;
    ISINNext = ISIN;
    financialProductNext = financialProduct;
    tradingCurrencyNext = tradingCurrency;
    numberOfDecimalsInPriceNext = numberOfDecimalsInPrice;
    numberOfDecimalsInNominalValueNext = numberOfDecimalsInNominalValue;
    oddLotSizeNext = oddLotSize;
    roundLotSizeNext = roundLotSize;
    blockLotSizeNext = blockLotSize;
    nominalValueNext = nominalValue;
    numberOfLegsNext = numberOfLegs;
    underlyingOrderBookIDNext = underlyingOrderBookID;
    expirationDateNext = expirationDate;
    numberOfDecimalsInStrikePriceNext = numberOfDecimalsInStrikePrice;
    putOrCallNext = putOrCall;
    // valid registers
    timeStampValidNext = timeStampValid;
    orderBookIDValidNext = orderBookIDValid;
    symbolValid1Next = symbolValid1;
    symbolValid2Next = symbolValid2;
    symbolValid3Next = symbolValid3;
    symbolValid4Next = symbolValid4;
    longNameValid1Next = longNameValid1;
    longNameValid2Next = longNameValid2;
    longNameValid3Next = longNameValid3;
    longNameValid4Next = longNameValid4;
    ISINValid1Next = ISINValid1;
    ISINValid2Next = ISINValid2;
    financialProductValidNext = financialProductValid;
    tradingCurrencyValidNext = tradingCurrencyValid;
    numberOfDecimalsInPriceValidNext = numberOfDecimalsInPriceValid;
    numberOfDecimalsInNominalValueValidNext = numberOfDecimalsInNominalValueValid;
    oddLotSizeValidNext = oddLotSizeValid;
    roundLotSizeValidNext = roundLotSizeValid;
    blockLotSizeValidNext = blockLotSizeValid;
    nominalValueValidNext = nominalValueValid;
    numberOfLegsValidNext = numberOfLegsValid;
    underlyingOrderBookIDValidNext = underlyingOrderBookIDValid;
    expirationDateValidNext = expirationDateValid;
    numberOfDecimalsInStrikePriceValidNext = numberOfDecimalsInStrikePriceValid;
    putOrCallValidNext = putOrCallValid;

    if(rst) begin
        // transition registers
        trackerNext = trackerIn;
        counterNext = 0;
        signal_end = 0;
        // field registers
        timeStampNext = 32'h0;
        orderBookIDNext = 32'h0;
        symbolNext = 256'h0;
        longNameNext = 256'h0;
        ISINNext = 96'h0;
        financialProductNext = 8'h0;
        tradingCurrencyNext = 24'h0;
        numberOfDecimalsInPriceNext = 16'h0;
        numberOfDecimalsInNominalValueNext = 16'h0;
        oddLotSizeNext = 32'h0;
        roundLotSizeNext = 32'h0;
        blockLotSizeNext = 32'h0;
        nominalValueNext = 64'h0;
        numberOfLegsNext = 8'h0;
        underlyingOrderBookIDNext = 32'h0;
        expirationDateNext = 32'h0;
        numberOfDecimalsInStrikePriceNext = 16'h0;
        putOrCallNext = 8'h0;
        // valid registers
        timeStampValidNext = 0;
        orderBookIDValidNext = 0;
        symbolValid1Next = 0;
        symbolValid2Next = 0;
        symbolValid3Next = 0;
        symbolValid4Next = 0;
        longNameValid1Next = 0;
        longNameValid2Next = 0;
        longNameValid3Next = 0;
        longNameValid4Next = 0;
        ISINValid1Next = 0;
        ISINValid2Next = 0;
        financialProductValidNext = 0;
        tradingCurrencyValidNext = 0;
        numberOfDecimalsInPriceValidNext = 0;
        numberOfDecimalsInNominalValueValidNext = 0;
        oddLotSizeValidNext = 0;
        roundLotSizeValidNext = 0;
        blockLotSizeValidNext = 0;
        nominalValueValidNext = 0;
        numberOfLegsValidNext = 0;
        underlyingOrderBookIDValidNext = 0;
        expirationDateValidNext = 0;
        numberOfDecimalsInStrikePriceValidNext = 0;
        putOrCallValidNext = 0;
    end
    else begin
        case (counter)
            0: begin
                if(startOrderBookDirectory) begin
                    if(trackerIn == 0) begin
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
            end
            1: begin
                if(startOrderBookDirectory) begin
                    if(orderBookIDValid) begin
                        symbolNext[63:0] = dataIn;
                        symbolValid1Next = 1;
                    end
                    else begin
                        {orderBookIDNext, timeStampNext} = {orderBookID, timeStamp} + (dataIn << (64-1-tracker));
                        timeStampValidNext = 1;
                        orderBookIDValidNext = 1;
                        symbolNext[63:0] = dataIn >> tracker;
                        trackerNext = tracker + 64;
                    end
                    counterNext = counter + 1;
                end
                else begin
                    counterNext = 0;
                end
            end 
            2: begin
                if(symbolValid1) begin
                    symbolNext[127:64] = dataIn;
                    symbolValid2Next = 1;
                end
                else begin
                    symbolNext[63:0] = symbol[63:0] + (dataIn << (64-1-tracker));
                    symbolValid1Next = 1;
                    symbolNext[127:64] = dataIn >> tracker;
                    trackerNext = tracker + 64;
                end
                counterNext = counter + 1;
            end
            3: begin
                if(symbolValid2) begin
                    symbolNext[191:128] = dataIn;
                    symbolValid3Next = 1;
                end
                else begin
                    symbolNext[127:64] = symbol[127:64] + (dataIn << (64-1-tracker));
                    symbolValid2Next = 1;
                    symbolNext[191:128] = dataIn >> tracker;
                    trackerNext = tracker + 64;
                end
                counterNext = counter + 1;
            end
            4: begin
                if(symbolValid3) begin
                    symbolNext[255:192] = dataIn;
                    symbolValid4Next = 1;
                end
                else begin
                    symbolNext[191:128] = symbol[191:128] + (dataIn << (64-1-tracker));
                    symbolValid3Next = 1;
                    symbolNext[255:192] = dataIn >> tracker;
                    trackerNext = tracker + 64;
                end
                counterNext = counter + 1;
            end
            5: begin
                if(symbolValid4) begin
                    longNameNext[63:0] = dataIn;
                    longNameValid1Next = 1;
                end
                else begin
                    symbolNext[255:192] = symbol[255:192] + (dataIn << (64-1-tracker));
                    symbolValid4Next = 1;
                    longNameNext[63:0] = dataIn >> tracker;
                    trackerNext = tracker + 64;
                end
                counterNext = counter + 1;
            end
            6: begin
                if (longNameValid1) begin
                    longNameNext[127:64] = dataIn;
                    longNameValid2Next = 1;
                end
                else begin
                    longNameNext[63:0] = longName[63:0] + (dataIn << (64-1-tracker));
                    longNameValid1Next = 1;
                    longNameNext[127:64] = dataIn >> tracker;
                    trackerNext = tracker + 64;
                end
                counterNext = counter + 1;
            end
            7: begin
                if (longNameValid2) begin
                    longNameNext[191:128] = dataIn;
                    longNameValid3Next = 1;
                end
                else begin
                    longNameNext[127:64] = longName[127:64] + (dataIn << (64-1-tracker));
                    longNameValid2Next = 1;
                    longNameNext[191:128] = dataIn >> tracker;
                    trackerNext = tracker + 64;
                end
                counterNext = counter + 1;
            end
            8: begin
                if (longNameValid3) begin
                    longNameNext[255:192] = dataIn;
                    longNameValid4Next = 1;
                end
                else begin
                    longNameNext[191:128] = longName[191:128] + (dataIn << (64-1-tracker));
                    longNameValid3Next = 1;
                    longNameNext[255:192] = dataIn >> tracker;
                    trackerNext = tracker + 64;
                end
                counterNext = counter + 1;
            end
            9: begin
                if (longNameValid4) begin
                    ISINNext[63:0] = dataIn;
                    ISINValid1Next = 1;
                end
                else begin
                    longNameNext[255:192] = longName[255:192] + (dataIn << (64-1-tracker));
                    longNameValid4Next = 1;
                    ISINNext[63:0] = dataIn >> tracker;
                    trackerNext = tracker + 64;
                end
                counterNext = counter + 1;
            end
            10: begin
                if(ISINValid1) begin
                    ISINNext[95:64] = dataIn[31:0];
                    ISINValid2Next = 1;
                    financialProductNext = dataIn[39:32];
                    financialProductValidNext = 1;
                    tradingCurrencyNext = dataIn[63:40];
                    tradingCurrencyValidNext = 1;
                end
                else begin
                    ISINNext[63:0] = ISIN[63:0] + (dataIn << (64-1-tracker));
                    {tradingCurrencyNext, financialProductNext, ISINNext[95:64]} = dataIn >> tracker; //might have to come up w sth else.
                    trackerNext = tracker + 64;
                end
                counterNext = counter + 1;
            end
            11: begin
                if(tradingCurrencyValid) begin
                    numberOfDecimalsInPriceNext = dataIn[15:0];
                    numberOfDecimalsInPriceValidNext = 1;
                    numberOfDecimalsInNominalValueNext = dataIn[31:16];
                    numberOfDecimalsInNominalValueValidNext = 1;
                    oddLotSizeNext = dataIn[63:32];
                    oddLotSizeValidNext = 1;
                end
                else begin
                    {tradingCurrencyNext, financialProductNext, ISINNext[95:64]} = {tradingCurrency, financialProduct, ISIN[95:64]} + (dataIn << (64-1-tracker));
                    ISINValid2Next = 1;
                    financialProductValidNext = 1;
                    tradingCurrencyValidNext = 1;
                    {oddLotSizeNext, numberOfDecimalsInNominalValueNext, numberOfDecimalsInPriceNext} = dataIn >> tracker;
                    trackerNext = tracker + 64;
                end
                counterNext = counter + 1;
            end
            12: begin
                if(oddLotSizeValid) begin
                    roundLotSizeNext = dataIn[31:0];
                    roundLotSizeValidNext = 1;
                    blockLotSizeNext = dataIn[63:32];
                    blockLotSizeValidNext = 1;
                end
                else begin
                    {oddLotSizeNext, numberOfDecimalsInNominalValueNext, numberOfDecimalsInPriceNext} = {oddLotSize, numberOfDecimalsInNominalValue, numberOfDecimalsInPrice} + (dataIn << (64-1-tracker));
                    numberOfDecimalsInPriceValidNext = 1;
                    numberOfDecimalsInNominalValueValidNext = 1;
                    oddLotSizeValidNext = 1;
                    {blockLotSizeNext, roundLotSizeNext} = dataIn >> tracker;
                    trackerNext = tracker + 64;
                end
                counterNext = counter + 1;
            end
            13: begin
                if (blockLotSizeValid) begin
                    nominalValueNext = dataIn;
                    nominalValueValidNext = 1;
                end
                else begin
                    {blockLotSizeNext, roundLotSizeNext} = {blockLotSize, roundLotSize} + (dataIn << (64-1-tracker));
                    roundLotSizeValidNext = 1;
                    blockLotSizeValidNext = 1;
                    nominalValueNext = dataIn >> tracker;
                    trackerNext = tracker + 64;
                end
                counterNext = counter + 1;
            end
            14: begin
                if (nominalValueValid) begin
                    numberOfLegsNext = dataIn[7:0];
                    numberOfLegsValidNext = 1;
                    underlyingOrderBookIDNext = dataIn[39:8];
                    underlyingOrderBookIDValidNext = 1;
                    expirationDateNext[23:0] = dataIn[63:40];
                    //SIGNAL TO END.
                    //TRACKER OUT = 31
                    trackerOut = 31;
                    signal_end = 1;
                end
                else begin
                    nominalValueNext = nominalValue + (dataIn << (64-1-tracker));
                    nominalValueValidNext = 1;
                    {expirationDateNext[23:0], underlyingOrderBookIDNext, numberOfLegsNext} = dataIn >> tracker;
                    trackerNext = tracker + 64;
                    if(64 - tracker >= 32) begin
                        //SIGNAL TO END.
                        //TRACKER OUT = tracker + 64 + 32
                        trackerOut = tracker + 32; 
                        signal_end = 1;
                    end
                end
                counterNext = counter + 1;
            end
            15: begin
                if (underlyingOrderBookIDValid) begin
                    expirationDateNext[31:24] = dataIn[7:0];
                    expirationDateValidNext = 1;
                    numberOfDecimalsInStrikePriceNext = dataIn[23:8];
                    numberOfDecimalsInStrikePriceValidNext = 1;
                    putOrCallNext = dataIn[31:24]; 
                    putOrCallValidNext = 1;
                    counterNext = 0; //go to initial state.
                end
                else begin
                    {expirationDateNext[23:0], underlyingOrderBookIDNext, numberOfLegsNext} = {expirationDate[23:0], underlyingOrderBookID, numberOfLegs} + (dataIn << (64-1-tracker));
                    numberOfLegsValidNext = 1;
                    underlyingOrderBookIDValidNext = 1;
                    if(64 - tracker >= 32) begin
                        {putOrCallNext, numberOfDecimalsInStrikePriceNext, expirationDateNext[31:24]} = dataIn >> tracker;
                        expirationDateValidNext = 1;
                        numberOfDecimalsInStrikePriceValidNext = 1;
                        putOrCallValidNext = 1;
                        counterNext = 0; //go to initial state.
                    end
                    else begin
                        {putOrCallNext, numberOfDecimalsInStrikePriceNext, expirationDateNext[31:24]} = dataIn >> tracker;
                        //SIGNAL TO END.
                        //TRACKER OUT = tracker + 32;
                        trackerNext = tracker + 64;
                        trackerOut = tracker + 32;
                        counterNext = counter + 1;
                        signal_end = 1;
                    end
                end
            end
            16: begin
                {putOrCallNext, numberOfDecimalsInStrikePriceNext, expirationDateNext[31:24]} = {putOrCall, numberOfDecimalsInStrikePrice, expirationDate[31:24]} + (dataIn << (32-1-tracker));
                expirationDateValidNext = 1;
                numberOfDecimalsInStrikePriceValidNext = 1;
                putOrCallValidNext = 1;
                counterNext = 0; //go to initial state.
            end
        endcase
    end
end

endmodule


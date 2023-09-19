module messageParserTop (
    input clk, rst,
    input [63:0] dataIn,
    input [6:0] counter
    //input [15:0] messageCount
);
//wires itchMessageTypeDecoder
wire startAddOrderNoMPID;
wire startAddOrderMPID;
wire startOrderExecuted;
wire startOrderExecutedWithPrice;
wire startOrderDelete;
wire startOrderBookDirectory;
wire startOrderBookState;
wire startTickSizeTableEntry;
wire [15:0] messageLength;
wire [7:0] messageType;
wire [5:0] trackerOutMessageTypeDecoder;
//wires orderBookDirectoryParser
wire obdp_signal_end;
wire [5:0] obdp_trackerOut;
wire [31:0] obdp_timeStamp;
wire [31:0] obdp_orderBookID;
wire [255:0] obdp_symbol;
wire [255:0] obdp_longName;
wire [95:0] obdp_ISIN;
wire [7:0] obdp_financialProduct;
wire [23:0] obdp_tradingCurrency;
wire [15:0] obdp_numberOfDecimalsInPrice;
wire [15:0] obdp_numberOfDecimalsInNominalValue;
wire [31:0] obdp_oddLotSize;
wire [31:0] obdp_roundLotSize;
wire [31:0] obdp_blockLotSize;
wire [63:0] obdp_nominalValue;
wire [7:0] obdp_numberOfLegs;
wire [31:0] obdp_underlyingOrderBookID;
wire [31:0] obdp_expirationDate;
wire [15:0] obdp_numberOfDecimalsInStrikePrice;
wire [7:0] obdp_putOrCall;
//wires tickSizeTableEntryParser
wire tstep_signal_end;
wire [5:0] tstep_trackerOut;
wire [31:0] tstep_timeStamp;
wire [31:0] tstep_orderBookID;
wire [63:0] tstep_tickSize;
wire [31:0] tstep_priceFrom;
wire [31:0] tstep_priceTo;
//wires orderBookStateParser
wire obsp_signal_end;
wire [5:0] obsp_trackerOut;
wire [31:0] obsp_timeStamp;
wire [31:0] obsp_orderBookID;
wire [159:0] obsp_stateName;
//wires addOrderMPIDparser
wire aomp_signal_end;
wire [5:0] aomp_trackerOut;
wire [31:0] aomp_timeStamp;
wire [63:0] aomp_orderID;
wire [31:0] aomp_orderBookID;
wire [7:0] aomp_side;
wire [31:0] aomp_orderBookPosition;
wire [63:0] aomp_quantity;
wire [31:0] aomp_price;
wire [15:0] aomp_orderAttributes;
wire [7:0] aomp_lotType;
wire [55:0] aomp_participantID;
//wires addOrderNoMPIDparser
wire aonmp_signal_end;
wire [5:0] aonmp_trackerOut;
wire [31:0] aonmp_timeStamp;
wire [63:0] aonmp_orderID;
wire [31:0] aonmp_orderBookID;
wire [7:0] aonmp_side;
wire [31:0] aonmp_orderBookPosition;
wire [63:0] aonmp_quantity;
wire [31:0] aonmp_price;
wire [15:0] aonmp_orderAttributes;
wire [7:0] aonmp_lotType;
//wires orderExecutedParser
wire oep_signal_end;
wire [5:0] oep_trackerOut;
wire [31:0] oep_timeStamp;
wire [63:0] oep_orderID;
wire [31:0] oep_orderBookID;
wire [7:0] oep_side;
wire [63:0] oep_executedQuantity;
wire [63:0] oep_matchID;
wire [31:0] oep_comboGroupID;
wire [31:0] oep_reservedOne;
wire [31:0] oep_reservedTwo;
//wires orderExecutedWithPriceParser
wire oewpp_signal_end;
wire [5:0] oewpp_trackerOut;
wire [31:0] oewpp_timeStamp;
wire [63:0] oewpp_orderID;
wire [31:0] oewpp_orderBookID;
wire [7:0] oewpp_side;
wire [63:0] oewpp_executedQuantity;
wire [63:0] oewpp_matchID;
wire [31:0] oewpp_comboGroupID;
wire [31:0] oewpp_reservedOne;
wire [31:0] oewpp_reservedTwo;
wire [31:0] oewpp_tradePrice;
wire [7:0] oewpp_occuredAtCross;
wire [7:0] oewpp_printable;
//wires orderDeleteParser
wire odp_signal_end;
wire [31:0] odp_timeStamp;
wire [63:0] odp_orderID;
wire [31:0] odp_orderBookID;
wire [7:0] odp_side;
wire [5:0] odp_trackerOut;
//comb. logic
reg [5:0] trackerIn_messageType;
reg start_messageType;
//module inst.
itchMessageTypeDecoder itchMessageTypeDecoder(
    .clk(clk),
    .rst(rst),
    .start(start_messageType), //TAKE CARE OF THIS DEPENDING ON WHICH MODULE ENDED
    .dataIn(dataIn),
    .counter(counter),
    .trackerIn(trackerIn_messageType), //TAKE CARE OF THIS DEPENDING ON WHICH MODULE ENDED
    .trackerOut(trackerOutMessageTypeDecoder),
    .startAddOrderNoMPID(startAddOrderNoMPID),
    .startAddOrderMPID(startAddOrderMPID),
    .startOrderExecuted(startOrderExecuted),
    .startOrderExecutedWithPrice(startOrderExecutedWithPrice),
    .startOrderDelete(startOrderDelete),
    .startOrderBookDirectory(startOrderBookDirectory),
    .startOrderBookState(startOrderBookState),
    .startTickSizeTableEntry(startTickSizeTableEntry),
    .messageLength(messageLength),
    .messageType(messageType)
);

orderBookDirectoryParser orderBookDirParser_inst (
    .clk(clk),
    .rst(rst),
    .dataIn(dataIn),
    .startOrderBookDirectory(startOrderBookDirectory),
    .trackerIn(trackerOutMessageTypeDecoder),
    .signal_end(obdp_signal_end),
    .trackerOut(obdp_trackerOut),
    .timeStamp(obdp_timeStamp),
    .orderBookID(obdp_orderBookID),
    .symbol(obdp_symbol),
    .longName(obdp_longName),
    .ISIN(obdp_ISIN),
    .financialProduct(obdp_financialProduct),
    .tradingCurrency(obdp_tradingCurrency),
    .numberOfDecimalsInPrice(obdp_numberOfDecimalsInPrice),
    .numberOfDecimalsInNominalValue(obdp_numberOfDecimalsInNominalValue),
    .oddLotSize(obdp_oddLotSize),
    .roundLotSize(obdp_roundLotSize),
    .blockLotSize(obdp_blockLotSize),
    .nominalValue(obdp_nominalValue),
    .numberOfLegs(obdp_numberOfLegs),
    .underlyingOrderBookID(obdp_underlyingOrderBookID),
    .expirationDate(obdp_expirationDate),
    .numberOfDecimalsInStrikePrice(obdp_numberOfDecimalsInStrikePrice),
    .putOrCall(obdp_putOrCall)
);

tickSizeTableEntryParser tickSizeParser_inst (
    .clk(clk),
    .rst(rst),
    .dataIn(dataIn),
    .startTickSizeTableEntry(startTickSizeTableEntry),
    .trackerIn(trackerOutMessageTypeDecoder),
    .signal_end(tstep_signal_end),
    .trackerOut(tstep_trackerOut),
    .timeStamp(tstep_timeStamp),
    .orderBookID(tstep_orderBookID),
    .tickSize(tstep_tickSize),
    .priceFrom(tstep_priceFrom),
    .priceTo(tstep_priceTo)
);

orderBookStateParser orderBookStateParser_inst (
    .clk(clk),
    .rst(rst),
    .dataIn(dataIn),
    .startOrderBookState(startOrderBookState),
    .trackerIn(trackerOutMessageTypeDecoder),
    .signal_end(obsp_signal_end),
    .trackerOut(obsp_trackerOut),
    .timeStamp(obsp_timeStamp),
    .orderBookID(obsp_orderBookID),
    .stateName(obsp_stateName)
);

addOrderMPIDparser addOrderMPIDparser_inst (
    .clk(clk),
    .rst(rst),
    .dataIn(dataIn),
    .startAddOrderMPID(startAddOrderMPID),
    .trackerIn(trackerOutMessageTypeDecoder),
    .signal_end(aomp_signal_end),
    .trackerOut(aomp_trackerOut),
    .timeStamp(aomp_timeStamp),
    .orderID(aomp_orderID),
    .orderBookID(aomp_orderBookID),
    .side(aomp_side),
    .orderBookPosition(aomp_orderBookPosition),
    .quantity(aomp_quantity),
    .price(aomp_price),
    .orderAttributes(aomp_orderAttributes),
    .lotType(aomp_lotType),
    .participantID(aomp_participantID)
);

addOrderNoMPIDparser addOrderNoMPIDparser_inst (
    .clk(clk),
    .rst(rst),
    .dataIn(dataIn),
    .startAddOrderNoMPID(startAddOrderNoMPID),
    .trackerIn(trackerOutMessageTypeDecoder),
    .signal_end(aonmp_signal_end),
    .trackerOut(aonmp_trackerOut),
    .timeStamp(aonmp_timeStamp),
    .orderID(aonmp_orderID),
    .orderBookID(aonmp_orderBookID),
    .side(aonmp_side),
    .orderBookPosition(aonmp_orderBookPosition),
    .quantity(aonmp_quantity),
    .price(aonmp_price),
    .orderAttributes(aonmp_orderAttributes),
    .lotType(aonmp_lotType)
);

orderExecutedParser orderExecutedParser_inst (
    .clk(clk),
    .rst(rst),
    .dataIn(dataIn),
    .startOrderExecuted(startOrderExecuted),
    .trackerIn(trackerOutMessageTypeDecoder),
    .signal_end(oep_signal_end),
    .trackerOut(oep_trackerOut),
    .timeStamp(oep_timeStamp),
    .orderID(oep_orderID),
    .orderBookID(oep_orderBookID),
    .side(oep_side),
    .executedQuantity(oep_executedQuantity),
    .matchID(oep_matchID),
    .comboGroupID(oep_comboGroupID),
    .reservedOne(oep_reservedOne),
    .reservedTwo(oep_reservedTwo)
);

orderExecutedWithPriceParser orderExecutedWithPriceParser_inst (
    .clk(clk),
    .rst(rst),
    .dataIn(dataIn),
    .startOrderExecutedWithPrice(startOrderExecutedWithPrice),
    .trackerIn(trackerOutMessageTypeDecoder),
    .signal_end(oewpp_signal_end),
    .trackerOut(oewpp_trackerOut),
    .timeStamp(oewpp_timeStamp),
    .orderID(oewpp_orderID),
    .orderBookID(oewpp_orderBookID),
    .side(oewpp_side),
    .executedQuantity(oewpp_executedQuantity),
    .matchID(oewpp_matchID),
    .comboGroupID(oewpp_comboGroupID),
    .reservedOne(oewpp_reservedOne),
    .reservedTwo(oewpp_reservedTwo),
    .tradePrice(oewpp_tradePrice),
    .occuredAtCross(oewpp_occuredAtCross),
    .printable(oewpp_printable)
);

orderDeleteParser orderDeleteParser_inst (
    .clk(clk),
    .rst(rst),
    .dataIn(dataIn),
    .trackerIn(trackerOutMessageTypeDecoder),
    .startOrderDelete(startOrderDelete),
    .signal_end(odp_signal_end),
    .timeStamp(odp_timeStamp),
    .orderID(odp_orderID),
    .orderBookID(odp_orderBookID),
    .side(odp_side),
    .trackerOut(odp_trackerOut)
);

always @(*) begin
    start_messageType = obdp_signal_end | tstep_signal_end | obsp_signal_end | aomp_signal_end | aonmp_signal_end | oep_signal_end | oewpp_signal_end | odp_signal_end;
    if (obdp_signal_end) begin
        trackerIn_messageType = obdp_trackerOut;
    end
    else if (tstep_signal_end) begin
        trackerIn_messageType = tstep_trackerOut;
    end
    else if (obsp_signal_end) begin
        trackerIn_messageType = obsp_trackerOut;
    end
    else if (aomp_signal_end) begin
        trackerIn_messageType = aomp_trackerOut;
    end
    else if (aonmp_signal_end) begin
        trackerIn_messageType = aonmp_trackerOut;
    end
    else if (oep_signal_end) begin
        trackerIn_messageType = oep_trackerOut;
    end
    else if (oewpp_signal_end) begin
        trackerIn_messageType = oewpp_trackerOut;
    end
    else if (odp_signal_end) begin
        trackerIn_messageType = odp_trackerOut;
    end
end

endmodule
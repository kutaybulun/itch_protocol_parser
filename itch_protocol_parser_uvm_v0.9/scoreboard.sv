class tb_scoreboard extends uvm_test;
`uvm_component_utils(tb_scoreboard)

uvm_analysis_imp #(tb_sequence_item, tb_scoreboard) scoreboard_port;

tb_sequence_item transactions[$]; //QUEUE


//--------------------------------------------------------
//Constructor
//--------------------------------------------------------
function new(string name = "tb_scoreboard", uvm_component parent);
    super.new(name, parent);
    `uvm_info("SCB_CLASS", "Inside Constructor!", UVM_HIGH)
endfunction: new


//--------------------------------------------------------
//Build Phase
//--------------------------------------------------------
function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("SCB_CLASS", "Build Phase!", UVM_HIGH)
    scoreboard_port = new("scoreboard_port", this);
endfunction: build_phase


//--------------------------------------------------------
//Connect Phase
//--------------------------------------------------------
function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("SCB_CLASS", "Connect Phase!", UVM_HIGH)
endfunction: connect_phase


//--------------------------------------------------------
//Write Method
//--------------------------------------------------------
function void write(tb_sequence_item item);
    transactions.push_back(item);
endfunction: write 



//--------------------------------------------------------
//Run Phase
//--------------------------------------------------------
task run_phase (uvm_phase phase);
    super.run_phase(phase);
    `uvm_info("SCB_CLASS", "Run Phase!", UVM_HIGH)
    forever begin
        /*
        // get the packet
        // generate expected value
        // compare it with actual value
        // score the transactions accordingly
        */
        tb_sequence_item curr_trans;
        wait((transactions.size() != 0));
        curr_trans = transactions.pop_front();
        compare(curr_trans);
    end
endtask: run_phase


//--------------------------------------------------------
//Compare : Generate Expected Result and Compare with Actual
//--------------------------------------------------------
task compare(tb_sequence_item curr_trans);
    //expected fields
    logic [47:0] dMac_out;
    logic [47:0] sMac_out;
    logic [15:0] oTag_out;
    logic [15:0] eType_out;
    logic [3:0] version_out;
    logic [3:0] headerLength_out;
    logic [7:0] typeOfService_out;
    logic [15:0] totalLength_out;
    logic [15:0] identification_out;
    logic [2:0] flags_out;
    logic [12:0] fragmentOffset_out;
    logic [7:0] timeToLive_out;
    logic [7:0] protocol_out;
    logic [15:0] headerChecksum_out;
    logic [31:0] srcIPAddress_out;
    logic [31:0] destIPAddress_out;
    logic [15:0] srcPort_out;
    logic [15:0] destPort_out;
    logic [15:0] length_out;
    logic [15:0] checksum_out;
    logic [79:0] sessionID_out;
    logic [63:0] sequenceNumber_out;
    logic [15:0] messageCount_out;
    case (curr_trans.counterOut)
        0: begin
            //empty
        end
        1: begin
            dMac_out = curr_trans.rx_data_net[47:0];
            if (dMac_out != curr_trans.dMac_out) begin
                `uvm_error("COMPARE", $sformatf("dMac_out failed! ACT=%d, EXP=%d", curr_trans.dMac_out, dMac_out))
            end
            else begin
                `uvm_info("COMPARE", $sformatf("dMac_out Passed! ACT=%d, EXP=%d", curr_trans.dMac_out, dMac_out), UVM_LOW)
            end
            sMac_out[15:0] = curr_trans.rx_data_net[63:48];
        end
        2: begin
            sMac_out[47:16] = curr_trans.rx_data_net[31:0];
            if (sMac_out != curr_trans.sMac_out) begin
                `uvm_error("COMPARE", $sformatf("sMac_out failed! ACT=%d, EXP=%d", curr_trans.sMac_out, sMac_out))
            end
            else begin
                `uvm_info("COMPARE", $sformatf("sMac_out Passed! ACT=%d, EXP=%d", curr_trans.sMac_out, sMac_out), UVM_LOW)
            end

            oTag_out = curr_trans.rx_data_net[47:32];
            if (oTag_out != curr_trans.oTag_out) begin
                `uvm_error("COMPARE", $sformatf("oTag_out failed! ACT=%d, EXP=%d", curr_trans.oTag_out, oTag_out))
            end
            else begin
                `uvm_info("COMPARE", $sformatf("oTag_out Passed! ACT=%d, EXP=%d", curr_trans.oTag_out, oTag_out), UVM_LOW)
            end

            eType_out = curr_trans.rx_data_net[63:48];
            if (eType_out != curr_trans.eType_out) begin
                `uvm_error("COMPARE", $sformatf("eType_out failed! ACT=%d, EXP=%d", curr_trans.eType_out, eType_out))
            end
            else begin
                `uvm_info("COMPARE", $sformatf("eType_out Passed! ACT=%d, EXP=%d", curr_trans.eType_out, eType_out), UVM_LOW)
            end
        end
        3: begin
            version_out = curr_trans.rx_data_net[3:0];
            if (version_out != curr_trans.version_out) begin
                `uvm_error("COMPARE", $sformatf("version_out failed! ACT=%d, EXP=%d", curr_trans.version_out, version_out))
            end
            else begin
                `uvm_info("COMPARE", $sformatf("version_out Passed! ACT=%d, EXP=%d", curr_trans.version_out, version_out), UVM_LOW)
            end

            headerLength_out = curr_trans.rx_data_net[7:4];
            if (headerLength_out != curr_trans.headerLength_out) begin
                `uvm_error("COMPARE", $sformatf("headerLength_out failed! ACT=%d, EXP=%d", curr_trans.headerLength_out, headerLength_out))
            end
            else begin
                `uvm_info("COMPARE", $sformatf("headerLength_out Passed! ACT=%d, EXP=%d", curr_trans.headerLength_out, headerLength_out), UVM_LOW)
            end

            typeOfService_out = curr_trans.rx_data_net[15:8];
            if (typeOfService_out != curr_trans.typeOfService_out) begin
                `uvm_error("COMPARE", $sformatf("typeOfService_out failed! ACT=%d, EXP=%d", curr_trans.typeOfService_out, typeOfService_out))
            end
            else begin
                `uvm_info("COMPARE", $sformatf("typeOfService_out Passed! ACT=%d, EXP=%d", curr_trans.typeOfService_out, typeOfService_out), UVM_LOW)
            end

            totalLength_out = curr_trans.rx_data_net[31:16];
            if (totalLength_out != curr_trans.totalLength_out) begin
                `uvm_error("COMPARE", $sformatf("totalLength_out failed! ACT=%d, EXP=%d", curr_trans.totalLength_out, totalLength_out))
            end
            else begin
                `uvm_info("COMPARE", $sformatf("totalLength_out Passed! ACT=%d, EXP=%d", curr_trans.totalLength_out, totalLength_out), UVM_LOW)
            end

            identification_out = curr_trans.rx_data_net[47:32];
            if (identification_out != curr_trans.identification_out) begin
                `uvm_error("COMPARE", $sformatf("identification_out failed! ACT=%d, EXP=%d", curr_trans.identification_out, identification_out))
            end
            else begin
                `uvm_info("COMPARE", $sformatf("identification_out Passed! ACT=%d, EXP=%d", curr_trans.identification_out, identification_out), UVM_LOW)
            end

            flags_out = curr_trans.rx_data_net[50:48];
            if (flags_out != curr_trans.flags_out) begin
                `uvm_error("COMPARE", $sformatf("flags_out failed! ACT=%d, EXP=%d", curr_trans.flags_out, flags_out))
            end
            else begin
                `uvm_info("COMPARE", $sformatf("flags_out Passed! ACT=%d, EXP=%d", curr_trans.flags_out, flags_out), UVM_LOW)
            end

            fragmentOffset_out = curr_trans.rx_data_net[63:51];
            if (fragmentOffset_out != curr_trans.fragmentOffset_out) begin
                `uvm_error("COMPARE", $sformatf("fragmentOffset_out failed! ACT=%d, EXP=%d", curr_trans.fragmentOffset_out, fragmentOffset_out))
            end
            else begin
                `uvm_info("COMPARE", $sformatf("fragmentOffset_out Passed! ACT=%d, EXP=%d", curr_trans.fragmentOffset_out, fragmentOffset_out), UVM_LOW)
            end
        end
        4: begin
            timeToLive_out = curr_trans.rx_data_net[7:0];
            if (timeToLive_out != curr_trans.timeToLive_out) begin
                `uvm_error("COMPARE", $sformatf("timeToLive_out failed! ACT=%d, EXP=%d", curr_trans.timeToLive_out, timeToLive_out))
            end
            else begin
                `uvm_info("COMPARE", $sformatf("timeToLive_out Passed! ACT=%d, EXP=%d", curr_trans.timeToLive_out, timeToLive_out), UVM_LOW)
            end

            protocol_out = curr_trans.rx_data_net[15:8];
            if (protocol_out != curr_trans.protocol_out) begin
                `uvm_error("COMPARE", $sformatf("protocol_out failed! ACT=%d, EXP=%d", curr_trans.protocol_out, protocol_out))
            end
            else begin
                `uvm_info("COMPARE", $sformatf("protocol_out Passed! ACT=%d, EXP=%d", curr_trans.protocol_out, protocol_out), UVM_LOW)
            end

            headerChecksum_out = curr_trans.rx_data_net[31:16];
            if (headerChecksum_out != curr_trans.headerChecksum_out) begin
                `uvm_error("COMPARE", $sformatf("headerChecksum_out failed! ACT=%d, EXP=%d", curr_trans.headerChecksum_out, headerChecksum_out))
            end
            else begin
                `uvm_info("COMPARE", $sformatf("headerChecksum_out Passed! ACT=%d, EXP=%d", curr_trans.headerChecksum_out, headerChecksum_out), UVM_LOW)
            end

            srcIPAddress_out = curr_trans.rx_data_net[63:32];
            if (srcIPAddress_out != curr_trans.srcIPAddress_out) begin
                `uvm_error("COMPARE", $sformatf("srcIPAddress_out failed! ACT=%d, EXP=%d", curr_trans.srcIPAddress_out, srcIPAddress_out))
            end
            else begin
                `uvm_info("COMPARE", $sformatf("srcIPAddress_out Passed! ACT=%d, EXP=%d", curr_trans.srcIPAddress_out, srcIPAddress_out), UVM_LOW)
            end
        end
        5: begin
            destIPAddress_out = curr_trans.rx_data_net[31:0];
            if (destIPAddress_out != curr_trans.destIPAddress_out) begin
                `uvm_error("COMPARE", $sformatf("destIPAddress_out failed! ACT=%d, EXP=%d", curr_trans.destIPAddress_out, destIPAddress_out))
            end
            else begin
                `uvm_info("COMPARE", $sformatf("destIPAddress_out Passed! ACT=%d, EXP=%d", curr_trans.destIPAddress_out, destIPAddress_out), UVM_LOW)
            end

            srcPort_out = curr_trans.rx_data_net[47:32];
            if (srcPort_out != curr_trans.srcPort_out) begin
                `uvm_error("COMPARE", $sformatf("srcPort_out failed! ACT=%d, EXP=%d", curr_trans.srcPort_out, srcPort_out))
            end
            else begin
                `uvm_info("COMPARE", $sformatf("srcPort_out Passed! ACT=%d, EXP=%d", curr_trans.srcPort_out, srcPort_out), UVM_LOW)
            end

            destPort_out = curr_trans.rx_data_net[63:48];
            if (destPort_out != curr_trans.destPort_out) begin
                `uvm_error("COMPARE", $sformatf("destPort_out failed! ACT=%d, EXP=%d", curr_trans.destPort_out, destPort_out))
            end
            else begin
                `uvm_info("COMPARE", $sformatf("destPort_out Passed! ACT=%d, EXP=%d", curr_trans.destPort_out, destPort_out), UVM_LOW)
            end
        end
        6: begin
            length_out = curr_trans.rx_data_net[15:0];
            if (length_out != curr_trans.length_out) begin
                `uvm_error("COMPARE", $sformatf("length_out failed! ACT=%d, EXP=%d", curr_trans.length_out, length_out))
            end
            else begin
                `uvm_info("COMPARE", $sformatf("length_out Passed! ACT=%d, EXP=%d", curr_trans.length_out, length_out), UVM_LOW)
            end

            checksum_out = curr_trans.rx_data_net[31:16];
            if (checksum_out != curr_trans.checksum_out) begin
                `uvm_error("COMPARE", $sformatf("checksum_out failed! ACT=%d, EXP=%d", curr_trans.checksum_out, checksum_out))
            end
            else begin
                `uvm_info("COMPARE", $sformatf("checksum_out Passed! ACT=%d, EXP=%d", curr_trans.checksum_out, checksum_out), UVM_LOW)
            end

            sessionID_out[31:0] = curr_trans.rx_data_net[63:32];
        end
       7: begin
            sessionID_out[79:32] = curr_trans.rx_data_net[47:0];
            if (sessionID_out != curr_trans.sessionID_out) begin
                `uvm_error("COMPARE", $sformatf("sessionID_out failed! ACT=%d, EXP=%d", curr_trans.sessionID_out, sessionID_out))
            end
            else begin
                `uvm_info("COMPARE", $sformatf("sessionID_out Passed! ACT=%d, EXP=%d", curr_trans.sessionID_out, sessionID_out), UVM_LOW)
            end

            sequenceNumber_out[15:0] = curr_trans.rx_data_net[63:48];
        end
        8: begin
            sequenceNumber_out[63:16] = curr_trans.rx_data_net[47:0];
            if (sequenceNumber_out != curr_trans.sequenceNumber_out) begin
                `uvm_error("COMPARE", $sformatf("sequenceNumber_out failed! ACT=%d, EXP=%d", curr_trans.sequenceNumber_out, sequenceNumber_out))
            end
            else begin
                `uvm_info("COMPARE", $sformatf("sequenceNumber_out Passed! ACT=%d, EXP=%d", curr_trans.sequenceNumber_out, sequenceNumber_out), UVM_LOW)
            end

            messageCount_out = curr_trans.rx_data_net[63:48];
            if (messageCount_out != curr_trans.messageCount_out) begin
                `uvm_error("COMPARE", $sformatf("messageCount_out failed! ACT=%d, EXP=%d", curr_trans.messageCount_out, messageCount_out))
            end
            else begin
                `uvm_info("COMPARE", $sformatf("messageCount_out Passed! ACT=%d, EXP=%d", curr_trans.messageCount_out, messageCount_out), UVM_LOW)
            end
        end
    endcase
endtask: compare


endclass: tb_scoreboard
class tb_monitor extends uvm_monitor;

`uvm_component_utils(tb_monitor)
virtual tb_interface vif;
tb_sequence_item item;
uvm_analysis_port #(tb_sequence_item) monitor_port;
//--------------------------------------------------------
//Constructor
//--------------------------------------------------------
function new(string name = "tb_monitor", uvm_component parent);
    super.new(name, parent);
    `uvm_info("MONITOR_CLASS", "Inside Constructor!", UVM_HIGH)
endfunction: new

//--------------------------------------------------------
//Build Phase
//--------------------------------------------------------
function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("MONITOR_CLASS", "Build Phase!", UVM_HIGH)
    monitor_port = new("monitor_port", this);
    if(!(uvm_config_db #(virtual tb_interface)::get(this, "*", "vif", vif))) begin
      `uvm_error("DRIVER_CLASS", "Failed to get VIF from config DB!")
    end
endfunction: build_phase

//--------------------------------------------------------
//Connect Phase
//--------------------------------------------------------
function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("MONITOR_CLASS", "Connect Phase!", UVM_HIGH)
endfunction: connect_phase

//--------------------------------------------------------
//Run Phase
//--------------------------------------------------------
task run_phase (uvm_phase phase);
    super.run_phase(phase);
    `uvm_info("MONITOR_CLASS", "Run Phase!", UVM_HIGH)
    forever begin
        item = tb_sequence_item::type_id::create("item");
        wait(!vif.rst);
        //sample inputs
        @(vif.cb);
            item.rst = vif.rst;
            item.rx_data_net = vif.rx_data_net;
        //sample outputs
            item.counterOut = vif.counterOut;
            item.dMac_out = vif.dMac_out;
            item.sMac_out = vif.sMac_out;
            item.oTag_out = vif.oTag_out;
            item.eType_out = vif.eType_out;
            item.version_out = vif.version_out;
            item.headerLength_out = vif.headerLength_out;
            item.typeOfService_out = vif.typeOfService_out;
            item.totalLength_out = vif.totalLength_out;
            item.identification_out = vif.identification_out;
            item.flags_out = vif.flags_out;
            item.fragmentOffset_out = vif.fragmentOffset_out;
            item.timeToLive_out = vif.timeToLive_out;
            item.protocol_out = vif.protocol_out;
            item.headerChecksum_out = vif.headerChecksum_out;
            item.srcIPAddress_out = vif.srcIPAddress_out;
            item.destIPAddress_out = vif.destIPAddress_out;
            item.srcPort_out = vif.srcPort_out;
            item.destPort_out = vif.destPort_out;
            item.length_out = vif.length_out;
            item.checksum_out = vif.checksum_out;
            item.sessionID_out = vif.sessionID_out;
            item.sequenceNumber_out = vif.sequenceNumber_out;
            item.messageCount_out = vif.messageCount_out;
        //send item to scoreboard
        monitor_port.write(item);
        `uvm_info("MONITOR_CLASS", $sformatf("Saw item %s", item.convert2str()), UVM_HIGH)
    end
endtask: run_phase

endclass //tb_monitor extends uvm_test
class tb_agent extends uvm_agent;

`uvm_component_utils(tb_agent)
tb_driver driver;
tb_sequencer sequencer;
tb_monitor monitor;


//--------------------------------------------------------
//Constructor
//--------------------------------------------------------
function new(string name = "tb_agent", uvm_component parent);
    super.new(name, parent);
    `uvm_info("AGENT_CLASS", "Inside Constructor!", UVM_HIGH)
endfunction: new

//--------------------------------------------------------
//Build Phase
//--------------------------------------------------------
function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("AGENT_CLASS", "Build Phase!", UVM_HIGH)
    driver = tb_driver::type_id::create("driver", this);
    monitor = tb_monitor::type_id::create("monitor", this);
    sequencer = tb_sequencer::type_id::create("sequencer", this);
endfunction: build_phase

//--------------------------------------------------------
//Connect Phase
//--------------------------------------------------------
function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("AGENT_CLASS", "Connect Phase!", UVM_HIGH)
    driver.seq_item_port.connect(sequencer.seq_item_export);
endfunction: connect_phase

//--------------------------------------------------------
//Run Phase
//--------------------------------------------------------
task run_phase (uvm_phase phase);
    super.run_phase(phase);
    `uvm_info("AGENT_CLASS", "Run Phase!", UVM_HIGH)
endtask: run_phase

endclass //tb_agent extends uvm_test
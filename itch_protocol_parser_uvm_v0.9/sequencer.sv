class tb_sequencer extends uvm_sequencer#(tb_sequence_item);

`uvm_component_utils(tb_sequencer)

//--------------------------------------------------------
//Constructor
//--------------------------------------------------------
function new(string name = "tb_sequencer", uvm_component parent);
    super.new(name, parent);
    `uvm_info("SEQUENCER_CLASS", "Inside Constructor!", UVM_HIGH)
endfunction: new

//--------------------------------------------------------
//Build Phase
//--------------------------------------------------------
function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("SEQUENCER_CLASS", "Build Phase!", UVM_HIGH)

endfunction: build_phase

//--------------------------------------------------------
//Connect Phase
//--------------------------------------------------------
function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("SEQUENCER_CLASS", "Connect Phase!", UVM_HIGH)
endfunction: connect_phase

//--------------------------------------------------------
//Run Phase
//--------------------------------------------------------
task run_phase (uvm_phase phase);
    super.run_phase(phase);
    `uvm_info("SEQUENCER_CLASS", "Run Phase!", UVM_HIGH)
    //LOGIC
endtask: run_phase

endclass //tb_sequencer extends uvm_test
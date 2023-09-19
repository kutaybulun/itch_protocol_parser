class tb_test extends uvm_test;

`uvm_component_utils(tb_test)
tb_env env;
tb_test_sequence test_sequence;
tb_base_sequence reset_sequence;

//--------------------------------------------------------
//Constructor
//--------------------------------------------------------
function new(string name = "tb_test", uvm_component parent);
    super.new(name, parent);
    `uvm_info("TEST_CLASS", "Inside Constructor!", UVM_HIGH)
endfunction: new

//--------------------------------------------------------
//Build Phase
//--------------------------------------------------------
function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("TEST_CLASS", "Build Phase!", UVM_HIGH)
    env = tb_env::type_id::create("env", this);
endfunction: build_phase

//--------------------------------------------------------
//Connect Phase
//--------------------------------------------------------
function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("TEST_CLASS", "Connect Phase!", UVM_HIGH)
endfunction: connect_phase

//--------------------------------------------------------
//Run Phase
//--------------------------------------------------------
task run_phase (uvm_phase phase);
    super.run_phase(phase);
    `uvm_info("TEST_CLASS", "Run Phase!", UVM_HIGH)
    //LOGIC
    phase.raise_objection(this);
        //SEQUENCES
        reset_sequence = tb_base_sequence::type_id::create("reset_sequence");
        reset_sequence.start(env.agent.sequencer);
        repeat(10) begin
            test_sequence = tb_test_sequence::type_id::create("test_sequence");
            test_sequence.start(env.agent.sequencer);
        end
    phase.drop_objection(this);

endtask: run_phase

endclass //tb_test extends uvm_test
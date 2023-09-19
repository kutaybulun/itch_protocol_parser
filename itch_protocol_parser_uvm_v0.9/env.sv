class tb_env extends uvm_env;

`uvm_component_utils(tb_env)
tb_agent agent;
tb_scoreboard scoreboard;

//--------------------------------------------------------
//Constructor
//--------------------------------------------------------
function new(string name = "tb_env", uvm_component parent);
    super.new(name, parent);
    `uvm_info("ENV_CLASS", "Inside Constructor!", UVM_HIGH)
endfunction: new

//--------------------------------------------------------
//Build Phase
//--------------------------------------------------------
function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("ENV_CLASS", "Build Phase!", UVM_HIGH)
    agent = tb_agent::type_id::create("agent", this);
    scoreboard = tb_scoreboard::type_id::create("scoreboard", this);
endfunction: build_phase

//--------------------------------------------------------
//Connect Phase
//--------------------------------------------------------
function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("ENV_CLASS", "Connect Phase!", UVM_HIGH)
    agent.monitor.monitor_port.connect(scoreboard.scoreboard_port);
endfunction: connect_phase

//--------------------------------------------------------
//Run Phase
//--------------------------------------------------------
task run_phase (uvm_phase phase);
    super.run_phase(phase);
    `uvm_info("ENV_CLASS", "Run Phase!", UVM_HIGH)
endtask: run_phase

endclass //tb_env extends uvm_test
class tb_base_sequence extends uvm_sequence;
`uvm_object_utils(tb_base_sequence)
tb_sequence_item reset_pkt;
//--------------------------------------------------------
//Constructor
//--------------------------------------------------------
function new(string name= "tb_base_sequence");
    super.new(name);
    `uvm_info("BASE_SEQ", "Inside Constructor!", UVM_HIGH)
endfunction

//--------------------------------------------------------
//Body Task
//--------------------------------------------------------
task body();
    `uvm_info("BASE_SEQ", "Inside body task!", UVM_HIGH)
    reset_pkt = tb_sequence_item::type_id::create("reset_pkt");
    start_item(reset_pkt);
        reset_pkt.randomize() with {rst==1;};
    finish_item(reset_pkt);
endtask: body

endclass: tb_base_sequence


class tb_test_sequence extends tb_base_sequence;
`uvm_object_utils(tb_test_sequence)
tb_sequence_item test_pkt;
//--------------------------------------------------------
//Constructor
//--------------------------------------------------------
function new(string name= "tb_test_sequence");
    super.new(name);
    `uvm_info("TEST_SEQ", "Inside Constructor!", UVM_HIGH)
endfunction

//--------------------------------------------------------
//Body Task
//--------------------------------------------------------
task body();
    `uvm_info("TEST_SEQ", "Inside body task!", UVM_HIGH)
    for (int i = 0; i < 9; i++ ) begin
        test_pkt = tb_sequence_item::type_id::create($sformatf("data_pkt_%0d", i));
        start_item(test_pkt);
            test_pkt.randomize() with {rst==0;};
        finish_item(test_pkt);    
    end
endtask: body

endclass: tb_test_sequence
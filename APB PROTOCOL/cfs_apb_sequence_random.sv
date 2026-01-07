class cfs_apb_sequence_random extends cfs_apb_sequence_base;
    
    //NUmber of items to drive
    rand int unsigned num_items;
    
    constraint num_items_default {
      soft num_items inside {[1:10]}; 
    }
    
    `uvm_object_utils(cfs_apb_sequence_random)
    
    function new(string name = "");
      super.new(name);
    endfunction
    
    virtual task body();
      for(int i = 0; i < num_items; i++) begin
        cfs_apb_sequence_simple seq = cfs_apb_sequence_simple::type_id::create("seq");
        
        void'(seq.randomize());
        
        seq.start(m_sequencer, this);
      
        //An alternative with macros is to use `uvm_do().
        //`uvm_do(seq)
      end
    endtask

  endclass
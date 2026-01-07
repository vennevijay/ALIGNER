class cfs_apb_sequence_simple extends cfs_apb_sequence_base;
    
    //Item to drive
    rand cfs_apb_item_drv item;
    
    `uvm_object_utils(cfs_apb_sequence_simple)
    
    function new(string name = "");
      super.new(name);
      
      item = cfs_apb_item_drv::type_id::create("item");
    endfunction
    
    virtual task body();
      start_item(item);
      finish_item(item);
      
      //An alternative with macros is to use `uvm_send().
      //Macro `uvm_do() will not work because any constraints from sequence call will have no effect
      //`uvm_send(item)
    endtask

  endclass
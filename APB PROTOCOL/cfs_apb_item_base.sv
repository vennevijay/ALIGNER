 class cfs_apb_item_base extends uvm_sequence_item;

    //Direction
    rand cfs_apb_dir dir;
    
    //Address
    rand cfs_apb_addr addr;
    
    //Data
    rand cfs_apb_data data;
    
    `uvm_object_utils(cfs_apb_item_base)
    
    function new(string name = "");
      super.new(name);
    endfunction
    
    virtual function string convert2string();
      string result = $sformatf("dir: %0s, addr: %0x", dir.name(), addr);
      
      return result;
    endfunction
    
  endclass
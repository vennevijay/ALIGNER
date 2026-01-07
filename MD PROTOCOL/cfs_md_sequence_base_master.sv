  class cfs_md_sequence_base_master extends cfs_md_sequence_base#(.ITEM_DRV(cfs_md_item_drv_master));
    
    `uvm_declare_p_sequencer(cfs_md_sequencer_base_master)
    
    `uvm_object_utils(cfs_md_sequence_base_master)
    
    function new(string name = "");
      super.new(name);
    endfunction

  endclass
class cfs_md_sequencer_base_master extends cfs_md_sequencer_base#(.ITEM_DRV(cfs_md_item_drv_master));

    `uvm_component_utils(cfs_md_sequencer_base_master)

    function new(string name = "", uvm_component parent);
      super.new(name, parent);
    endfunction
  endclass
 class cfs_md_item_mon extends cfs_md_item_base;
    
    //Number of clock cycles from the previous item
    int unsigned prev_item_delay;
    
    //Lenght, in clock cycles, of the MD transfer
    int unsigned length;
    
    //Data monitored by the agent
    bit[7:0] data[$];

    //Offset of the data
    int unsigned offset;
    
    //Response
    cfs_md_response response;
    
    `uvm_object_utils(cfs_md_item_mon)
    
    function new(string name = "");
      super.new(name);
    endfunction
    
    virtual function string convert2string();
      string data_as_string = "{";
      
      foreach(data[idx]) begin
        data_as_string = $sformatf("%0s'h%02x%0s", data_as_string, data[idx], idx == data.size() - 1 ? "" : ", ");
      end
      
      data_as_string = $sformatf("%0s}", data_as_string); 
      
      return $sformatf("[%0t..%0s] data: %0s, size: %0d, offset: %0d, response: %0s, length: %0d, prev_item_delay: %0d", 
                       get_begin_time(), 
                       is_active() ? "" : $sformatf("%0t",  get_end_time()), 
                       data_as_string, data.size(), offset, response.name(), length, prev_item_delay);
    endfunction

  endclass

class cfs_md_monitor#(int unsigned DATA_WIDTH = 32) extends uvm_monitor implements cfs_md_reset_handler;

    typedef virtual cfs_md_if#(DATA_WIDTH) cfs_md_vif;

    //Pointer to agent configuration
    cfs_md_agent_config#(DATA_WIDTH) agent_config;

    //Port for sending the collected item
    uvm_analysis_port#(cfs_md_item_mon) output_port;

    //Process for collect_transactions() task
    protected process process_collect_transactions;

    `uvm_component_param_utils(cfs_md_monitor#(DATA_WIDTH))

    function new(string name = "", uvm_component parent);
      super.new(name, parent);

      output_port = new("output_port", this);
    endfunction

    virtual task run_phase(uvm_phase phase);
      forever begin
        fork
          begin
            wait_reset_end();
            collect_transactions();

            disable fork;
          end 
        join
      end
    endtask

    //Task which drives one single item on the bus
    protected virtual task collect_transaction();
      cfs_md_vif vif = agent_config.get_vif();
      
      int unsigned data_width_in_bytes = DATA_WIDTH / 8;

      cfs_md_item_mon item = cfs_md_item_mon::type_id::create("item");

      #(agent_config.get_sample_delay_start_tr());
      
      while(vif.valid !== 1) begin
        @(posedge vif.clk);
        
        item.prev_item_delay++;
        
        #(agent_config.get_sample_delay_start_tr());
      end
      
      item.offset = vif.offset;
      
      for(int i = 0; i < vif.size; i++) begin
        item.data.push_back((vif.data >> ((item.offset + i) * 8)) & 8'hFF);
      end
      
      item.length = 1;
      
      void'(begin_tr(item));
      
      //`uvm_info("DEBUG", $sformatf("Monitor started collecting item: %0s", item.convert2string()), UVM_NONE)
      
      output_port.write(item);
      
      @(posedge vif.clk);

      while(vif.ready !== 1) begin
        @(posedge vif.clk);
        item.length++;

        if(agent_config.get_has_checks()) begin
          if(item.length >= agent_config.get_stuck_threshold()) begin
            `uvm_error("PROTOCOL_ERROR", $sformatf("The MD transfer reached the stuck threshold value of %0d", item.length))
          end
        end
      end

      item.response = cfs_md_response'(vif.err);
      
      end_tr(item);

      output_port.write(item);

      `uvm_info("DEBUG", $sformatf("Monitored item: %0s", item.convert2string()), UVM_NONE)
    endtask

    //Task for collecting all transactions
    protected virtual task collect_transactions();
      fork
        begin
          process_collect_transactions = process::self();

          forever begin
            collect_transaction();
          end

        end
      join
    endtask

    //Task for waiting the reset to be finished
    protected virtual task wait_reset_end();
      agent_config.wait_reset_end();
    endtask

    //Function to handle the reset
    virtual function void handle_reset(uvm_phase phase);
      if(process_collect_transactions != null) begin
        process_collect_transactions.kill();

        process_collect_transactions = null;
      end
    endfunction

  endclass

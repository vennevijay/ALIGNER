class cfs_md_driver#(int unsigned DATA_WIDTH = 32, type ITEM_DRV = cfs_md_item_drv) extends uvm_driver#(.REQ(ITEM_DRV)) implements cfs_md_reset_handler;

    //Pointer to agent configuration
    cfs_md_agent_config#(DATA_WIDTH) agent_config;

    //process for drive_transactions() task
    protected process process_drive_transactions;

    `uvm_component_param_utils(cfs_md_driver#(DATA_WIDTH, ITEM_DRV))

    function new(string name = "", uvm_component parent);
      super.new(name, parent);
    endfunction

    virtual task run_phase(uvm_phase phase);
      forever begin
        fork
          begin
            wait_reset_end();
            drive_transactions();

            disable fork;
          end
        join
      end
    endtask

    //Task which drives one single item on the bus
    protected virtual task drive_transaction(ITEM_DRV item);
      `uvm_fatal("ALGORITHM_ISSUE", "Implement drive_transaction()")
    endtask

    //Task for driving all transactions
    protected virtual task drive_transactions();

      fork
        begin
          process_drive_transactions = process::self();

          forever begin
            ITEM_DRV item;

            seq_item_port.get_next_item(item);

            drive_transaction(item);

            seq_item_port.item_done();
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
      if(process_drive_transactions != null) begin
        process_drive_transactions.kill();

        process_drive_transactions = null;
      end
    endfunction

  endclass
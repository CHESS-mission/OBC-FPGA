--
-- VHDL Architecture OBC_test.test.SPI_tester
--
-- Created:
--          by - Lucas.Mayor (DESKTOP-3I0F3HP)
--          at - 13:14:41 13.07.2020
--
-- using Mentor Graphics HDL Designer(TM) 2019.2 (Build 5)
--
ARCHITECTURE SPI_tester OF test IS
    constant clockFrequency: real := 20.0E6;
    constant clockPeriod: time := (1.0/clockFrequency) * 1 sec;
    signal clock_int: std_uLogic := '1';
    
    signal masterDataOut : string(1 to 32);
    signal masterSendData : std_uLogic;
    signal masterSendDataDone : std_uLogic;
    signal masterCharOut : character;
    signal masterCharInReadback : character;
    
    signal slaveData_rx : std_ulogic_vector(tx_data'range);
    
    
BEGIN
    ------------------------------------------------------------------------------
                                                              -- reset and clock
    reset <= '1', '0' after 2*clockPeriod;

    clock_int <= not clock_int after clockPeriod/2;
    clock <= transport clock_int after clockPeriod*9/10;
    
 ------------------------------------------------------------------------------
                                                          -- Master SPI output data
    process
    begin
        masterSendData <= '0';

        wait for 8 us;

        masterDataOut <= "Test                            ";
        masterSendData <= '1', '0' after 1 ns;
        wait until masterSendDataDone = '1';
        --wait for spiActInterval;

        wait for 300 us;

        --    wait;
    end process;
    
------------------------------------------------------------------------------
                                                         -- Master SPI send
    sendSpi: process
        variable commandRight: natural;
    begin

        masterSendDataDone <= '0';
        masterWr <= '0';

        wait until rising_edge(masterSendData);
        wait for 1 ns;

        commandRight := masterDataOut'right;
        while masterDataOut(commandRight) = ' ' loop
            commandRight := commandRight-1;
        end loop;

        for index in masterDataOut'left to commandRight loop
              masterCharOut <= masterDataOut(index);
              masterWr <= '1', '0' after clockPeriod;
              wait until rising_edge(SS_n);
              wait for 1 ns;
        end loop;

        masterCharOut <= cr;
        masterWr <= '1', '0' after clockPeriod;
        wait until rising_edge(SS_n);

        masterSendDataDone <= '1';
        wait for 1 ns;

    end process sendSpi;
      
    masterData <= std_ulogic_vector(to_unsigned(character'pos(masterCharOut), masterData'length));

------------------------------------------------------------------------------
                                                      -- Master SPI receive   
    spiReadFifo: process
    begin
        slaveRd <= '0';

        wait until falling_edge(slaveEmpty);
        wait for 1 ns;

        slaveRd <= '1';
        wait for clockPeriod;

    end process spiReadFifo;

    masterCharInReadback <= character'val(to_integer(unsigned(slaveData))) when slaveEmpty = '0';

------------------------------------------------------------------------------
                                                      -- slave SPI send   
    -- SlaveSend: process
    -- begin
        -- tx_data_valid <= '0';
        -- wait for 1 ns;
               
        -- tx_data_valid <= '1', '0' after clockPeriod;
    -- end process SlaveSend;

    -- tx_data = slaveData_rx

------------------------------------------------------------------------------
                                                      -- slave SPI send   
    SlaveReceive: process
    begin
        tx_data_valid <= '0';
    
        wait until rising_edge(rx_data_wr);
        slaveData_rx <= rx_data;  
        wait for 1 ns;
        tx_data <= slaveData_rx;
        tx_data_valid <= '1', '0' after clockPeriod;
        wait for clockPeriod;

    end process SlaveReceive;
    
END ARCHITECTURE SPI_tester;


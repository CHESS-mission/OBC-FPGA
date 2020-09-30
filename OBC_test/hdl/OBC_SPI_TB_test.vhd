--
-- VHDL Architecture OBC_test.OBC_SPI_TB.test
--
-- Created:
--          by - student.UNKNOWN (DESKTOP-3I0F3HP)
--          at - 15:37:09 16.07.2020
--
-- using Mentor Graphics HDL Designer(TM) 2019.2 (Build 5)
--
ARCHITECTURE test OF OBC_SPI_TB IS
    constant clockFrequency: real := 20.0E6;
    constant clockPeriod: time := (1.0/clockFrequency) * 1 sec;
    signal clock_int: std_uLogic := '1';
    
    signal sendData : std_uLogic;
    signal sendDataDone : std_uLogic;
    constant dataLength : positive := 8;
    constant data : unsigned(0 TO dataLength*dataBitNb-1) := x"A5A5A5A5A5A5A5A5";
    signal dataOut : unsigned(dataBitNb-1 DOWNTO 0);
    
BEGIN
    ------------------------------------------------------------------------------
                                                              -- reset and clock
    reset <= '1', '0' after 2*clockPeriod;

    clock_int <= not clock_int after clockPeriod/2;
    clock <= transport clock_int after clockPeriod*9/10;
    
    
    process
    begin
        sendData <= '0';    

        wait for 8 us;

        sendData <= '1', '0' after 1 ns;
        wait until sendDataDone = '1';
        
        wait for 500 us;
    end process;
    
    process
    begin
        SlaveSelect <= "01";
        sendDataDone <= '0';
        masterWr <= '0';
        dataOut <= (others => '0');
        
        for index in 0 to dataLength-1 loop
            dataOut <= data(index*dataBitNb to index*dataBitNb+7);
            masterWr <= '1', '0' after clockPeriod;
            
            wait until falling_edge(SS1_n);
            wait for 1 ns;
        end loop;
        
        
        wait until rising_edge(sendData);
        
    end process;
    
    masterData <= std_ulogic_vector(dataOut);
    
    
END ARCHITECTURE test;


















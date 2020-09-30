--
-- VHDL Architecture OBC_test.tranceiver_TB.test
--
-- Created:
--          by - student.UNKNOWN (DESKTOP-3I0F3HP)
--          at - 10:09:22 16.07.2020
--
-- using Mentor Graphics HDL Designer(TM) 2019.2 (Build 5)
--
ARCHITECTURE test OF tranceiver_TB IS
    constant clockFrequency: real := 20.0E6;
    constant clockPeriod: time := (1.0/clockFrequency) * 1 sec;
    signal clock_int: std_uLogic := '1';
    
    
    signal commandData : std_ulogic_vector (7 DOWNTO 0);
    signal sendCommand : std_uLogic;
    signal receiveDone : std_uLogic;
    signal data : std_ulogic_vector (7 DOWNTO 0);
BEGIN

    ------------------------------------------------------------------------------
                                                              -- reset and clock
    reset <= '1', '0' after 2*clockPeriod;

    clock_int <= not clock_int after clockPeriod/2;
    clock <= transport clock_int after clockPeriod*9/10;


    process
    begin
        sendCommand <= '0';
        
        wait for 8 us;
        
        commandData <= "11110101";
        sendCommand <= '1', '0' after clockPeriod;
        
        wait until falling_edge(receiveDone);

        wait for 300 us;   
    end process;


    process
    begin
        dataWr <= '0';
        data <= (others => '0');
        
        wait until rising_edge(sendCommand);
              
        data <= commandData;
        
        dataWr <= '1';
        
        wait for 20 us;
    end process;
    
    dataOut <= data;
    
END ARCHITECTURE test;


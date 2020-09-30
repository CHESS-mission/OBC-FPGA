ARCHITECTURE test OF spiFifo_tester IS

  constant clockFrequency: real := 20.0E6;
  constant clockPeriod: time := (1.0/clockFrequency) * 1 sec;
  signal clock_int: std_uLogic := '1';

  constant spiActInterval: time := 10*clockPeriod;

  signal spiDataOut : string(1 to 32);
  signal spiSendData: std_uLogic;
  signal spiSendDataDone: std_uLogic;
  signal spiCharOut: character;

  signal spiCharInReadback: character;

BEGIN
  ------------------------------------------------------------------------------
                                                              -- reset and clock
  reset <= '1', '0' after 2*clockPeriod;

  clock_int <= not clock_int after clockPeriod/2;
  clock <= transport clock_int after clockPeriod*9/10;

  ------------------------------------------------------------------------------
                                                            -- timing parameters
  --spiClockPeriod <= to_unsigned(5, spiClockPeriod'length);
  --spiFramePeriod <= to_unsigned(50, spiFramePeriod'length);

  ------------------------------------------------------------------------------
                                                              -- SPI output data
  process
  begin
    spiSendData <= '0';

    wait for 8 us;

    ----------------------------------------------------------------------------
                                                              -- ask for version
    spiDataOut <= "V                               ";
    spiSendData <= '1', '0' after 1 ns;
    wait until spiSendDataDone = '1';
    wait for spiActInterval;

    wait for 300 us;

--    wait;
  end process;


  ------------------------------------------------------------------------------
                                                                     -- SPI send
  sendSpi: process
    variable commandRight: natural;
  begin

    spiSendDataDone <= '0';
    masterWr <= '0';

    wait until rising_edge(spiSendData);
    wait for 1 ns;

    commandRight := spiDataOut'right;
    while spiDataOut(commandRight) = ' ' loop
      commandRight := commandRight-1;
    end loop;

    for index in spiDataOut'left to commandRight loop
      spiCharOut <= spiDataOut(index);
      masterWr <= '1', '0' after clockPeriod;
      wait until rising_edge(SS_n);
      wait for 1 ns;
    end loop;

    spiCharOut <= cr;
    masterWr <= '1', '0' after clockPeriod;
    wait until rising_edge(SS_n);

    for index in 0 to 1 loop
      spiCharOut <= character'val(index);
      masterWr <= '1';
      wait until rising_edge(clock_int);
    end loop;
    masterWr <= '0';
    wait until rising_edge(SS_n);
    wait for 1 ns;
    
    for index in 1 to 3 loop
      spiCharOut <= character'val(index);
      masterWr <= '1';
      wait until rising_edge(clock_int);
    end loop;
    masterWr <= '0';
    wait until rising_edge(SS_n);
    wait for 1 ns;
    
    for index in 3 to 6 loop
      spiCharOut <= character'val(index);
      masterWr <= '1';
      wait until rising_edge(clock_int);
    end loop;
    masterWr <= '0';
    wait until rising_edge(SS_n);
    wait for 1 ns;
    
    for index in 6 to 10 loop
      spiCharOut <= character'val(index);
      masterWr <= '1';
      wait until rising_edge(clock_int);
    end loop;
    masterWr <= '0';
    wait until rising_edge(SS_n);
    wait for 1 ns;
    
    spiSendDataDone <= '1';
    wait for 1 ns;

  end process sendSpi;

  masterData <= std_ulogic_vector(to_unsigned(character'pos(spiCharOut), masterData'length));


  ------------------------------------------------------------------------------
                                                                  -- SPI receive
  spiReadFifo: process
  begin
    slaveRd <= '0';

    wait until falling_edge(slaveEmpty);
    wait for 1 ns;

    slaveRd <= '1';
    wait for clockPeriod;

  end process spiReadFifo;

  spiCharInReadback <= character'val(to_integer(unsigned(slaveData))) when slaveEmpty = '0';

END ARCHITECTURE test;

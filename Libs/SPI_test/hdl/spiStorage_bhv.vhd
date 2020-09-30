ARCHITECTURE bhv OF spiStorage IS

  constant clockFrequency: real := 20.0E6;
  constant clockPeriod: time := (1.0/clockFrequency) * 1 sec;
  signal spiCharNone: character := character'val(2**8-1);

  signal spiCharIn: character;
  signal spiDataIn : string(1 to 32) := (others => ' ');

  signal spiDataOut : string(1 to 32) := (others => ' ');
  signal spiAnswerData: std_ulogic := '0';
  signal spiAnswerDataDone: std_ulogic;
  signal spiCharOut: character;
  signal misoInt: std_ulogic;

BEGIN
  ------------------------------------------------------------------------------
                                                         -- process SPI commands
  process
  begin
    wait until spiCharIn = cr;
    wait until rising_edge(SS_n);

    if spiDataIn = "V                               " then
      spiDataOut <= "uHESFAT 0.01" & cr & "!00                ";
    else
      spiDataOut <= "!61                             ";
    end if;

    wait for 1 ns;
    spiAnswerData <= '1', '0' after 1 ns;
    wait until spiAnswerDataDone = '1';

  end process;

  ------------------------------------------------------------------------------
                                                          -- SPI receive command
                                                               -- receive char
  spiBuildCommandByte: process
    variable spiData: unsigned(7 downto 0);
  begin
    wait until falling_edge(SS_n);
    spiData := (others => '0');

    for index in spiData'range loop
      if (cPha = '1') or (index /= spiData'left) then
        wait until sClk'event;
      end if;
      wait until sClk'event;
      spiData(index) := MOSI;
    end loop;

    spiCharIn <= character'val(to_integer(spiData));

  end process spiBuildCommandByte;

                                                             -- receive string
  spigetCommand: process
    variable charIndex: natural := spiDataIn'left;
  begin
    wait until rising_edge(SS_n);

    if spiCharIn = cr then
      spiDataIn <= (others => ' ');
      charIndex := spiDataIn'left;
--    elsif character'pos(spiCharIn) /= 2**8-1 then
    elsif spiCharIn /= spiCharNone then
      spiDataIn(charIndex) <= spiCharIn;
      if spiCharIn /= nul then
        charIndex := charIndex + 1;
      end if;
    end if;

  end process spigetCommand;

  ------------------------------------------------------------------------------
                                                              -- SPI send answer
                                                                -- send string
  answerSpi: process
    variable commandRight: natural;
  begin

    spiCharOut <= spiCharNone;
    spiAnswerDataDone <= '0';

    wait until rising_edge(spiAnswerData);
    wait until rising_edge(SS_n);

    commandRight := spiDataOut'right;
    while spiDataOut(commandRight) = ' ' loop
      commandRight := commandRight-1;
    end loop;

    for index in spiDataOut'left to commandRight loop
      spiCharOut <= spiDataOut(index);
      wait until rising_edge(SS_n);
      wait for 1 ns;
    end loop;

    spiCharOut <= cr;
    wait until rising_edge(SS_n);

    spiAnswerDataDone <= '1';
    wait for 1 ns;

  end process answerSpi;

                                                                  -- send char
  spiBuildAnswerByte: process
    variable spiData: unsigned(7 downto 0);
  begin
    misoInt <= 'Z';

    wait until falling_edge(SS_n);
    spiData := to_unsigned(character'pos(spiCharOut), spiData'length);

    if cPha = '1' then
      wait until sClk'event;
    end if;

    for index in spiData'range loop
      misoInt <= spiData(index);
      wait until sClk'event;
      if (cPha = '1') and (index = spiData'right) then
        wait until rising_edge(SS_n);
      else
        wait until sClk'event;
      end if;
    end loop;

  end process spiBuildAnswerByte;

  MISO <= misoInt when SS_n = not('1') else 'Z';

END ARCHITECTURE bhv;


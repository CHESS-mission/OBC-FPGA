--------------------------------------------------------------------------------
-- Copyright 2013 HES-SO Valais Wallis (www.hevs.ch)
--------------------------------------------------------------------------------
-- SPI master interface
--   More information: http://wiki.hevs.ch/uit/index.php5/Components/IP/SPI  
--
--   Created on 2012-10-01
--
--   Version: 1.0
--   Author: François Corthay (francois.corthay@hevs.ch)
--------------------------------------------------------------------------------

LIBRARY Common;
USE Common.CommonLib.all;

architecture RTL of spiTransceiver is

  signal sequenceCounter    : unsigned(requiredBitNb(2*dataBitNb+1)-1 downto 0);
  signal sequenceCounterEnd : std_uLogic;
  signal sending            : std_uLogic;
  signal dataValid1         : std_uLogic;
  signal dataAvail          : std_ulogic;
  signal serialClock        : std_uLogic;
  signal slaveSel_int       : std_ulogic;

  signal dataOutShift           : std_uLogic;
  signal dataOutShiftReg        : std_ulogic_vector(dataOut'range);
  signal dataOutBufferReg       : std_ulogic_vector(dataOut'range);
  signal masterOut0, masterOut1 : std_uLogic;

  signal dataInShift, dataInShift1     : std_uLogic;
  signal dataInEndDelayed, dataInStore : std_uLogic;
  signal dataInShiftReg                : std_ulogic_vector(dataIn'range);

begin
  ------------------------------------------------------------------------------
                                                                       -- timing
  countSequence: process(reset, clock)
  begin
    if reset = '1' then
      sequenceCounter <= (others => '0');
    elsif rising_edge(clock) then
      if (slaveSel_int = '0' and dataAvail = '1') then -- first transfer
        sequenceCounter <= sequenceCounter + 1;
      elsif en2x = '1' then
        if sequenceCounterEnd = '1' then
          if dataAvail = '0' then                      -- Last Transfer
            sequenceCounter <= (others => '0');
          else                                         -- Continue with next Transfer
            sequenceCounter <= to_unsigned(1, sequenceCounter'length);
          end if;
        elsif sequenceCounter > 0 then
          sequenceCounter <= sequenceCounter + 1;
        end if;
      end if;
    end if;
  end process countSequence;

  endOfSequence: process(sequenceCounter)
  begin
    if sequenceCounter = 2*dataBitNb+1 then
      sequenceCounterEnd <= '1';
    else
      sequenceCounterEnd <= '0';
    end if;
  end process endOfSequence;

  sending <= '1' when sequenceCounter /= 0 else '0';
  serialClock <= not(sequenceCounter(0)) and sending;

  busy <= dataAvail;
  
  signalValid: process(reset, clock)
  begin
    if reset = '1' then
      dataValid1 <= '0';
      dataValid <= '0';
    elsif rising_edge(clock) then
      dataValid1 <= sequenceCounterEnd and en2x;
      dataValid <= dataValid1;
    end if;
  end process signalValid;

  ------------------------------------------------------------------------------
                                                                     -- data out
  dataOutShift <= en2x when (sequenceCounter(0) = '0') and (sending = '1') else '0';

  outputShiftReg: process(reset, clock)
  begin
    if reset = '1' then
      dataOutBufferReg <= (others => '0');
      dataAvail        <= '0';
      dataOutShiftReg  <= (others => '0');
    elsif rising_edge(clock) then
      -- data buffering
      if dataWr = '1' then
        dataAvail <= '1';
        dataOutBufferReg <= dataOut;
      end if;
      -- read buffered data
      if (slaveSel_int = '1' and dataAvail = '1' and dataValid1 = '1') or -- while sending
         (slaveSel_int = '0' and dataAvail = '1') then                    -- first transfer
        dataOutShiftReg <= dataOutBufferReg;
        dataAvail <= '0';
      elsif dataOutShift = '1' then
        dataOutShiftReg(dataOutShiftReg'high downto 1) <= dataOutShiftReg(dataOutShiftReg'high-1 downto 0);
      end if;
    end if;
  end process outputShiftReg;

  masterOut0 <= dataOutShiftReg(dataOutShiftReg'high);

  delayMasterOut: process(reset, clock)
  begin
    if reset = '1' then
      masterOut1 <= '0';
    elsif rising_edge(clock) then
      if en2x = '1' then
        masterOut1 <= masterOut0;
      end if;
    end if;
  end process delayMasterOut;

  deglitchOutputs: process(reset, clock)
  begin
    if reset = '1' then
      sClk         <= '0';
      MOSI         <= '0';
      slaveSel_int <= '0';
    elsif rising_edge(clock) then
      if cPol = '0' then
        sClk <= serialClock;
      else
        sClk <= not(serialClock);
      end if;
      if cPha = '0' then
        MOSI <= masterOut0;
      else
        MOSI <= masterOut1;
      end if;
      slaveSel_int <= sending;
    end if;
  end process deglitchOutputs;
  
  slaveSel <= slaveSel_int;

  ------------------------------------------------------------------------------
                                                                      -- data in
  dataInShift <= en2x
--      when (sequenceCounter(0) = '0') and (sending = '1')
      when ( (sequenceCounter(0) = '1') and (sending = '1') and (cPha = '0') )
        or ( (sequenceCounter(0) = '0') and (sending = '1') and (cPha = '1') )
    else '0';

  delayInShiftEn: process(reset, clock)
  begin
    if reset = '1' then
      dataInShift1 <= '0';
    elsif rising_edge(clock) then
      dataInShift1 <= dataInShift;
    end if;
  end process delayInShiftEn;

  inputShiftReg: process(reset, clock)
  begin
    if reset = '1' then
      dataInShiftReg <= (others => '0');
    elsif rising_edge(clock) then
      if dataInShift1 = '1' then
        dataInShiftReg(dataInShiftReg'high downto 1) <= dataInShiftReg(dataInShiftReg'high-1 downto 0);
        dataInShiftReg(0) <= MISO;
      end if;
    end if;
  end process inputShiftReg;

  delayCounterEnd: process(reset, clock)
  begin
    if reset = '1' then
      dataInEndDelayed <= '0';
    elsif rising_edge(clock) then
      dataInEndDelayed <= sequenceCounterEnd;
    end if;
  end process delayCounterEnd;

  dataInStore <= '1' when (sequenceCounterEnd = '0') and (dataInEndDelayed = '1') else '0';
--  dataInStore <= '1' when sequenceCounterEnd = '1';

  storeDataIn: process(reset, clock)
  begin
    if reset = '1' then
      dataIn <= (others => '0');
    elsif rising_edge(clock) then
      if dataInStore = '1' then
        dataIn <= dataInShiftReg;
      end if;
    end if;
  end process storeDataIn;

end RTL;


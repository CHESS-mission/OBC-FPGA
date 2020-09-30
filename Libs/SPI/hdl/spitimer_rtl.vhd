LIBRARY Common;
USE Common.CommonLib.all;

architecture RTL of spiTimer is

  signal clockPeriodCounter: unsigned(requiredBitNb(clockPeriod)-1 downto 0);
  signal clockPeriodEnd: std_uLogic;
  signal framePeriodCounter: unsigned(requiredBitNb(framePeriod)-1 downto 0);
  signal framePeriodEnd: std_uLogic;

begin

  divide1: process(reset, clock)
  begin
    if reset = '1' then
      clockPeriodCounter <= (others => '0');
    elsif rising_edge(clock) then
      if clockPeriodEnd = '1' then
        clockPeriodCounter <= (others => '0');
      else
        clockPeriodCounter <= clockPeriodCounter + 1;
      end if;
    end if;
  end process divide1;

  endOfCount1: process(clockPeriodCounter)
  begin
    if clockPeriodCounter >= clockPeriod-1 then
      clockPeriodEnd <= '1';
    else
      clockPeriodEnd <= '0';
    end if;
  end process endOfCount1;

  en2x <= clockPeriodEnd;

  divide2: process(reset, clock)
  begin
    if reset = '1' then
      framePeriodCounter <= (others => '0');
    elsif rising_edge(clock) then
      if framePeriodEnd = '1' then
        framePeriodCounter <= (others => '0');
      else
        framePeriodCounter <= framePeriodCounter + 1;
      end if;
    end if;
  end process divide2;

  endOfCount2: process(framePeriodCounter)
  begin
    if framePeriodCounter >= framePeriod-1 then
      framePeriodEnd <= '1';
    else
      framePeriodEnd <= '0';
    end if;
  end process endOfCount2;

  sendFrame <= framePeriodEnd;

end RTL;

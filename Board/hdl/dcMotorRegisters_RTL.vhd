ARCHITECTURE RTL OF sensorsRegisters IS

--  constant proximityBaseAddr : natural := baseAddress;
--  constant hallBaseAddr : natural := baseAddress + 2;
  constant registerLength: positive := 2*busDataIn'length;
  signal leds_int: unsigned(registerLength-1 downto 0);
  signal enDelayed: std_ulogic;

BEGIN
  ------------------------------------------------------------------------------
                                                         -- store bytes from I2C
  storeBytes: process(reset, clock)
  begin
    if reset = '1' then
      leds_int <= (others => '0');
    elsif rising_edge(clock) then
      if en = '1' then
        if write = '1' then
          case to_integer(busAddress) is
            when ledsBaseAddress =>
              leds_int(busDataIn'range) <= unsigned(busDataIn);
            when ledsBaseAddress+1 =>
              leds_int(
                leds_int'high downto leds_int'length-busDataIn'length
              ) <= unsigned(busDataIn);
            when others => null;
          end case;
        end if;
      end if;
    end if;
  end process storeBytes;

  ------------------------------------------------------------------------------
                                                                 -- update words
  storeValues: process(reset, clock)
  begin
    if reset = '1' then
      enDelayed <= '0';
      leds <= (others => '0');
    elsif rising_edge(clock) then
      enDelayed <= en;
      if enDelayed = '1' then
        if busAddress(0) = '1' then
          for index in leds'range loop
            leds(index) <= leds_int(index-1);
          end loop;
        end if;
      end if;
    end if;
  end process storeValues;

  --============================================================================
                                                            -- send bytes to I2C
  busDataOut <= (others => '1');

END ARCHITECTURE RTL;

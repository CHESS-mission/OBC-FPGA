ARCHITECTURE RTL OF sensorsRegisters IS

  constant registerLength: positive := 2*busDataIn'length;
  signal enDelayed: std_ulogic;

  signal leds_int: unsigned(registerLength-1 downto 0);

  type counterSetType is array(1 to hallSensorNb) of unsigned(hallCountBitNb-1 downto 0);
  signal counterSet: counterSetType;

  constant lightBaseAddress: natural := proximityBaseAddress + 2*proximitySensorNb;
  type lightSetType is array(1 to proximitySensorNb) of unsigned(ambientLightBitNb-1 downto 0);
  signal lightSet: lightSetType;
  type proximitySetType is array(1 to proximitySensorNb) of unsigned(proximityBitNb-1 downto 0);
  signal proximitySet: proximitySetType;

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
--        end if;
                                                   -- controls from other slaves
                                                 -- !!! adresses are offset by 1
 
        end if;
      end if;
    end if;
  end process storeBytes;

  proxyStart <= '1' when (en = '1') and (write = '0') and (busAddress = lightBaseAddress + 2*lightSet'length - 1)
    else '0';

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

  zeroHallCounters <= '0';

  --============================================================================
                                               -- build a vector of hall counters
  orderHallCountData: process(hallCount)
    variable offset : natural;
  begin
    for index in counterSet'range loop
      offset := (index-1) * counterSet(index)'length;
      counterSet(index) <= hallCount(counterSet(index)'high+offset downto offset);
    end loop;
  end process orderHallCountData;
                                         -- build a vector of ambient light data
  orderAmbientLightData: process(proxyLight)
    variable offset : natural;
  begin
    for index in lightSet'range loop
      offset := (index-1) * lightSet(index)'length;
      lightSet(index) <= proxyLight(lightSet(index)'high+offset downto offset);
    end loop;
  end process orderAmbientLightData;
                                             -- build a vector of proximity data
  orderProximityData: process(proxyDistance)
    variable offset : natural;
  begin
    for index in proximitySet'range loop
      offset := (index-1) * proximitySet(index)'length;
      proximitySet(index) <= proxyDistance(proximitySet(index)'high+offset downto offset);
    end loop;
  end process orderProximityData;

  --============================================================================
                                                        -- multiplex data to I2C
  sendStatus: process(
    busAddress,
    endSwitches, rangerDistance,
    counterSet,
    proximitySet, lightSet
  )
    variable hallIndex: natural;
    variable proximityIndex: natural;
    variable lightIndex: natural;
  begin
    busdataOut <= (others => '1');
    case to_integer(busAddress) is
                                                                 -- end switches
      when endSwitchBaseAddress =>
        busdataOut(endSwitches'range) <= not endSwitches;
                                                              -- distance ranger
      when rangeBaseAddress =>
        busdataOut <= std_ulogic_vector(rangerDistance(busdataOut'range));
      when rangeBaseAddress+1 =>
        busdataOut <= std_ulogic_vector(
          shift_right(rangerDistance, busdataOut'length)(busdataOut'range)
        );
                                                                 -- hall sensors
      when hallBaseAddress to hallBaseAddress + 2*counterSet'length - 1 =>
        hallIndex := (to_integer(busAddress) - hallBaseAddress) / 2 + 1;
        if busAddress(0) = '0' then
          busdataOut <= std_ulogic_vector(
            resize(counterSet(hallIndex), busdataOut'length)
          );
        else
          busdataOut <= std_ulogic_vector(
            resize(shift_right(counterSet(hallIndex), busdataOut'length), busdataOut'length)
          );
        end if;
                                                                    -- proximity
      when proximityBaseAddress to proximityBaseAddress + 2*proximitySet'length - 1 =>
        proximityIndex := (to_integer(busAddress) - proximityBaseAddress) / 2 + 1;
        if busAddress(0) = '0' then
          busdataOut <= std_ulogic_vector(
            resize(proximitySet(proximityIndex), busdataOut'length)
          );
        else
          busdataOut <= std_ulogic_vector(
            resize(shift_right(proximitySet(proximityIndex), busdataOut'length), busdataOut'length)
          );
        end if;
                                                                        -- light
      when lightBaseAddress to lightBaseAddress + 2*lightSet'length - 1 =>
        lightIndex := (to_integer(busAddress) - lightBaseAddress) / 2 + 1;
        if busAddress(0) = '0' then
          busdataOut <= std_ulogic_vector(
            resize(lightSet(lightIndex), busdataOut'length)
          );
        else
          busdataOut <= std_ulogic_vector(
            resize(shift_right(lightSet(lightIndex), busdataOut'length), busdataOut'length)
          );
        end if;
      when others => null;
    end case;
  end process sendStatus;

END ARCHITECTURE RTL;

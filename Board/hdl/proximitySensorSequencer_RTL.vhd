library Common;
  use Common.CommonLib.all;

ARCHITECTURE RTL OF proximitySensorSequencer IS

  constant sequenceLength : positive := 6+4 + 2*6 + 5;
  signal sequenceCounter: unsigned(requiredBitNb(sequenceLength)-1 downto 0);

  constant i2cWordBitNb: positive := dataBitNb-2;
  subtype i2cWordType is std_ulogic_vector(i2cWordBitNb-1 downto 0);
  constant i2cStart                     : i2cWordType := X"00";
  constant i2cStop                      : i2cWordType := X"FF";
  constant i2cRead                      : i2cWordType := X"FF";
  constant distanceSensorAddress        : i2cWordType := X"26";
  constant commandRegisterAddress       : i2cWordType := X"80";
  constant ledCurrentRegisterAddress    : i2cWordType := X"83";
  constant lightRegisterAddress         : i2cWordType := X"85";
  constant proximityRegisterAddress     : i2cWordType := X"87";
  constant frequencyRegisterAddress     : i2cWordType := X"89";
  constant acquisitionStart             : i2cWordType := X"18";
  constant ledCurrentInit               : i2cWordType := X"14";
  constant acquisitionParamsInit        : i2cWordType := X"08";
  constant frequencyInit                : i2cWordType := X"03";
  constant timingsParamsInit            : i2cWordType := X"81";
  signal startStop: std_ulogic;
  signal i2cWord: i2cWordType;
  signal ack: std_ulogic;

  constant readLength : positive := 4;
  signal readCounter: unsigned(requiredBitNb(readLength)-1 downto 0);
  signal dataWord: unsigned(sensorNb*i2cWordBitNb-1 downto 0);
  signal ambientLightH, ambientLightL: unsigned(sensorNb*i2cWordBitNb-1 downto 0);
  signal proximityH, proximityL: unsigned(sensorNb*i2cWordBitNb-1 downto 0);

BEGIN
  --============================================================================
                                                          -- count send sequence
  countSequence: process(reset, clock)
  begin
    if reset = '1' then
      sequenceCounter <= (others => '0');
    elsif rising_edge(clock) then
      if sequenceCounter = 0 then
        if start = '1' then
          sequenceCounter <= sequenceCounter + 1;
        end if;
      else
        if txBusy = '0' then
          if sequenceCounter < sequenceLength then
            sequenceCounter <= sequenceCounter + 1;
          else
            sequenceCounter <= (others => '0');
          end if;
        end if;
      end if;
    end if;
  end process countSequence;

  --============================================================================
                                                            -- send I2C commands
  sendI2cCommands: process(sequenceCounter)
  begin
    startStop <= '0';
    i2cWord <= (others => '0');
    ack <= '1';
    case to_integer(sequenceCounter) is
                                             -- read ambient light and proximity
      when  1 => startStop <= '1'; i2cWord <= i2cStart;
      when  2 => i2cWord <= distanceSensorAddress;
      when  3 => i2cWord <= lightRegisterAddress;
      when  4 => startStop <= '1'; i2cWord <= i2cStart;
      when  5 => i2cWord <= distanceSensorAddress or X"01";
      when  6 => i2cWord <= i2cRead; ack <= '0';
      when  7 => i2cWord <= i2cRead; ack <= '0';
      when  8 => i2cWord <= i2cRead; ack <= '0';
      when  9 => i2cWord <= i2cRead;
      when 10 => startStop <= '1'; i2cWord <= i2cStop;
                                                 -- setup acquisition parameters
      when 11 => startStop <= '1'; i2cWord <= i2cStart;
      when 12 => i2cWord <= distanceSensorAddress;
      when 13 => i2cWord <= ledCurrentRegisterAddress;
      when 14 => i2cWord <= ledCurrentInit;
      when 15 => i2cWord <= acquisitionParamsInit;
      when 16 => startStop <= '1'; i2cWord <= i2cStop;
                                          -- setup frequency and time parameters
      when 17 => startStop <= '1'; i2cWord <= i2cStart;
      when 18 => i2cWord <= distanceSensorAddress;
      when 19 => i2cWord <= frequencyRegisterAddress;
      when 20 => i2cWord <= frequencyInit;
      when 21 => i2cWord <= timingsParamsInit;
      when 22 => startStop <= '1'; i2cWord <= i2cStop;
                                                      -- start a new acquisition
      when 23 => startStop <= '1'; i2cWord <= i2cStart;
      when 24 => i2cWord <= distanceSensorAddress;
      when 25 => i2cWord <= commandRegisterAddress;
      when 26 => i2cWord <= acquisitionStart;
      when 27 => startStop <= '1'; i2cWord <= i2cStop;
      when others => null;
    end case;
  end process sendI2cCommands;

  txData <= startStop & ack & i2cWord;
  txSend <= '1' when (sequenceCounter > 0) and (txBusy = '0')
    else '0';

  --============================================================================
                                                           -- read data from I2C
  ------------------------------------------------------------------------------
                                      -- read counter increments with input data
  readFSM: process(reset, clock)
  begin
    if reset = '1' then
      readCounter <= (others => '0');
    elsif rising_edge(clock) then
                                               -- start condition clears counter
      if (rxDataValid = '1') and (rxData(rxData'high) = '1') and (rxData(rxData'high) = '0') then
        readCounter <= (others => '0');
                                                 -- chip address starts counting
      elsif readCounter = 0 then
        if (rxDataValid = '1') and (rxData(dataBitNb-3 downto 0) = (distanceSensorAddress or X"01")) then
          readCounter <= readCounter + 1;
        end if;
      else
        if rxDataValid = '1' then
                                     -- acknowledge defines when to stop counter
          if rxData(dataBitNb-2) = '0' then
            readCounter <= readCounter + 1;
          else
            readCounter <= (others => '0');
          end if;
        end if;
      end if;
    end if;
  end process readFSM;

  ------------------------------------------------------------------------------
                                 -- remove start/stop and ACK bits from I2C data
  trimcontrolBits: process(rxData)
    variable regOffset, i2cOffset: natural;
  begin
    for index in 1 to sensorNb loop
      regOffset := i2cWordBitNb*(index-1);
      i2cOffset := dataBitNb*(index-1);
      dataWord(i2cWordBitNb-1+regOffset downto regOffset) <= unsigned(
        rxData(i2cWordBitNb-1+i2cOffset downto i2cOffset)
      );
    end loop;
  end process trimcontrolBits;

  ------------------------------------------------------------------------------
                                   -- store all high and then all low data bytes
  storeData: process(reset, clock)
  begin
    if reset = '1' then
      ambientLightH <= (others => '0');
      ambientLightL <= (others => '0');
      proximityH <= (others => '0');
      proximityL <= (others => '0');
    elsif rising_edge(clock) then
      if rxDataValid = '1' then
        case to_integer(readCounter) is
          when 1 => ambientLightH <= dataWord;
          when 2 => ambientLightL <= dataWord;
          when 3 => proximityH    <= dataWord;
          when 4 => proximityL    <= dataWord;
          when others => null;
        end case;
      end if;
    end if;
  end process storeData;

  ------------------------------------------------------------------------------
                                          -- put high and low bits back together
  interleaveBytes: process(
    ambientLightL, ambientLightH,
    proximityL, proximityH
  )
    variable regOffset, vectOffsetH, vectOffsetL: natural;
  begin
    for index in 1 to sensorNb loop
      regOffset := i2cWordBitNb*(index-1);
      vectOffsetL := 2*i2cWordBitNb*(index-1);
      vectOffsetH := vectOffsetL + i2cWordBitNb;
      ambientLight(i2cWordBitNb-1+vectOffsetL downto vectOffsetL) <=
        ambientLightL(i2cWordBitNb-1+regOffset downto regOffset);
      ambientLight(i2cWordBitNb-1+vectOffsetH downto vectOffsetH) <=
        ambientLightH(i2cWordBitNb-1+regOffset downto regOffset);
      proximity(i2cWordBitNb-1+vectOffsetL downto vectOffsetL) <=
        proximityL(i2cWordBitNb-1+regOffset downto regOffset);
      proximity(i2cWordBitNb-1+vectOffsetH downto vectOffsetH) <=
        proximityH(i2cWordBitNb-1+regOffset downto regOffset);
    end loop;
  end process interleaveBytes;

END ARCHITECTURE RTL;

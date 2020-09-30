--
-- VHDL Architecture SPI.spiWrite.rtl
--
-- Created:
--          by - uadmin.UNKNOWN (WE3877)
--          at - 08:57:33 26.09.2012
--
-- using Mentor Graphics HDL Designer(TM) 2009.2 (Build 10)
--
ARCHITECTURE rtl OF spiWrite IS

  signal dataWr_int : std_ulogic;
  
  -- FSM
  type readStateType is (
    idle,
    write_data,
    wait_nBusy
  );
  signal readState     : readStateType;

BEGIN

---------------------------------------------------------
-- FSM NextState
--
  readFsm: process(reset, clock)
  begin
    if reset = '1' then
      readState <= idle;
    elsif rising_edge(clock) then
      case readState is
        when idle =>
          if dataOutEmpty = '0' and busy = '0' then
            readState <= write_data;
          end if;
        when write_data =>
          readState <= wait_nBusy;
        when wait_nBusy =>
          if busy = '0' then
            if dataOutEmpty = '1' then
              readState <= idle;
            else
              readState <= write_data;
            end if;
          end if;
        when others => 
          readState <= idle;
      end case;
    end if;
  end process readFsm;

---------------------------------------------------------
-- FSM output
--
  outputFsm: process(readState,dataOutEmpty,sendFrame)
  begin
    -- Default values
    dataOutRd <= '0';
    dataWr_int <= '0';
    case readState is
      when idle =>
      when write_data =>
        if (dataOutEmpty = '0') and (sendFrame = '1') then
          dataOutRd <= '1';
          dataWr_int <= '1';
        end if;
      when wait_nBusy =>
    end case;
  end process outputFsm;

---------------------------------------------------------
-- Concurrent Statement 
--
  dataOutEnabled <= dataOut when dataOutEmpty = '0'
               else (others => '1');
  dataWr <= dataWr_int;
  
END ARCHITECTURE rtl;


--
-- VHDL Architecture SPI.spiFifo.struct
--
-- Created:
--          by - student.UNKNOWN (DESKTOP-3I0F3HP)
--          at - 15:42:56 28.07.2020
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2019.2 (Build 5)
--
LIBRARY ieee;
  USE ieee.std_logic_1164.all;
  USE ieee.numeric_std.ALL;

LIBRARY Memory;
LIBRARY SPI;

ARCHITECTURE struct OF spiFifo IS

   -- Architecture declarations

   -- Internal signal declarations
   SIGNAL dataValid         : std_ulogic;
   SIGNAL dataIn            : std_ulogic_vector(dataBitNb-1 DOWNTO 0);
   SIGNAL en2x              : std_ulogic;
   SIGNAL dataOut           : std_ulogic_vector(dataBitNb-1 DOWNTO 0);
   SIGNAL slaveSel          : std_ulogic;
   SIGNAL dataOutEnabled    : std_ulogic_vector(dataBitNb-1 DOWNTO 0);
   SIGNAL dataOutEmpty      : std_ulogic;
   SIGNAL sendFrame         : std_ulogic;
   SIGNAL dataOutRd         : std_ulogic;
   SIGNAL busy              : std_ulogic;
   SIGNAL dataWr            : std_ulogic;
   SIGNAL endTransfer_delay : std_ulogic;
   SIGNAL endTransfer_int   : std_ulogic;


   -- Component Declarations
   COMPONENT FIFO
   GENERIC (
      dataBitNb : positive := 8;
      depth     : positive := 8
   );
   PORT (
      write   : IN     std_ulogic ;
      clock   : IN     std_ulogic ;
      reset   : IN     std_ulogic ;
      dataOut : OUT    std_ulogic_vector (dataBitNb-1 DOWNTO 0);
      read    : IN     std_ulogic ;
      dataIn  : IN     std_ulogic_vector (dataBitNb-1 DOWNTO 0);
      empty   : OUT    std_ulogic ;
      full    : OUT    std_ulogic 
   );
   END COMPONENT;
   COMPONENT spiTimer
   GENERIC (
      clockPeriod : positive := 1;
      framePeriod : positive := 1
   );
   PORT (
      en2x      : OUT    std_ulogic ;
      clock     : IN     std_ulogic ;
      reset     : IN     std_ulogic ;
      sendFrame : OUT    std_ulogic 
   );
   END COMPONENT;
   COMPONENT spiTransceiver
   GENERIC (
      dataBitNb : positive   := 8;
      cPol      : std_ulogic := '0';
      cPha      : std_ulogic := '0'
   );
   PORT (
      sClk      : OUT    std_ulogic ;
      clock     : IN     std_ulogic ;
      reset     : IN     std_ulogic ;
      dataOut   : IN     std_ulogic_vector (dataBitNb-1 DOWNTO 0);
      dataWr    : IN     std_ulogic ;
      dataIn    : OUT    std_ulogic_vector (dataBitNb-1 DOWNTO 0);
      en2x      : IN     std_ulogic ;
      MOSI      : OUT    std_ulogic ;
      MISO      : IN     std_ulogic ;
      slaveSel  : OUT    std_ulogic ;
      dataValid : OUT    std_ulogic ;
      busy      : OUT    std_ulogic 
   );
   END COMPONENT;
   COMPONENT spiWrite
   GENERIC (
      dataBitNb : positive := 8
   );
   PORT (
      reset          : IN     std_ulogic ;
      clock          : IN     std_ulogic ;
      dataOut        : IN     std_ulogic_vector (dataBitNb-1 DOWNTO 0);
      dataOutEmpty   : IN     std_ulogic ;
      dataOutEnabled : OUT    std_ulogic_vector (dataBitNb-1 DOWNTO 0);
      dataOutRd      : OUT    std_ulogic ;
      busy           : IN     std_ulogic ;
      sendFrame      : IN     std_ulogic ;
      dataWr         : OUT    std_ulogic 
   );
   END COMPONENT;

   -- Optional embedded configurations
   -- pragma synthesis_off
   FOR ALL : FIFO USE ENTITY Memory.FIFO;
   FOR ALL : spiTimer USE ENTITY SPI.spiTimer;
   FOR ALL : spiTransceiver USE ENTITY SPI.spiTransceiver;
   FOR ALL : spiWrite USE ENTITY SPI.spiWrite;
   -- pragma synthesis_on


BEGIN
   -- Architecture concurrent statements
   -- HDL Embedded Text Block 1 endTranser_gen
   endTransfer_int <= dataValid and not slaveSel;
   -- Add delay for FIFO to write data
   delay: process(reset, clock)
   begin
     if reset = '1' then
       endTransfer_delay <= '0';
       endTransfer <= '0';    
     elsif rising_edge(clock) then
       endTransfer_delay <= endTransfer_int;
       endTransfer <= endTransfer_delay;
     end if;
   end process delay; 

   -- HDL Embedded Text Block 2 inv_SS
   SS_n <= not slaveSel;


   -- Instance port mappings.
   Master_FIFO : FIFO
      GENERIC MAP (
         dataBitNb => dataBitNb,
         depth     => fifoDepth
      )
      PORT MAP (
         write   => masterWr,
         clock   => clock,
         reset   => reset,
         dataOut => dataOut,
         read    => dataOutRd,
         dataIn  => masterData,
         empty   => dataOutEmpty,
         full    => masterFull
      );
   Slave_FIFO : FIFO
      GENERIC MAP (
         dataBitNb => dataBitNb,
         depth     => fifoDepth
      )
      PORT MAP (
         write   => dataValid,
         clock   => clock,
         reset   => reset,
         dataOut => slaveData,
         read    => slaveRd,
         dataIn  => dataIn,
         empty   => slaveEmpty,
         full    => OPEN
      );
   spiTimer_inst : spiTimer
      GENERIC MAP (
         clockPeriod => spiClockPeriod,
         framePeriod => spiFramePeriod
      )
      PORT MAP (
         en2x      => en2x,
         clock     => clock,
         reset     => reset,
         sendFrame => sendFrame
      );
   spiTransceiver_inst : spiTransceiver
      GENERIC MAP (
         dataBitNb => dataBitNb,
         cPol      => cPol,
         cPha      => cPha
      )
      PORT MAP (
         sClk      => sClk,
         clock     => clock,
         reset     => reset,
         dataOut   => dataOutEnabled,
         dataWr    => dataWr,
         dataIn    => dataIn,
         en2x      => en2x,
         MOSI      => MOSI,
         MISO      => MISO,
         slaveSel  => slaveSel,
         dataValid => dataValid,
         busy      => busy
      );
   spiWrite_inst : spiWrite
      GENERIC MAP (
         dataBitNb => databitNb
      )
      PORT MAP (
         reset          => reset,
         clock          => clock,
         dataOut        => dataOut,
         dataOutEmpty   => dataOutEmpty,
         dataOutEnabled => dataOutEnabled,
         dataOutRd      => dataOutRd,
         busy           => busy,
         sendFrame      => sendFrame,
         dataWr         => dataWr
      );

END struct;
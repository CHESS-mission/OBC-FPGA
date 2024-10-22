--
-- VHDL Architecture Board.obc_test_circuit.struct
--
-- Created:
--          by - student.UNKNOWN (DESKTOP-3I0F3HP)
--          at - 13:24:14 07.08.2020
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2019.2 (Build 5)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
LIBRARY gates;
USE gates.gates.all;
USE ieee.numeric_std.all;

LIBRARY Board;
LIBRARY OBC;
LIBRARY RiscV;
LIBRARY SPI;

ARCHITECTURE struct OF obc_test_circuit IS

   -- Architecture declarations

   -- Internal signal declarations
   SIGNAL SPI1                 : std_logic_vector(PinNumber-1 DOWNTO 0);
   SIGNAL SPI2                 : std_logic_vector(PinNumber-1 DOWNTO 0);
   SIGNAL SPI3                 : std_logic_vector(PinNumber-1 DOWNTO 0);
   SIGNAL SPI4                 : std_logic_vector(PinNumber-1 DOWNTO 0);
   SIGNAL SPI4_DataIn          : std_ulogic_vector(dataBitNb-1 DOWNTO 0);
   SIGNAL SPI4_endTransfer     : std_logic;
   SIGNAL SPI4_masterFull      : std_ulogic;
   SIGNAL SPI4_slaveEmpty      : std_ulogic;
   SIGNAL SS_n                 : std_ulogic;
   SIGNAL io_gpioA_read        : std_logic_vector(31 DOWNTO 0);
   SIGNAL io_gpioA_write       : std_logic_vector(31 DOWNTO 0);
   SIGNAL io_gpioA_writeEnable : std_logic_vector(31 DOWNTO 0);
   SIGNAL io_gpioB_read        : std_logic_vector(31 DOWNTO 0);
   SIGNAL io_gpioB_write       : std_logic_vector(31 DOWNTO 0);
   SIGNAL io_gpioB_writeEnable : std_logic_vector(31 DOWNTO 0);
   SIGNAL io_gpioC_read        : std_logic_vector(31 DOWNTO 0);
   SIGNAL io_gpioC_write       : std_logic_vector(31 DOWNTO 0);
   SIGNAL io_gpioC_writeEnable : std_logic_vector(31 DOWNTO 0);
   SIGNAL io_gpioD_read        : std_logic_vector(31 DOWNTO 0);
   SIGNAL io_gpioD_write       : std_logic_vector(31 DOWNTO 0);
   SIGNAL io_gpioD_writeEnable : std_logic_vector(31 DOWNTO 0);
   SIGNAL io_jtag_tck          : std_logic;
   SIGNAL io_jtag_tdi          : std_logic;
   SIGNAL io_jtag_tdo          : std_logic;
   SIGNAL io_jtag_tms          : std_logic;
   SIGNAL logic1               : std_uLogic;
   SIGNAL reset                : std_ulogic;
   SIGNAL resetSnch_N          : std_ulogic;
   SIGNAL resetSynch           : std_ulogic;


   -- Component Declarations
   COMPONENT DFF
   PORT (
      CLK : IN     std_uLogic ;
      CLR : IN     std_uLogic ;
      D   : IN     std_uLogic ;
      Q   : OUT    std_uLogic 
   );
   END COMPONENT;
   COMPONENT SPI_IO_Tristate
   GENERIC (
      dataBitNb : integer := 8;
      PinNumber : integer := 32
   );
   PORT (
      SPI_DataIn       : IN     std_ulogic_vector (dataBitNb-1 DOWNTO 0);
      SPI_endTransfer  : IN     std_logic ;
      SPI_masterFull   : IN     std_ulogic ;
      SPI_slaveEmpty   : IN     std_ulogic ;
      writeEnable_Risc : IN     std_logic_vector (PinNumber-1 DOWNTO 0);
      DataIn           : OUT    std_logic_vector (dataBitNb-1 DOWNTO 0);
      endTransfer      : OUT    std_uLogic ;
      masterFull       : OUT    std_uLogic ;
      slaveEmpty       : OUT    std_uLogic 
   );
   END COMPONENT;
   COMPONENT inverterIn
   PORT (
      in1  : IN     std_uLogic ;
      out1 : OUT    std_uLogic 
   );
   END COMPONENT;
   COMPONENT bufferUlogic
   GENERIC (
      delay : time := gateDelay
   );
   PORT (
      in1  : IN     std_uLogic ;
      out1 : OUT    std_uLogic 
   );
   END COMPONENT;
   COMPONENT SPI_SlaveSelect
   PORT (
      SS_n        : IN     std_ulogic ;
      SlaveSelect : IN     std_ulogic_vector (1 DOWNTO 0);
      SS1_n       : OUT    std_ulogic ;
      SS2_n       : OUT    std_ulogic ;
      SS3_n       : OUT    std_ulogic 
   );
   END COMPONENT;
   COMPONENT Test
   PORT (
      clock : IN     std_ulogic ;
      reset : IN     std_ulogic ;
      Led1  : OUT    std_logic ;
      Led2  : OUT    std_logic ;
      Led3  : OUT    std_logic ;
      Led4  : OUT    std_logic ;
      Led5  : OUT    std_logic 
   );
   END COMPONENT;
   COMPONENT gpioBankControl
   GENERIC (
      PinNumber : positive := 32
   );
   PORT (
      write   : IN     std_logic_vector (PinNumber-1 DOWNTO 0);
      writeEn : IN     std_logic_vector (PinNumber-1 DOWNTO 0);
      read    : OUT    std_logic_vector (PinNumber-1 DOWNTO 0);
      pins    : INOUT  std_logic_vector (PinNumber-1 DOWNTO 0)
   );
   END COMPONENT;
   COMPONENT Murax
   PORT (
      io_asyncReset        : IN     std_ulogic;
      io_gpioA_read        : IN     std_logic_vector (31 DOWNTO 0);
      io_jtag_tck          : IN     std_logic;
      io_jtag_tdi          : IN     std_logic;
      io_jtag_tms          : IN     std_logic;
      io_mainClk           : IN     std_ulogic;
      io_gpioA_write       : OUT    std_logic_vector (31 DOWNTO 0);
      io_gpioA_writeEnable : OUT    std_logic_vector (31 DOWNTO 0);
      io_jtag_tdo          : OUT    std_logic
   );
   END COMPONENT;
   COMPONENT spiFifo
   GENERIC (
      dataBitNb      : positive   := 8;
      fifoDepth      : positive   := 8;      --Max nbr of sequential transfers
      spiClockPeriod : positive   := 1;      --SPI clock divider
      spiFramePeriod : positive   := 1;      --SPI Inter Frame Gap
      cPol           : std_ulogic := '0';
      cPha           : std_ulogic := '0'
   );
   PORT (
      slaveRd     : IN     std_ulogic ;
      slaveData   : OUT    std_ulogic_vector (dataBitNb-1 DOWNTO 0);
      clock       : IN     std_ulogic ;
      MISO        : IN     std_ulogic ;
      reset       : IN     std_ulogic ;
      MOSI        : OUT    std_ulogic ;
      slaveEmpty  : OUT    std_ulogic ;
      masterFull  : OUT    std_ulogic ;
      masterData  : IN     std_ulogic_vector (dataBitNb-1 DOWNTO 0);
      masterWr    : IN     std_ulogic ;
      sClk        : OUT    std_ulogic ;
      endTransfer : OUT    std_logic ;
      SS_n        : OUT    std_ulogic 
   );
   END COMPONENT;

   -- Optional embedded configurations
   -- pragma synthesis_off
   FOR ALL : DFF USE ENTITY Board.DFF;
   FOR ALL : SPI_IO_Tristate USE ENTITY Board.SPI_IO_Tristate;
   FOR ALL : SPI_SlaveSelect USE ENTITY OBC.SPI_SlaveSelect;
   FOR ALL : Test USE ENTITY OBC.Test;
   FOR ALL : bufferUlogic USE ENTITY Gates.bufferUlogic;
   FOR ALL : gpioBankControl USE ENTITY OBC.gpioBankControl;
   FOR ALL : inverterIn USE ENTITY Board.inverterIn;
   FOR ALL : spiFifo USE ENTITY SPI.spiFifo;
   -- pragma synthesis_on


BEGIN
   -- Architecture concurrent statements
   -- HDL Embedded Text Block 5 eb5
   logic1 <= '1';


   -- Instance port mappings.
   I_dff : DFF
      PORT MAP (
         CLK => clock,
         CLR => reset,
         D   => logic1,
         Q   => resetSnch_N
      );
   I14 : SPI_IO_Tristate
      GENERIC MAP (
         dataBitNb => 8,
         PinNumber => 32
      )
      PORT MAP (
         SPI_DataIn       => SPI4_DataIn,
         SPI_endTransfer  => SPI4_endTransfer,
         SPI_masterFull   => SPI4_masterFull,
         SPI_slaveEmpty   => SPI4_slaveEmpty,
         writeEnable_Risc => io_gpioD_writeEnable,
         DataIn           => SPI4(15 DOWNTO 8),
         endTransfer      => SPI4(20),
         masterFull       => SPI4(17),
         slaveEmpty       => SPI4(19)
      );
   I_inv1 : inverterIn
      PORT MAP (
         in1  => reset_N,
         out1 => reset
      );
   I_inv2 : inverterIn
      PORT MAP (
         in1  => resetSnch_N,
         out1 => resetSynch
      );
   I6 : bufferUlogic
      GENERIC MAP (
         delay => gateDelay
      )
      PORT MAP (
         in1  => SPI1_MISO,
         out1 => SPI1_unused
      );
   I7 : bufferUlogic
      GENERIC MAP (
         delay => gateDelay
      )
      PORT MAP (
         in1  => SPI2_MISO,
         out1 => SPI2_unused
      );
   I8 : bufferUlogic
      GENERIC MAP (
         delay => gateDelay
      )
      PORT MAP (
         in1  => SPI3_MISO,
         out1 => SPI3_unused
      );
   I9 : bufferUlogic
      GENERIC MAP (
         delay => gateDelay
      )
      PORT MAP (
         in1  => SPI4_MISO,
         out1 => SPI4_unused
      );
   U_0 : bufferUlogic
      GENERIC MAP (
         delay => gateDelay
      )
      PORT MAP (
         in1  => fpgaIO0,
         out1 => io_jtag_tms
      );
   U_1 : bufferUlogic
      GENERIC MAP (
         delay => gateDelay
      )
      PORT MAP (
         in1  => fpgaIO1,
         out1 => io_jtag_tdi
      );
   U_5 : bufferUlogic
      GENERIC MAP (
         delay => gateDelay
      )
      PORT MAP (
         in1  => fpgaIO2,
         out1 => io_jtag_tck
      );
   U_6 : bufferUlogic
      GENERIC MAP (
         delay => gateDelay
      )
      PORT MAP (
         in1  => io_jtag_tdo,
         out1 => fpgaIO3
      );
   U_3 : SPI_SlaveSelect
      PORT MAP (
         SS_n        => SS_n,
         SlaveSelect => SPI4(22 DOWNTO 21),
         SS1_n       => SPI4_SS1_n,
         SS2_n       => SPI4_SS2_n,
         SS3_n       => OPEN
      );
   I1 : Test
      PORT MAP (
         clock => clock,
         reset => resetSynch,
         Led1  => Led1,
         Led2  => Led2,
         Led3  => Led3,
         Led4  => Led4,
         Led5  => Led5
      );
   I2 : gpioBankControl
      GENERIC MAP (
         PinNumber => 32
      )
      PORT MAP (
         write   => io_gpioA_write,
         writeEn => io_gpioA_writeEnable,
         read    => io_gpioA_read,
         pins    => SPI1
      );
   I3 : gpioBankControl
      GENERIC MAP (
         PinNumber => 32
      )
      PORT MAP (
         write   => io_gpioB_write,
         writeEn => io_gpioB_writeEnable,
         read    => io_gpioB_read,
         pins    => SPI2
      );
   I4 : gpioBankControl
      GENERIC MAP (
         PinNumber => 32
      )
      PORT MAP (
         write   => io_gpioC_write,
         writeEn => io_gpioC_writeEnable,
         read    => io_gpioC_read,
         pins    => SPI3
      );
   I5 : gpioBankControl
      GENERIC MAP (
         PinNumber => 32
      )
      PORT MAP (
         write   => io_gpioD_write,
         writeEn => io_gpioD_writeEnable,
         read    => io_gpioD_read,
         pins    => SPI4
      );
   U_4 : Murax
      PORT MAP (
         io_asyncReset        => reset,
         io_mainClk           => clock,
         io_jtag_tms          => io_jtag_tms,
         io_jtag_tdi          => io_jtag_tdi,
         io_jtag_tdo          => io_jtag_tdo,
         io_jtag_tck          => io_jtag_tck,
         io_gpioA_read        => io_gpioD_read,
         io_gpioA_write       => io_gpioD_write,
         io_gpioA_writeEnable => io_gpioD_writeEnable
      );
   U_2 : spiFifo
      GENERIC MAP (
         dataBitNb      => 8,
         fifoDepth      => 64,          --Max nbr of sequential transfers
         spiClockPeriod => 640,         --SPI clock divider
         spiFramePeriod => 64,          --SPI Inter Frame Gap
         cPol           => '0',
         cPha           => '0'
      )
      PORT MAP (
         slaveRd     => SPI4(18),
         slaveData   => SPI4_DataIn,
         clock       => clock,
         MISO        => SPI4_MISO,
         reset       => resetSynch,
         MOSI        => SPI4_MOSI,
         slaveEmpty  => SPI4_slaveEmpty,
         masterFull  => SPI4_masterFull,
         masterData  => SPI4(7 DOWNTO 0),
         masterWr    => SPI4(16),
         sClk        => SPI4_sClk,
         endTransfer => SPI4_endTransfer,
         SS_n        => SS_n
      );

END struct;

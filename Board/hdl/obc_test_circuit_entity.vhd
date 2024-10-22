-- VHDL Entity Board.obc_test_circuit.symbol
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

ENTITY obc_test_circuit IS
   GENERIC( 
      PinNumber : integer := 32;
      dataBitNb : integer := 8
   );
   PORT( 
      SPI1_MISO   : IN     std_ulogic;
      SPI2_MISO   : IN     std_ulogic;
      SPI3_MISO   : IN     std_ulogic;
      SPI4_MISO   : IN     std_ulogic;
      clock       : IN     std_ulogic;
      fpgaIO0     : IN     std_logic;
      fpgaIO1     : IN     std_logic;
      fpgaIO2     : IN     std_logic;
      reset_N     : IN     std_ulogic;
      ICSPCLK     : OUT    std_logic;
      ICSPDAT     : OUT    std_logic;
      Led1        : OUT    std_logic;
      Led2        : OUT    std_logic;
      Led3        : OUT    std_logic;
      Led4        : OUT    std_logic;
      Led5        : OUT    std_logic;
      MCLR        : OUT    std_logic;
      SPI1_MOSI   : OUT    std_ulogic;
      SPI1_SS1_n  : OUT    std_ulogic;
      SPI1_SS2_n  : OUT    std_ulogic;
      SPI1_SS3_n  : OUT    std_ulogic;
      SPI1_sClk   : OUT    std_ulogic;
      SPI1_unused : OUT    std_uLogic;
      SPI2_MOSI   : OUT    std_ulogic;
      SPI2_SS1_n  : OUT    std_ulogic;
      SPI2_sClk   : OUT    std_ulogic;
      SPI2_unused : OUT    std_uLogic;
      SPI3_MOSI   : OUT    std_ulogic;
      SPI3_SS1_n  : OUT    std_ulogic;
      SPI3_SS2_n  : OUT    std_ulogic;
      SPI3_sClk   : OUT    std_ulogic;
      SPI3_unused : OUT    std_uLogic;
      SPI4_MOSI   : OUT    std_ulogic;
      SPI4_SS1_n  : OUT    std_ulogic;
      SPI4_SS2_n  : OUT    std_ulogic;
      SPI4_sClk   : OUT    std_ulogic;
      SPI4_unused : OUT    std_uLogic;
      fpgaIO3     : OUT    std_logic;
      fpgaIO4     : OUT    std_logic;
      fpgaIO5     : OUT    std_logic;
      fpgaIO6     : OUT    std_logic;
      mem_Hold    : OUT    std_logic;
      mem_WP      : OUT    std_logic
   );

-- Declarations

END obc_test_circuit ;


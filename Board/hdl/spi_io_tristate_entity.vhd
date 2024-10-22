-- VHDL Entity Board.SPI_IO_Tristate.symbol
--
-- Created:
--          by - student.UNKNOWN (DESKTOP-3I0F3HP)
--          at - 15:56:23 02.08.2020
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2019.2 (Build 5)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY SPI_IO_Tristate IS
   GENERIC( 
      dataBitNb : integer := 8;
      PinNumber : integer := 32
   );
   PORT( 
      SPI_DataIn       : IN     std_ulogic_vector (dataBitNb-1 DOWNTO 0);
      SPI_endTransfer  : IN     std_logic;
      SPI_masterFull   : IN     std_ulogic;
      SPI_slaveEmpty   : IN     std_ulogic;
      writeEnable_Risc : IN     std_logic_vector (PinNumber-1 DOWNTO 0);
      DataIn           : OUT    std_logic_vector (dataBitNb-1 DOWNTO 0);
      endTransfer      : OUT    std_uLogic;
      masterFull       : OUT    std_uLogic;
      slaveEmpty       : OUT    std_uLogic
   );

-- Declarations

END SPI_IO_Tristate ;


-- VHDL Entity OBC.gpioBankControl.symbol
--
-- Created:
--          by - student.UNKNOWN (DESKTOP-3I0F3HP)
--          at - 09:50:45 01.08.2020
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2019.2 (Build 5)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY gpioBankControl IS
   GENERIC( 
      PinNumber : positive := 32
   );
   PORT( 
      write   : IN     std_logic_vector (PinNumber-1 DOWNTO 0);
      writeEn : IN     std_logic_vector (PinNumber-1 DOWNTO 0);
      read    : OUT    std_logic_vector (PinNumber-1 DOWNTO 0);
      pins    : INOUT  std_logic_vector (PinNumber-1 DOWNTO 0)
   );

-- Declarations

END gpioBankControl ;


-- VHDL Entity IO.tristateBufferULogicVector.symbol
--
-- Created:
--          by - student.UNKNOWN (DESKTOP-3I0F3HP)
--          at - 16:37:54 20.08.2009
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2019.2 (Build 5)
--
LIBRARY ieee;
  USE ieee.std_logic_1164.all;
LIBRARY gates;
  USE gates.gates.all;

ENTITY tristateBufferULogicVector IS
   GENERIC( 
      dataNbBits : positive := 8;
      delay      : time     := gateDelay
   );
   PORT( 
      OE   : IN     std_ulogic;
      in1  : IN     std_uLogic_vector (dataNbBits-1 DOWNTO 0);
      out1 : OUT    std_Logic_vector (dataNbBits-1 DOWNTO 0)
   );

-- Declarations

END tristateBufferULogicVector ;


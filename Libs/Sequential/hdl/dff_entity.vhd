-- VHDL Entity Sequential.DFF.symbol
--
-- Created:
--          by - student.UNKNOWN (DESKTOP-3I0F3HP)
--          at - 12:22:48 23.11.2017
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2019.2 (Build 5)
--
LIBRARY ieee;
  USE ieee.std_logic_1164.all;
LIBRARY gates;
  USE gates.gates.all;

ENTITY DFF IS
   GENERIC( 
      delay : time := gateDelay
   );
   PORT( 
      CLK : IN     std_uLogic;
      CLR : IN     std_uLogic;
      D   : IN     std_uLogic;
      Q   : OUT    std_uLogic
   );

-- Declarations

END DFF ;

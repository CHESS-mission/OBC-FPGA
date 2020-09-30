--------------------------------------------------------------------------------
-- Copyright 2014 HES-SO Valais Wallis (www.hevs.ch)
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation; either version 3 of the License, or
-- (at your option) any later version.
--
-- This program IS distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
-- GNU General Public License for more details.
-- You should have received a copy of the GNU General Public License along with
-- this program. If not, see <http://www.gnu.org/licenses/>
--------------------------------------------------------------------------------
-- EdgeDetector
--   Detect rising and falling edges of a signal.
--
--   Created on 2014-04-02
--
--   Version: 1.0
--   Author: Oliver A. Gubler (oliver.gubler@hevs.ch)
--------------------------------------------------------------------------------
ARCHITECTURE arch OF edgeDetector IS

  SIGNAL in_delayed : std_ulogic;

BEGIN

  -- sync
  reg : PROCESS (reset,clock)
  BEGIN
    IF reset = '1' THEN
      in_delayed <= '0';
    ELSIF rising_edge(clock) THEN
      in_delayed <= in_asynch;
    END IF;
  END PROCESS reg ;

  -- edge detection
  edge_pulse <= '1' when in_asynch /= in_delayed
    else '0';

END ARCHITECTURE arch;

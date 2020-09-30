--
-- VHDL Architecture OBC.gpioPinControl.pinControl
--
-- Created:
--          by - student.UNKNOWN (DESKTOP-3I0F3HP)
--          at - 13:35:18 28.07.2020
--
-- using Mentor Graphics HDL Designer(TM) 2019.2 (Build 5)
--
ARCHITECTURE pinControl OF gpioPinControl IS

BEGIN

    PROCESS (writeEn, pin, write)
    BEGIN
        
        if writeEN = '1' then
            pin <= write;
            read <= write;
        else
            read <= pin;
        end if;
    END PROCESS;

END ARCHITECTURE pinControl;


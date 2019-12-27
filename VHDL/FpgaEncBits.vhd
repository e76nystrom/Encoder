library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package FpgaEncBits is

-- run control register

 constant rCtlSize : integer := 3;
 signal rCtlReg : unsigned(rCtlSize-1 downto 0);
 alias ctlReset   : std_logic is rCtlreg(0); -- x01 reset
 alias ctlTestClock : std_logic is rCtlreg(1); -- x02 testclock
 alias ctlSpare   : std_logic is rCtlreg(2); -- x04 spare

-- debug control register

 constant dCtlSize : integer := 4;
 signal dCtlReg : unsigned(dCtlSize-1 downto 0);
 alias DbgEna     : std_logic is dCtlreg(0); -- x01 enable debugging
 alias DbgSel     : std_logic is dCtlreg(1); -- x02 select dbg encoder
 alias DbgDir     : std_logic is dCtlreg(2); -- x04 debug direction
 alias DbgCount   : std_logic is dCtlreg(3); -- x08 gen count num dbg clks

end FpgaEncBits;

package body FpgaEncBits is

end FpgaEncBits;

-- xFile

library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package FpgaEncBits is

-- run control register

 constant rCtlSize : integer := 3;
 signal rCtlReg : unsigned(rCtlSize-1 downto 0);
 --variable rCtlReg : unsigned(rCtlSize-1 downto 0);

 alias    ctlReset           : std_logic is rCtlReg( 0); -- x0001 reset
 alias    ctlTestClock       : std_logic is rCtlReg( 1); -- x0002 testclock
 alias    ctlSpare           : std_logic is rCtlReg( 2); -- x0004 spare

 constant c_ctlReset         : integer :=  0; -- x0001 reset
 constant c_ctlTestClock     : integer :=  1; -- x0002 testclock
 constant c_ctlSpare         : integer :=  2; -- x0004 spare

-- debug control register

 constant dCtlSize : integer := 4;
 signal dCtlReg : unsigned(dCtlSize-1 downto 0);
 --variable dCtlReg : unsigned(dCtlSize-1 downto 0);

 alias    DbgEna             : std_logic is dCtlReg( 0); -- x0001 enable debugging
 alias    DbgSel             : std_logic is dCtlReg( 1); -- x0002 select dbg encoder
 alias    DbgDir             : std_logic is dCtlReg( 2); -- x0004 debug direction
 alias    DbgCount           : std_logic is dCtlReg( 3); -- x0008 gen count num dbg clks

 constant c_DbgEna           : integer :=  0; -- x0001 enable debugging
 constant c_DbgSel           : integer :=  1; -- x0002 select dbg encoder
 constant c_DbgDir           : integer :=  2; -- x0004 debug direction
 constant c_DbgCount         : integer :=  3; -- x0008 gen count num dbg clks

end FpgaEncBits;

package body FpgaEncBits is

end FpgaEncBits;

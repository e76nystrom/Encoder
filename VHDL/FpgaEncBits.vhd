library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.ALL;

package FpgaEncBits is

-- status register

 constant stat_size : integer := 1;
 signal statReg : unsigned(stat_size-1 downto 0);
 alias doneInt    : std_logic is statreg(0); -- x01 z done interrrupt
 constant c_doneInt    : integer :=  0; -- x01 z done interrrupt

-- debug control register

 constant dCtl_size : integer := 4;
 signal dCtlReg : unsigned(dCtl_size-1 downto 0);
 alias DbgEna     : std_logic is dCtlreg(0); -- x01 enable debugging
 constant c_DbgEna     : integer :=  0; -- x01 enable debugging
 alias DbgSel     : std_logic is dCtlreg(1); -- x02 select dbg encoder
 constant c_DbgSel     : integer :=  1; -- x02 select dbg encoder
 alias DbgDir     : std_logic is dCtlreg(2); -- x04 debug direction
 constant c_DbgDir     : integer :=  2; -- x04 debug direction
 alias DbgCount   : std_logic is dCtlreg(3); -- x08 gen count num dbg clks
 constant c_DbgCount   : integer :=  3; -- x08 gen count num dbg clks

end FpgaEncBits;

package body FpgaEncBits is

end FpgaEncBits;

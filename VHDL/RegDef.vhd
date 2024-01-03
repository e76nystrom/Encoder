library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package RegDef is

constant opb : positive := 8;

constant F_Noop             : unsigned(opb-1 downto 0) := x"00"; -- register 0
constant F_Ld_Run_Ctl       : unsigned(opb-1 downto 0) := x"01"; -- load run control register
constant F_Ld_Dbg_Ctl       : unsigned(opb-1 downto 0) := x"02"; -- load debug control register
constant F_Ld_Enc_Cycle     : unsigned(opb-1 downto 0) := x"03"; -- load encoder cycle
constant F_Ld_Int_Cycle     : unsigned(opb-1 downto 0) := x"04"; -- load internal cycle
constant F_Rd_Cmp_Cyc_C     : unsigned(opb-1 downto 0) := x"05"; -- read cmp cycle clocks
constant F_Ld_Dbg_Freq      : unsigned(opb-1 downto 0) := x"06"; -- load debug frequency
constant F_Ld_Dbg_Count     : unsigned(opb-1 downto 0) := x"07"; -- load debug clocks

end RegDef;

package body RegDef is

end RegDef;

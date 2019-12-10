library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.ALL;

package RegDef is

constant opb : positive := 8;

constant F_Noop             : unsigned(opb-1 downto 0) := x"00"; -- register 0
constant F_Ld_Enc_Cycle     : unsigned(opb-1 downto 0) := x"01"; -- 
constant F_Ld_Int_Cycle     : unsigned(opb-1 downto 0) := x"02"; -- 
constant F_Ld_Dbg_Freq      : unsigned(opb-1 downto 0) := x"03"; -- 
constant F_Ld_Dbg_Count     : unsigned(opb-1 downto 0) := x"04"; -- 
constant F_Ld_Dbg_Ctl       : unsigned(opb-1 downto 0) := x"05"; -- 
constant F_Ld_Ctl           : unsigned(opb-1 downto 0) := x"06"; -- 
constant F_Rd_Cmp_Cyc_Clks  : unsigned(opb-1 downto 0) := x"07"; -- 

end RegDef;

package body RegDef is

end RegDef;

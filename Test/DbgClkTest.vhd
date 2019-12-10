------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   14:15:29 04/05/2015
-- Design Name:   
-- Module Name:   C:/Development/Xilinx/Spartan6/DbgClkTest.vhd
-- Project Name:  Spartan6
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: DbgClk
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE ieee.numeric_std.ALL;

use work.RegDef.all;
use work.FpgaEncBits.all;
use work.SimProc.all;

entity DbgClkTest IS
end DbgClkTest;

architecture behavior of DbgClkTest is
 
 -- Component Declaration for the Unit Under Test (UUT)
 
 component DbgClk
  generic(opBits : positive;
          freq_bits : positive;
          count_bits : positive);
  port(
   clk : in std_logic;
   a : in std_logic;
   b : in std_logic;
   din : in std_logic;
   dshift : in std_logic;
   op: in unsigned (opBits-1 downto 0);
   load : in std_logic;
   a_out : out std_logic;
   b_out : out std_logic;
   dbgPulse : out std_logic;
   dbgDone: out std_logic
   );
 end component;

 constant opBits : positive := 8;
 constant freq_bits : integer := 4;
 constant count_bits : integer := 5;

 --Inputs
 signal clk : std_logic := '0';
 signal a : std_logic := '0';
 signal b : std_logic := '0';
 signal din : std_logic := '0';
 signal load : std_logic := '0';
 signal dshift : std_logic := '0';
 signal op : unsigned (opBits-1 downto 0) := (opBits-1 downto 0 => '0');
 
 --Outputs
 signal a_out : std_logic;
 signal b_out : std_logic;
 signal dbgPulse : std_logic;
 signal dbgDone : std_logic;

 constant dbgCtlBits : natural := 8;

 -- signal tmp1 : signed(count_bits-1 downto 0) := (count_bits-1 downto 0 => '0');
 
BEGIN
 
 -- Instantiate the Unit Under Test (UUT)
 uut: DbgClk
  generic map (opBits => opBits,
               freq_Bits => freq_bits,
               count_bits => count_bits)
  port map (
  clk => sysClk,
  a => a,
  b => b,
  din => din,
  dshift => dshift,
  load => load,
  op => op,
  a_out => a_out,
  b_out => b_out,
  dbgPulse => dbgPulse,
  dbgDone => dbgDone
  );

 -- Clock process definitions

 clk_process : process
 begin
  sysClk <= '0';
  wait for sysClk_period/2;
  sysClk <= '1';
  wait for sysClk_period/2;
 end process;

 -- Stimulus process
 stim_proc: process

 variable freq_val : natural;
 variable count_val : natural;
 variable count : integer;
 variable dbgCtl : unsigned(dctl_size-1 downto 0) :=
  (dctl_size-1 downto 0 => '0');
 variable ctl : integer;
 variable tmp : unsigned(32-1 downto 0) := (32-1 downto 0 => '0');
 
 begin		
  -- hold reset state for 100 ns.
  wait for 100 ns;	

  wait for sysClk_period*10;

  -- insert stimulus here 

  op <= F_Ld_Dbg_Ctl;
  dbgCtl := (dctl_size-1 downto 0 => '0');
  loadCtl(to_integer(dbgCtl), dctl_size, dshift, din, load);

  op <= F_Noop;

  b <= '0';
  a <= '0';

  delay(3);
  
  b <= '0';
  a <= '1';

  delay(3);
  
  b <= '1';
  a <= '1';

  delay(3);
  
  b <= '1';
  a <= '0';

  delay(3);

  b <= '0';
  a <= '0';

  delay(3);

  op <= F_Ld_Dbg_Freq;
  freq_val := 3;
  loadShift(freq_val, freq_bits, dshift, din);

  delay(3);

  op <= F_Ld_Dbg_Count;
  count_val := 5 - 1;
  loadShift(count_val, count_bits, dshift, din);

  op <= F_Ld_Dbg_Ctl;
  dbgCtl(c_DbgEna) := '1';
  dbgCtl(c_DbgSel) := '1';
  loadCtl(to_integer(dbgCtl), dctl_size, dshift, din, load);

  delay(100);                           --enable and selected

  op <= F_Ld_Dbg_Ctl;
  dbgCtl(c_DbgEna) := '1';
  dbgCtl(c_DbgSel) := '1';
  dbgCtl(c_DbgCount) := '1';
  loadCtl(to_integer(dbgCtl), dctl_size, dshift, din, load);

  delay(100);                           --disabled selected

  op <= F_Ld_Dbg_Ctl;
  dbgCtl(c_DbgEna) := '1';
  dbgCtl(c_DbgDir) := '1';
  dbgCtl(c_DbgCount) := '0';
  loadCtl(to_integer(dbgCtl), dctl_size, dshift, din, load);

  delay(50);                            --enabled reverse

  op <= F_Ld_Dbg_Ctl;

  loadCtl(to_integer(dbgCtl), dctl_size, dshift, din, load);

  delay(50);                            --enabled forward

  op <= F_Ld_Dbg_Count;
  count_val := 5 - 1;
  loadShift(count_val, count_bits, dshift, din);

  op <= F_Ld_Dbg_Ctl;
  dbgCtl(c_DbgCount) := '1';
  loadCtl(to_integer(dbgCtl), dctl_size, dshift, din, load);

  delay(150);                           --enabled forward and counting

  op <= F_Ld_Dbg_Ctl;
  dbgCtl := (dctl_size-1 downto 0 => '0');
  loadCtl(to_integer(dbgCtl), dctl_size, dshift, din, load);
  
  wait;
 end process;

end;

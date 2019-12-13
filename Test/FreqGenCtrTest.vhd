--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:39:32 12/12/2019
-- Design Name:   
-- Module Name:   C:/Development/Xilinx/Spartan6Encoder/FreqGenCtrTest.vhd
-- Project Name:  Spartan6Encoder
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: FreqGenCtr
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
use work.SimProc.all;
 
entity FreqGenCtrTest IS
END FreqGenCtrTest;
 
ARCHITECTURE behavior OF FreqGenCtrTest IS 
 
 -- Component Declaration for the Unit Under Test (UUT)
 
 component FreqGenCtr
  generic(opBits : positive := 8;
          freqOp : unsigned;
          countOp : unsigned;
          freqBits : positive;
          countBits: positive);
  port(
   clk : in std_logic;
   din : in std_logic;
   dshift : in std_logic;
   load : in std_logic;
   op : in unsigned(opBits-1 downto 0);
   pulseOut : out std_logic
   );
 end component;

 constant opBits : positive := 8;
 constant freqBits : integer := 4;
 constant countBits : integer := 5;

 --Inputs
 signal clk : std_logic := '0';
 signal din : std_logic := '0';
 signal dshift : std_logic := '0';
 signal load : std_logic := '0';
 signal op : unsigned(opBits-1 downto 0) := (others => '0');

 --Outputs
 signal pulseOut : std_logic;

begin
 
 -- Instantiate the Unit Under Test (UUT)
 uut: FreqGenCtr
  generic map(opBits => opb,
          freqOp => F_Ld_Dbg_Freq,
          countOp => F_Ld_Dbg_Count,
          freqBits => freqBits,
          countBits => countBits)
  port map (
  clk => sysClk,
  din => din,
  dshift => dshift,
  load => load,
  op => op,
  pulseOut => pulseOut
  );

 -- Clock process definitions
 clk_process :process
 begin
  sysClk <= '0';
  wait for sysClk_period/2;
  sysClk <= '1';
  wait for sysClk_period/2;
 end process;
 

 -- Stimulus process
 stim_proc: process

 variable freqVal : natural;
 variable countVal : natural;

 begin		
  -- hold reset state for 100 ns.
  wait for 100 ns;	

  wait for sysClk_period*10;

  -- insert stimulus here

  op <= F_Ld_Dbg_Freq;
  freqVal := 3;
  loadShift(freqVal, freqBits, dshift, din);
  
  op <= F_Ld_Dbg_Count;
  countVal := 4;
  loadShift(countVal, countBits, dshift, din);
  
  delay(1);
  load <= '1';
  delay(1);
  load <= '0';
  delay(1);

  op <= F_Noop;

  delay(50);

  op <= F_Ld_Dbg_Count;
  countVal := 0;
  loadShift(countVal, countBits, dshift, din);
  
  delay(1);
  load <= '1';
  delay(1);
  load <= '0';
  delay(1);

  op <= F_Noop;

  delay(50);

  wait;
 end process;

END;

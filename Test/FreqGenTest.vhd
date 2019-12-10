--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:24:10 04/04/2015
-- Design Name:   
-- Module Name:   C:/Development/Xilinx/Spartan6/FreqGenTest.vhd
-- Project Name:  Spartan6
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: FreqGen
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

ENTITY FreqGenTest IS
END FreqGenTest;

ARCHITECTURE behavior OF FreqGenTest IS 
 
 -- Component Declaration for the Unit Under Test (UUT)
 
 component FreqGen
  generic(freq_bits : positive);
  PORT(
   clk : in std_logic;
   ena : in std_logic;
   din : in std_logic;
   dshift : in std_logic;
   freq_sel : in std_logic;
   pulse_out : out std_logic
   );
 end component;

 --Inputs
 signal clk : std_logic := '0';
 signal ena : std_logic := '0';
 signal dshift : std_logic := '0';
 signal freq_sel : std_logic := '0';
 signal din : std_logic := '0';

 --Outputs
 signal pulse_out : std_logic;

 -- Clock period definitions
 constant clk_period : time := 10 ns;

 constant freq_bits : positive := 4;
 
BEGIN
 
 -- Instantiate the Unit Under Test (UUT)
 uut: FreqGen
  generic map(freq_bits)
  port MAP (
   clk => clk,
   ena => ena,
   din => din,
   dshift => dshift,
   freq_sel => freq_sel,
   pulse_out => pulse_out
   );

 -- Clock process definitions
 clk_process :process
 begin
  clk <= '0';
  wait for clk_period/2;
  clk <= '1';
  wait for clk_period/2;
 end process;
 

 -- Stimulus process
 stim_proc: process
 begin		
  -- hold reset state for 100 ns.
  wait for 100 ns;	

  wait for clk_period*10;

  -- insert stimulus here 

  wait;
 end process;

END;

--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   05:32:11 05/18/2016
-- Design Name:   
-- Module Name:   C:/Development/Xilinx/LatheCtl/CtlRegTest.vhd
-- Project Name:  LatheCtl
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: CtlReg
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
 
ENTITY CtlRegTest IS
END CtlRegTest;
 
ARCHITECTURE behavior OF CtlRegTest IS 
 
 -- Component Declaration for the Unit Under Test (UUT)
 
 COMPONENT CtlReg
  generic(opVal : unsigned;
          n : positive);
  port(
   clk : IN  std_logic;
   din : IN  std_logic;
   op : IN  std_logic_vector(7 downto 0);
   shift : IN  std_logic;
   load : IN  std_logic;
   data : INOUT  std_logic_vector(8-1 downto 0)
   );
 END COMPONENT;

 --Inputs
 signal clk : std_logic := '0';
 signal din : std_logic := '0';
 signal op : std_logic_vector(7 downto 0) := (others => '0');
 signal shift : std_logic := '0';
 signal load : std_logic := '0';

 --BiDirs
 signal data : std_logic_vector(8-1 downto 0);

 -- Clock period definitions
 constant clk_period : time := 10 ns;
 
BEGIN
 
 -- Instantiate the Unit Under Test (UUT)
 uut: CtlReg
  generic map (opval => x"01",
               n => 8)
  PORT MAP (
  clk => clk,
  din => din,
  op => op,
  shift => shift,
  load => load,
  data => data
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

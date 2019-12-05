--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   05:56:52 04/05/2015
-- Design Name:   
-- Module Name:   C:/Development/Xilinx/Spartan6/SPITest.vhd
-- Project Name:  Spartan6
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: SPI
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

ENTITY SPITest IS
END SPITest;

ARCHITECTURE behavior OF SPITest IS 
 
 -- Component Declaration for the Unit Under Test (UUT)
 
 component SPI
 generic (op_bits : positive := 8);
  port(
   clk : in std_logic;
   dclk : in std_logic;
   dsel : in std_logic;
   din : in std_logic;
   op : out unsigned(op_bits-1 downto 0);
   copy : out std_logic;
   shift : out std_logic;
   load : out std_logic;
   header : inout std_logic
   --info : out std_logic_vector(2 downto 0) --state info
   );
 end component;

 component ClockEnable1 is
 generic (n : positive);
  Port (
   clk : in  std_logic;
   ena : in  std_logic;
   clkena : out std_logic);
 end component;

 constant op_bits : integer := 8;
 
 --Inputs
 signal clk : std_logic := '0';
 signal dclk : std_logic := '0';
 signal dsel : std_logic := '1';
 signal din : std_logic := '0';

 --BiDirs
 signal op : unsigned(7 downto 0);

 --Outputs
 signal copy : std_logic;
 signal shift : std_logic;
 signal load : std_logic;
 signal header : std_logic;
 --signal info : std_logic_vector(2 downto 0);
 signal clkena1 : std_logic;

 -- Clock period definitions
 constant clk_period : time := 10 ns;
 
 procedure delay(constant n : in integer) is
 begin
  for i in 0 to n loop
   wait until clk = '1';
   wait until clk = '0';
  end loop;
 end procedure delay;

 --procedure send(signal val : in unsigned(7 downto 0)) is
 -- variable tmp : unsigned(7 downto 0);
 --begin
 -- tmp <= val;
 -- dsel <= '0';
 -- delay(5);
 -- for i in 0 to 7 loop
 --  dclk <= '0';
 --  din <= tmp(7);
 --  tmp <= shift_left(tmp,1);
 --  delay(3);
 --  dclk <= '1';
 --  delay(3);
 -- end loop;
 --end procedure send;

 signal tmp : unsigned(op_bits-1 downto 0) :=  (op_bits-1 downto 0 => '0');
 signal tmp1 : unsigned(31 downto 0) :=  (31 downto 0 => '0');

 constant test_bits : integer := 32;
 --signal test_reg : unsigned(test_bits-1 downto 0);
 signal test1_reg : unsigned(test_bits-1 downto 0);

BEGIN
 
 -- Instantiate the Unit Under Test (UUT)
 uut: SPI port MAP (
  clk => clk,
  dclk => dclk,
  dsel => dsel,
  din => din,
  op => op,
  copy => copy,
  shift => shift,
  load => load,
  header => header
  --info => info
  );

 clk_ena: ClockEnable1
  generic map(n => 3)
  port map (
   clk => clk,
   ena => dclk,
   clkena =>clkena1);
 
 --testreg: Shift
 -- generic map(test_bits)
 -- port map (
 --  clk => clk,
 --  shift => dshift,
 --  din => din,
 --  data => test_reg);

 --test1reg: CtlReg
 -- generic map(test_bits)
 -- port map (
 --  clk => clk,
 --  din => din,
 --  shift => shift,
 --  load => load,
 --  data => test1_reg);

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

  tmp <= to_unsigned(16#a5#,8);
  tmp1 <= to_unsigned(16#12345678#,32);

  --send(tmp);
  
  wait for clk_period*2;
  
  dsel <= '0';
  delay(10);
  for i in 0 to 7 loop
   dclk <= '0';
   din <= tmp(7);
   tmp <= shift_left(tmp,1);
   delay(6);
   dclk <= '1';
   delay(6);
  end loop;
  dclk <= '0';

  delay(10);

  for i in 0 to 31 loop
   dclk <= '0';
   din <= tmp1(31);
   tmp1 <= shift_left(tmp1,1);
   delay(6);
   dclk <= '1';
   delay(6);
  end loop;
  dclk <= '0';
  dsel <= '1';

  delay(20);
  
  wait;
 end process;

END;

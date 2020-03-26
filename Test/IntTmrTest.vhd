--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   07:53:15 04/19/2018
-- Design Name:   
-- Module Name:   C:/Development/Xilinx/Spartan6Encoder/IntTmrTest.vhd
-- Project Name:  Spartan6Encoder
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: IntTmr
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
use ieee.std_logic_arith.conv_std_logic_vector;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE ieee.numeric_std.ALL;
 
use work.RegDef.all;
use work.SimProc.all;

ENTITY IntTmrTest IS
END IntTmrTest;

ARCHITECTURE behavior OF IntTmrTest IS 
 
 -- Component Declaration for the Unit Under Test (UUT)
 
 component IntTmr
  generic (opBits : positive;
           cycleLenBits : positive;
           encClkBits : positive;
           cycleClkbits : positive);
  port(
   clk : in std_logic;
   din : in std_logic;
   dshift : in boolean;
   op: inout unsigned (opBits-1 downto 0);
   dout: out std_logic;
   init : in std_logic;
   intClk : out std_logic;
   encCycleDone : in std_logic;
   cycleClocks : in unsigned(cycleClkBits-1 downto 0)
   );
 end component;
 
 constant opBits : positive := 8;
 constant cycleLenBits : positive := 16;
 constant encClkBits : positive := 24;
 constant cycleClkbits : positive := 32;

 constant cycleCount : positive := 10;  --number of cycles
 constant cycleLen : positive := 100;

 constant counterBits : positive := 8;

 --Inputs
 -- signal clk : std_logic := '0';
 signal din : std_logic := '0';
 signal dshift : boolean := false;
 signal load : boolean := false;
 signal dclk : std_logic := '0';
 signal dsel : std_logic := '0';
 signal init : std_logic := '0';
 signal op : unsigned (opBits-1 downto 0) := (opBits-1 downto 0 => '0');
 signal encCycleDone : std_logic := '0';
 signal cycleClocks : unsigned(cycleClkBits-1 downto 0) := (others => '0');

 --Outputs
 signal intClk : std_logic;
 signal dout : std_logic;
 
 signal tmp : signed(cycleLenBits-1 downto 0);

begin
 
 -- Instantiate the Unit Under Test (UUT)
 uut: IntTmr
  generic map(opbits => opBits,
              cycleLenBits => cycleLenBits,
              encClkBits => encClkBits,
              cycleClkbits => cycleClkBits)
  port map (
   clk => clk,
   din => din,
   dshift => dshift,
   op => op,
   dout => dout,
   init => init,
   intClk => intClk,
   encCycleDone => encCycleDone,
   cycleClocks => cycleClocks
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

  procedure delay(constant n : in integer) is
  begin
   for i in 0 to n-1 loop
    wait until (clk = '1');
    wait until (clk = '0');
   end loop;
  end procedure delay;

  procedure loadShift(variable value : in integer;
                      constant bits : in natural) is
   variable tmp: std_logic_vector(32-1 downto 0);
  begin
   tmp := conv_std_logic_vector(value, 32);
   dshift <= true;
   for i in 0 to bits-1 loop
    din <= tmp(bits - 1);
    wait until clk = '1';
    tmp := tmp(31-1 downto 0) & tmp(31);
    wait until clk = '0';
   end loop;
   dshift <= false;
   load <= true;
   delay(1);
   load <= false;
  end procedure loadShift;

 variable intCycle : integer := 10;

 variable clks : integer;
 variable cycles : integer;

 begin		
  -- hold reset state for 10 ns.
  init <= '1';
  wait for 20 ns;	

  wait for clk_period*10;
  
  -- insert stimulus here 

  delay(5);

  init <= '0';

  op <= F_Ld_Int_Cycle;
  loadShift(intCycle, cycleLenBits);

  delay(5);

  init <= '1';

  delay(5);

  init <= '0';  

  delay(5);

  cycleClocks <= to_unsigned(cycleLen-1, cycleClkBits);
  cycles := 0;
  for i in 0 to cycleCount-1 loop
   clks := 0;
   encCycleDone <= '1';
   for j in 0 to cycleLen-1 loop
    delay(1);
    clks := clks + 1;
    encCycleDone <= '0';
   end loop;
   cycles := cycles + 1;
  end loop;

  wait;
 end process;

END;

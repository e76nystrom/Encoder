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
   initialReset : in std_logic;
   din : in std_logic;
   dshift : in std_logic;
   op: inout unsigned (opBits-1 downto 0);
   copy: in std_logic;
   dout: out std_logic;
   init : in std_logic;
   intClk : out std_logic;
   encCycleDone : in std_logic;
   cycleClocks : in unsigned(cycleClkBits-1 downto 0)
   );
 end component;
 
 constant opBits : positive := 8;
 constant cycleLenBits : natural := 16;
 constant encClkBits : positive := 24;
 constant cycleClkbits : positive := 32;

 constant cycleCount : positive := 10;
 constant cycleLen : natural := 105;
 signal intCycle : natural := 10;

 constant counterBits : positive := 8;

 --Inputs
 -- signal sysClk : std_logic := '0';
 signal din : std_logic := '0';
 signal dshift : std_logic := '0';
 signal dclk : std_logic := '0';
 signal dsel : std_logic := '0';
 signal init : std_logic := '0';
 signal initialReset : std_logic := '1';
 signal op : unsigned (opBits-1 downto 0) := (opBits-1 downto 0 => '0');
 signal copy : std_logic := '0';
 signal encCycleDone : std_logic := '0';
 signal cycleClocks : unsigned(cycleClkBits-1 downto 0) := (others => '0');

 --Outputs
 signal intClk : std_logic;
 signal dout : std_logic;
 
 signal tmp : signed(cycleLenBits-1 downto 0);

 signal clks : unsigned(counterBits-1 downto 0);
 signal cycles : unsigned(counterBits-1 downto 0);

begin
 
 -- Instantiate the Unit Under Test (UUT)
 uut: IntTmr
  generic map(opbits => opBits,
              cycleLenBits => cycleLenBits,
              encClkBits => encClkBits,
              cycleClkbits => cycleClkBits)
  port map (
   clk => sysClk,
   initialReset => initialReset,
   din => din,
   dshift => dshift,
   op => op,
   copy => copy,
   dout => dout,
   init => init,
   intClk => intClk,
   encCycleDone => encCycleDone,
   cycleClocks => cycleClocks
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
 procedure loadValue(signal value : in natural;
                     constant bits : in natural) is
 begin
  loadValue(value, bits, dsel, din, dclk);
 end loadValue;

 begin		
  -- hold reset state for 10 ns.
  init <= '1';
  wait for 20 ns;	

  wait for sysClk_period*10;
  
  -- insert stimulus here 

  delay(5);

  init <= '0';
  initialReset <= '0';

  op <= XLDINTCYCLE;
  loadShift(intCycle, cycleLenBits, dshift, din);

  delay(5);

  init <= '1';

  delay(5);

  init <= '0';  

  delay(5);

  cycleClocks <= to_unsigned(cycleLen-1, cycleClkBits);
  cycles <= to_unsigned(0, counterBits);
  for i in 0 to cycleCount-1 loop
   clks <= to_unsigned(0, counterBits);
   encCycleDone <= '0';
   for j in 0 to cycleLen-1 loop
    delay(1);
    clks <= clks + to_unsigned(1, counterBits);
   end loop;
   encCycleDone <= '1';
   cycles <= cycles + to_unsigned(1, counterBits);
  end loop;

  wait;
 end process;

END;

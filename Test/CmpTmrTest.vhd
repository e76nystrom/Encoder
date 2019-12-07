--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   19:59:12 04/09/2018
-- Design Name:   
-- Module Name:   C:/Development/Xilinx/Spartan6Encoder/CmpTmrTest.vhd
-- Project Name:  Spartan6Encoder
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: CmpTmr
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

ENTITY CmpTmrTest IS
END CmpTmrTest;

ARCHITECTURE behavior OF CmpTmrTest IS 
 
 -- Component Declaration for the Unit Under Test (UUT)
 
 component CmpTmr
  generic (opBits : positive;
           cycleLenBits : positive;
           encClkBits : positive;
           cycleClkbits : positive);
  port(
   clk : in  std_logic;
   initialReset : in std_logic;
   din : in  std_logic;
   dshift : in  std_logic;
   op: inout unsigned (opBits-1 downto 0);
   copy: in std_logic;
   dout: out std_logic;
   init : in  std_logic;
   ena : in  std_logic;
   encClk : in  std_logic;
   encCycleDone: out std_logic;
   cycleClocks : inout unsigned (cycleClkBits-1 downto 0)
   );
 end component;

 constant opBits : positive := 8;
 constant cycleLenBits : positive := 16;
 constant encClkBits : positive := 24;
 constant cycleClkbits : positive := 32;

 --Inputs
 -- signal clk : std_logic := '0';
 signal din : std_logic := '0';
 signal dshift : std_logic := '0';
 signal initialReset : std_logic := '1';
 signal init : std_logic := '0';
 signal ena : std_logic := '0';
 signal encClk : std_logic := '0';
 signal op : unsigned (opBits-1 downto 0) := (opBits-1 downto 0 => '0');
 signal copy : std_logic := '0';

 --BiDirs
 signal cycleClocks : unsigned (cycleClkBits-1 downto 0);

 --Outputs
 signal dout: std_logic;
 signal encCycleDone : std_logic;

 -- Clock period definitions
 -- constant clk_period : time := 10 ns;
 
 signal tmp : signed(cycleLenBits-1 downto 0);

 -- procedure delay(constant n : in integer) is
 -- begin
 --  for i in 0 to n-1 loop
 --   wait until clk = '1';
 --   wait until clk = '0';
 --  end loop;
 -- end procedure delay;

 signal encCycle : natural := 5;

 signal k : unsigned (7 downto 0);

begin
 
 -- Instantiate the Unit Under Test (UUT)
 uut: CmpTmr
  generic map(opBits => opBits,
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
   ena => ena,
   encClk => encClk,
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
 begin		
  -- hold reset state for 100 ns.

  init <= '1';
  ena <= '0';

  wait for 100 ns;	

  wait for sysClk_period*10;

  -- insert stimulus here

  delay(5);

  initialReset <= '0';
  init <= '0';

  op <= XLDENCCYCLE;
  loadShift(encCycle, cycleLenBits, dshift, din);

  delay(5);

  ena <= '1';
  -- k <= x"00";
  for j in 0 to 40-1 loop
   -- if (k = 2) then
   --  delay(10);
   -- else
     delay(9);
   -- end if;

   encClk <= '1'; 
   wait until sysClk = '1';                --10
   encClk <= '0';
   wait until sysClk = '0';
   -- if (k = 5) then
   --  k <= x"00";
   -- else
   --  k <= k + 1;
   -- end if;
  end loop;

  wait;
 end process;

END;

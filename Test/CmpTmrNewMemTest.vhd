--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   19:59:12 04/09/2018
-- Design Name:   
-- Module Name:   C:/Development/Xilinx/Spartan6Encoder/CmpTmrNewMemTest.vhd
-- Project Name:  Spartan6Encoder
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: CmpTmrNewMem
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

ENTITY CmpTmrNewMemTest IS
END CmpTmrNewMemTest;

ARCHITECTURE behavior OF CmpTmrNewMemTest IS 
 
 -- Component Declaration for the Unit Under Test (UUT)
 
 component CmpTmrNewMem
  generic (opBits : positive;
           cycleLenBits : positive;
           encClkBits : positive;
           cycleClkbits : positive);
  port(
   clk : in  std_logic;
   din : in  std_logic;
   dshift : in  boolean;
   op: inout unsigned (opBits-1 downto 0);
   dshiftR : in boolean;                 --spi shift signal
   opR: in unsigned (opBits-1 downto 0);  --current operation
   copyR: in boolean;                    --copy for output
   dout: out std_logic;
   init : in  std_logic;
   ena : in  std_logic;
   encClk : in  std_logic;
   encCycleDone: out std_logic;
   cycleClocks : inout unsigned (cycleClkBits-1 downto 0)
   );
 end component;

 constant opBits : positive := 8;
 constant cycleLenBits : positive := 11;
 constant encClkBits : positive := 24;
 constant cycleClkbits : positive := 32;

 --Inputs
 signal din : std_logic := '0';
 signal dshift : boolean := false;
 signal op : unsigned (opBits-1 downto 0) := (opBits-1 downto 0 => '0');
 signal load : boolean := false;
 signal dshiftR : boolean := false;
 signal opR : unsigned (opBits-1 downto 0) := (opBits-1 downto 0 => '0');
 signal copyR : boolean := false;
 signal init : std_logic := '0';
 signal ena : std_logic := '0';
 signal encClk : std_logic := '0';

 --BiDirs
 signal cycleClocks : unsigned (cycleClkBits-1 downto 0);

 --Outputs
 signal dout: std_logic;
 signal encCycleDone : std_logic;

 signal tmp : signed(cycleLenBits-1 downto 0);

 signal k : unsigned (7 downto 0);

begin
 
 -- Instantiate the Unit Under Test (UUT)
 uut: CmpTmrNewMem
  generic map (opBits => opBits,
               cycleLenBits => cycleLenBits,
               encClkBits => encClkBits,
               cycleClkbits => cycleClkBits)
  port map (
   clk => clk,
   din => din,
   dshift => dshift,
   op => op,
   dshiftR => dshiftR,
   opR => opR,
   copyR => copyR,
   init => init,
   ena => ena,
   dout => dout,
   encClk => encClk,
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

 variable encCycle : integer := 5;

 begin		
  -- hold reset state for 100 ns.

  init <= '1';
  ena <= '0';

  wait for 100 ns;	

  wait for clk_period*10;

  -- insert stimulus here

  delay(5);

  init <= '0';

  op <= F_Ld_Enc_Cycle;
  loadShift(encCycle, cycleLenBits);

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
   wait until clk = '1';                --10
   encClk <= '0';
   wait until clk = '0';
   -- if (k = 5) then
   --  k <= x"00";
   -- else
   --  k <= k + 1;
   -- end if;
  end loop;

  wait;
 end process;

END;

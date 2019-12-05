--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   20:20:29 04/19/2018
-- Design Name:   
-- Module Name:   C:/Development/Xilinx/Spartan6Encoder/EncoderTest.vhd
-- Project Name:  Spartan6Encoder
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Encoder
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

ENTITY EncoderTest IS
END EncoderTest;
 
ARCHITECTURE behavior OF EncoderTest IS 
 
 -- Component Declaration for the Unit Under Test (UUT)
 
 component Encoder
  port(
   sysClk : in std_logic;
   
   led : out std_logic_vector(7 downto 0);

   dbg0 : out std_logic;
   dbg1 : out std_logic;
   dbg2 : out std_logic;
   dbg3 : out std_logic;

   dclk : in std_logic;
   dout : out std_logic;
   din  : in std_logic;
   dsel : in std_logic;

   encClk  : in std_logic;
   intClk  : out std_logic;
   start  : in std_logic;
   ready  : out std_logic;
   
   initialReset : in std_logic

   -- sysClk : in  std_logic;
   --  sw1 : in  std_logic;
   --  sw0 : in  std_logic;
   --  sw2 : in  std_logic;
   --  sw3 : in  std_logic;
   --  led : out  std_logic_vector(7 downto 0);

   --  j1_p04 : out  std_logic;
   --  j1_p06 : out  std_logic;
   --  j1_p08 : out  std_logic;
   --  j1_p10 : out  std_logic;

   --  j1_p12 : in  std_logic;
   --  j1_p14 : out  std_logic;
   --  j1_p16 : in  std_logic;
   --  j1_p18 : in  std_logic;

   --  jc1 : out  std_logic;
   --  jc2 : in  std_logic;
   --  jc3 : in  std_logic;
   --  jc4 : in  std_logic;

   --  initialReset : in std_logic
   );
 end component;

 --Inputs

 signal dclk : std_logic := '0';
 signal din : std_logic := '0';
 signal dsel : std_logic := '1';

 signal encClk : std_logic := '0';
 signal start : std_logic := '0';

 -- signal sysClk : std_logic := '0';

 -- signal sw1 : std_logic := '0';
 -- signal sw0 : std_logic := '0';
 -- signal sw2 : std_logic := '0';
 -- signal sw3 : std_logic := '0';

 -- signal j1_p12 : std_logic := '0';
 -- signal j1_p16 : std_logic := '0';
 -- signal j1_p18 : std_logic := '0';

 -- signal jc2 : std_logic := '0';
 -- signal jc3 : std_logic := '0';
 -- signal jc4 : std_logic := '0';

 signal initialReset : std_logic := '1';

 --Outputs

 signal led : std_logic_vector(7 downto 0);

 signal dbg0 : std_logic;
 signal dbg1 : std_logic;
 signal dbg2 : std_logic;
 signal dbg3 : std_logic;

 signal dout : std_logic;

 signal intClk : std_logic;
 signal ready : std_logic;
 
 -- signal j1_p04 : std_logic;
 -- signal j1_p06 : std_logic;
 -- signal j1_p08 : std_logic;

 -- signal j1_p10 : std_logic;

 -- signal j1_p14 : std_logic;

 -- signal jc1 : std_logic;

 -- Clock period definitions
 -- constant sysClk_period : time := 10 ns;
 
 -- alias dclk : std_logic is j1_p12;
 -- alias dout : std_logic is j1_p14;
 -- alias din : std_logic is j1_p16;
 -- alias dsel : std_logic is j1_p18;

 -- alias intClk : std_logic is jc1;       --internal clock
 -- alias encClk : std_logic is jc2;       --encoder clock

 -- alias ctlInit : std_logic is jc3;      --initialize
 -- alias ctlEna : std_logic is jc4;       --enable

 -- dclk <= jb1;
 -- jb2  <= dout;
 -- din  <= jb3;
 -- dsel <= jb4;
 
 -- procedure delay(constant n : in integer) is
 -- begin
 --  for i in 0 to n-1 loop
 --   wait until sysClk = '1';
 --   wait until sysClk = '0';
 --  end loop;
 -- end procedure delay;

 constant cycleLenBits : positive := 16;
 constant encClkBits : positive := 24;
 constant cycleClkBits : positive := 32;

 signal encCycle : natural := 5;
 signal intCycle : natural := 4;

 -- variable op : integer;

 -- constant XLDENCCYCLE : unsigned(opb-1 downto 0) := x"01";
 -- constant XLDINTCYCLE : unsigned(opb-1 downto 0) := x"02";

 signal parmIdx : unsigned(opb-1 downto 0) :=  (opb-1 downto 0 => '0');
 signal parmVal : unsigned(cycleLenBits-1 downto 0) :=
  (cycleLenBits-1 downto 0 => '0');

 signal readCycleClocks : unsigned (cycleClkBits-1 downto 0) :=
  (cycleClkBits-1 downto 0 => '0');

begin
 
 -- Instantiate the Unit Under Test (UUT)

 uut: Encoder
  port map (
   sysClk => sysClk,

   led => led,

   dbg0 => dbg0,
   dbg1 => dbg1,
   dbg2 => dbg2,
   dbg3 => dbg3,

   -- j1_p04 => j1_p04,
   -- j1_p06 => j1_p06,
   -- j1_p08 => j1_p08,
   -- j1_p10 => j1_p10,

   dclk => dclk,
   dout => dout,
   din => din,
   dsel => dsel,

   encClk => encClk,
   intClk => intClk,
   start => start,
   ready => ready,
   
   -- jc1 => jc1,
   -- jc2 => jc2,
   -- jc3 => jc3,
   -- jc4 => jc4,

   initialReset => initialReset
   );

 -- Clock process definitions

 sysClk_process : process
 begin
  sysClk <= '0';
  wait for sysClk_period/2;
  sysClk <= '1';
  wait for sysClk_period/2;
 end process;
 
 -- Stimulus process

 stim_proc : process

 procedure loadParm(constant parmIdx : in unsigned (opb-1 downto 0)) is
 begin
  loadParm(parmIdx, dsel, din, dclk);
 end loadParm;
 
 procedure loadValue(signal value : in natural;
                     constant bits : in natural) is
 begin
  loadValue(value, bits, dsel, din, dclk);
 end loadValue;

 begin		
  dsel <= '1';
  -- hold reset state for 100 ns.

  wait for 100 ns;	

  delay(8);
  -- ctlInit <= '0';
  initialReset <= '0';

  wait for sysClk_period*5;

  -- insert stimulus here

  loadParm(XLDENCCYCLE);
  loadValue(encCycle, cycleLenBits);

  loadParm(XLDINTCYCLE);
  loadValue(intCycle, cycleLenBits);

  start <= '1';
  while (ready = '0') loop
   delay(1);
  end loop;
  start <= '0';

  for j in 0 to 160-1 loop               --number of encoder pulses
   delay(18);                     	--18+2 clocks between encoder pulses
   encClk <= '1';                       --generate encoder pulse
   delay(2);
   encClk <= '0';                       --end encoder pulse
  end loop;
  
  loadParm(XRDCmpCycClks);

  for i in 0 to cycleClkBits-1 loop     --load value
   dclk <= '0';
   delay(6);
   readCycleClocks <= readCycleClocks(cycleClkBits-2 downto 0) & dout;
   dclk <= '1';
   delay(6);
  end loop;
  din <= '0';
  dclk <= '0';

  wait;
 end process;

end;

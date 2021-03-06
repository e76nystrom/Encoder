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
 
use work.SimProc.all;
use work.RegDef.all;
use work.FpgaEncBits.all;

ENTITY EncoderTest IS
END EncoderTest;
 
ARCHITECTURE behavior OF EncoderTest IS 
 
 -- Component Declaration for the Unit Under Test (UUT)
 
 component Encoder
  port(
   sysClk : in std_logic;
   
   led : out std_logic_vector(7 downto 0);
   dbg : out std_logic_vector(7 downto 0) := (7 downto 0 => '0');
   anode : out std_logic_vector(3 downto 0) := (3 downto 0 => '1');
   seg : out std_logic_vector(6 downto 0) := (6 downto 0 => '1');

   dclk : in std_logic;
   dout : out std_logic;
   din  : in std_logic;
   dsel : in std_logic;

   encClkOut  : out std_logic;
   intClkOut  : out std_logic;
   start  : in std_logic;
   ready  : out std_logic;
   
   a_in : in std_logic;
   b_in : in std_logic
   );
 end component;

 --Inputs

 signal dclk : std_logic := '0';
 signal din : std_logic := '0';
 signal dsel : std_logic := '1';

 signal start : std_logic := '0';

 signal a_in : std_logic := '0';
 signal b_in : std_logic := '0';

 --Outputs

 signal led : std_logic_vector(7 downto 0);
 signal dbg : std_logic_vector(7 downto 0);
 signal anode : std_logic_vector(3 downto 0);
 signal seg : std_logic_vector(6 downto 0);

 signal dout : std_logic;

 signal encClkOut : std_logic;
 signal intClk : std_logic;
 signal ready : std_logic;
 
 constant cycleLenBits : positive := 16;
 constant encClkBits : positive := 24;
 constant cycleClkBits : positive := 32;

 signal encCycle : natural := 5;
 signal intCycle : natural := 4;
 signal ctlVal : natural := 1;

 signal parmIdx : unsigned(opb-1 downto 0) :=  (opb-1 downto 0 => '0');
 signal parmVal : unsigned(cycleLenBits-1 downto 0) :=
  (cycleLenBits-1 downto 0 => '0');

 signal readCycleClocks : unsigned (cycleClkBits-1 downto 0) :=
  (cycleClkBits-1 downto 0 => '0');

begin
 
 -- Instantiate the Unit Under Test (UUT)

 uut: Encoder
  port map (
   sysClk => clk,

   led => led,
   dbg => dbg,
   anode => anode,
   seg => seg,

   dclk => dclk,
   dout => dout,
   din => din,
   dsel => dsel,

   encClkOut => encClkOut,
   intClkOut => intClk,
   start => start,
   ready => ready,

   a_in => a_in,
   b_in => b_in
   );

 -- Clock process definitions

 clk_process : process
 begin
  clk <= '0';
  wait for clk_period/2;
  clk <= '1';
  wait for clk_period/2;
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

 variable count : integer;
 
 begin		
  dsel <= '1';

  -- hold reset state for 100 ns.

  wait for 100 ns;	

  delay(8);

  wait for clk_period*5;

  -- insert stimulus here

  ctlVal <= 1;

  loadParm(F_Ld_Run_Ctl);
  loadValue(ctlVal, rCtlSize);

  ctlVal <= 0;
  
  loadParm(F_Ld_Run_Ctl);
  loadValue(ctlVal, rCtlSize);
  
  loadParm(F_Ld_Enc_Cycle);
  loadValue(encCycle, cycleLenBits);

  loadParm(F_Ld_Int_Cycle);
  loadValue(intCycle, cycleLenBits);

  start <= '1';
  while (ready = '0') loop
   delay(1);
  end loop;
  start <= '0';

  count := 0;
  for j in 0 to 160-1 loop               --number of encoder pulses
   delay(18);                     	--18+2 clocks between encoder pulses
   -- encClk <= '1';                       --generate encoder pulse
   delay(2);
   -- encClk <= '0';                       --end encoder pulse
   count := count + 1;
   if (count > 3) then
    count := 0;
   end if;
   if (count = 0) then
    b_in <= '0';
   elsif (count = 1) then
    a_in <= '1';
   elsif (count = 2) then
    b_in <= '1';
   elsif (count = 3) then
    a_in <= '0';
   end if;
  end loop;
  
  loadParm(F_Rd_Cmp_Cyc_Clks);

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

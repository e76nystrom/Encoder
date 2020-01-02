--------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:59:58 04/13/2018 
-- Design Name: 
-- Module Name:    IntTmr - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

use work.RegDef.all;

entity IntTmr is
 generic(opBase : unsigned := x"00";
         opBits : positive := 8;
         cycleLenBits : positive := 16;
         encClkBits : positive := 24;
         cycleClkbits : positive := 32);
 port(
  clk : in std_logic;                   --system clock
  din : in std_logic;                   --spi data in
  dshift : in std_logic;                --spi shift in
  op: in unsigned (opBits-1 downto 0);  --current operation
  copy: in std_logic;                   --copy for output
  init : in std_logic;                  --init signal
  encCycleDone : in std_logic;          --encoder cycle done
  cycleClocks: in unsigned (cycleClkBits-1 downto 0); --cycle counter
  dout: out std_logic := '0';           --data out
  intClk : out std_logic := '0'         --output clock
  );
end IntTmr;

architecture Behavioral of IntTmr is

 component ShiftOp is
  generic(opVal : unsigned;
          opBits : positive;
          n : positive);
  port(
   clk : in std_logic;
   shift : in std_logic;
   op : unsigned (opBits-1 downto 0);
   din : in std_logic;
   data : inout unsigned (n-1 downto 0));
 end component;

 component DownCounterOne is
  generic(n : positive);
  port(
   clk : in std_logic;
   ena : in std_logic;
   load : in std_logic;
   preset : in unsigned (n-1 downto 0);
   counter : inout  unsigned (n-1 downto 0);
   one : out std_logic);
 end component;

 component UpCounter is
  generic(n : positive);
  port(
   clk : in std_logic;
   clr : in std_logic;
   ena : in std_logic;
   counter : inout  unsigned (n-1 downto 0));
 end component;

 component CompareEq is
  generic(n : positive);
  port(
   a : in unsigned (n-1 downto 0);
   b : in unsigned (n-1 downto 0);
   cmp : out std_logic);
 end component;

 component DataSel2 is
  generic(n : positive);
  port( sel : in std_logic;
         data0 : in unsigned (n-1 downto 0);
         data1 : in unsigned (n-1 downto 0);
         data_out : out unsigned (n-1 downto 0));
 end component;

 component Subtractor is
  generic(n : positive);
  port(
   clk : in std_logic;
   load : in std_logic; 
   ena : in std_logic;
   a : in unsigned (n-1 downto 0);
   b : in unsigned (n-1 downto 0);
   diff : inout unsigned (n-1 downto 0));
 end component;

 component CompareLE is
  generic(n : positive);
  port(
   a : in  unsigned (n-1 downto 0);
   b : in  unsigned (n-1 downto 0);
   ena : in std_logic;
   cmp : out std_logic);
 end component;

 -- internal clock state machine

 type intFSM is (idle, waitIntDone);
 signal intState : intFSM := idle;

 -- variables for internal clock generator

 signal initClear : std_logic := '0'; --internal copy of init used for inital
                                      --clearing of all registers
 signal intRun : std_logic := '0';

 -- cycle length register

 signal intCycle : unsigned (cycleLenBits-1 downto 0) :=
  (cycleLenBits-1 downto 0 => '0'); --cycle length value

 -- cycle length counter

 signal intCount : unsigned (cycleLenBits-1 downto 0); --cycle length counter
 signal intCountExt : unsigned (cycleClkBits-1 downto 0); --cycle length counter
 signal cycleDone : std_logic;

 -- clocks in cycle

 -- signal intClocks : unsigned (encClkBits-1 downto 0);

 -- counter for clocks in cycle

 -- signal intClkCtr : unsigned (encClkBits-1 downto 0);

 -- cycle clock counter

 signal intCtrLoad : std_logic := '0';
 signal cycleClkClr : std_logic := '0';
 signal cycleClkCtr : unsigned (cycleClkBits-1 downto 0);

 -- subtractor

 signal subASel : std_logic;
 signal subBSel : std_logic;
 signal subLoad: std_logic;
 signal subA : unsigned (cycleClkBits-1 downto 0);
 signal subB : unsigned (cycleClkBits-1 downto 0);
 signal cycleClkRem : unsigned (cycleClkBits-1 downto 0);

 -- comparator

 signal intClkUpd : std_logic;

begin

 dout <= '0';
 
 cycleLenReg: ShiftOp                     --register for cycle length
  generic map(opVal => opBase + F_Ld_Int_Cycle,
              opBits => opBits,
              n => cycleLenBits)
  port map(
   clk => clk,
   shift => dshift,
   op => op,
   din => din,
   data => intCycle);
 
 intCtrLoad <= initClear or cycleDone or (not intRun);

 intCounter: DownCounterOne             --counter for cycle length
  generic map(cycleLenBits)
  port map(
   clk => clk,
   ena => intClkUpd,
   load => intCtrLoad,
   preset => intCycle,
   counter => intCount,
   one => cycleDone);

 cycleClkClr <= initClear or cycleDone or (not intRun);

 clkCtr: UpCounter
  generic map(cycleClkBits)
  port map(
   clk => clk,
   clr => cycleClkClr,
   ena => '1',
   counter => cycleClkCtr);

 subASel <= initClear or cycleDone or intClkUpd or (not intRun);

 dataSelA: DataSel2
  generic map(cycleClkBits)
  port map(
   sel => subASel,
   data0 => cycleClkRem,
   data1 => cycleClocks,
   data_out => subA);

 intCountExt <= (cycleClkBits-1 downto cycleLenBits => '0') & intCount;

 subBSel <= initClear or intClkUpd or (not intRun);

 dataSelB: DataSel2
  generic map(cycleClkBits)
  port map(
   sel => subBSel,
   data0 => intCountExt,
   data1 => cycleClkCtr,
   data_out => subB);

 subLoad <= initClear or (not intRun);

 cycRem: Subtractor
  generic map(cycleClkBits)
  port map (
   clk => clk,
   load => subLoad,
   ena => '1',
   a => subA,
   b => subB,
   diff => cycleClkRem);

 cmpLE: CompareLE
  generic map(cycleClkBits)
  port map(
   a => cycleClkRem,
   b => intCountExt,
   ena => intRun,
   cmp => intClkUpd);

 int_FSM_process: process(clk)
 begin
  if (rising_edge(clk)) then
   if (init = '1') then
    initClear <= '1';
    intRun <= '0';
    intClk <= '0';
    intState <= idle;
   else
    initClear <= '0';
    case intState is
     when idle =>
      if (encCycleDone = '1') then
       intRun <= '1';
       intClk <= '1';
       intState <= waitIntDone;
      end if;
      
     when waitIntDone =>
      intClk <= intClkUpd;
      if (cycleDone = '1') then
       intRun <= '0';
       intState <= idle;
      end if;
    end case;      
   end if;
  end if;
 end process;

end Behavioral;


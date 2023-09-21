-- Create Date:    16:59:58 04/13/2018 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.regDef.all;
use work.IORecord.all;

entity IntTmrNew is
 generic(opBase       : unsigned := x"00";
         cycleLenBits : positive := 16;
         encClkBits   : positive := 24;
         cycleClkbits : positive := 32);
 port(
  clk : in std_logic;                   --system clock

  inp : DataInp;
  -- din : in std_logic;                   --spi data in
  -- dshift : in boolean;                  --spi shift in
  -- op: in unsigned (opBits-1 downto 0);  --current operation

  init : in std_logic;                  --init signal
  encCycleDone : in std_logic;          --encoder cycle done
  cycleClocks  : in unsigned (cycleClkBits-1 downto 0); --cycle counter
  dout         : out std_logic := '0';  --data out
  active       : out std_logic := '0';  --active
  intClk       : out std_logic := '0'   --output clock
  );
end IntTmrNew;

architecture Behavioral of IntTmrNew is

 -- internal clock state machine

 type intFSM is (idle, waitIntDone);
 signal intState : intFSM := idle;

 -- variables for internal clock generator

 signal initClear : std_logic := '0'; --internal copy of init used for inital
                                      --clearing of all registers
 signal intRun : std_logic := '0';

 -- cycle length register

 signal intCycle : unsigned (cycleLenBits-1 downto 0); --cycle length value

 -- cycle length counter

 signal intCount : unsigned (cycleLenBits-1 downto 0) := (others => '0');
 signal cycleDone : std_logic := '0';

 -- cycle clock counter

 signal cycleClkCtr : unsigned (cycleClkBits-1 downto 0) := (others => '0');

 -- subtractor

 signal cycleClkRem : unsigned (cycleClkBits-1 downto 0) := (others => '0');

 -- comparator

 -- signal intClkUpd : std_logic := '0';

begin

 dout <= '0';
 
 cycleLenReg : entity work.ShiftOp      --register for cycle length
  generic map(opVal => opBase + F_Ld_Int_Cycle,
              n => cycleLenBits)
  port map(
   clk  => clk,
   inp  => inp,
   -- shift => dshift,
   -- op => op,
   -- din => din,
   data => intCycle);

 int_FSM_process: process(clk)
  variable subASel : boolean;
  variable subA : unsigned(cycleClkBits-1 downto 0);
  variable subB : unsigned(cycleClkBits-1 downto 0);
  variable intCountExt : unsigned (cycleClkBits-1 downto 0);
  variable intClkUpd : std_logic;
 begin
  if (rising_edge(clk)) then

   if (init = '1') then                 --if initializing

    initClear <= '1';
    intRun <= '0';
    intClk <= '0';
    active <= '0';
    intState <= idle;

   else                                 --if not initializing

    initClear <= '0';
    case intState is
     when idle =>
      if (encCycleDone = '1') then
       active <= '1';
       intRun <= '1';
       intClk <= '1';
       intState <= waitIntDone;
      end if;
      
     when waitIntDone =>
      if (cycleDone = '1') then
       intRun <= '0';
       intState <= idle;
      end if;
    end case;
   end if;                              --end initialization
   
   intCountExt := (cycleClkBits-1 downto cycleLenBits => '0') & intCount;

   if ((intRun = '1') and (intCountExt >= cycleClkRem)) then
    intClkUpd := '1';
   else
    intClkUpd := '0';
   end if;

   if (initClear = '1' or cycleDone = '1' or intRun = '0') then

    intCount <= intCycle;
    cycleDone <= '0';
    cycleClkCtr <= to_unsigned(0, cycleClkBits);

   else

    if (intCount = 1) then
     cycleDone <= '1';
    elsif (intClkUpd = '1') then
     intCount <= intCount - 1;
    end if;
    
    cycleClkCtr <= cycleClkCtr + 1;
   end if;

   subASel := (initClear = '1' or  intClkUpd = '1' or intRun = '0');
   if (subASel) then
    subA := cycleClocks;
    subB := cycleClkCtr;
   else
    subA := cycleClkRem;
    subB := intCountExt;
   end if;
   
   if (initClear = '1' or intRun = '0') then
    cycleClkRem <= subA;
   else
    cycleClkRem <= subA - subB;
   end if;

   if (intRUn = '1') then
    intClk <= intClkUpd;
   end if;

  end if;                               --end rising edge
 end process;

end Behavioral;


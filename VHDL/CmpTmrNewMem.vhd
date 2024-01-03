-- Create Date:    05:23:10 04/09/2018

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.regDef.all;
use work.IORecord.all;

entity CmpTmrNewMem is
 generic(opBase       : unsigned := x"00";
         cycleLenBits : positive := 11;
         encClkBits   : positive := 24;
         cycleClkbits : positive := 32;
         outBits      : positive := 32);
 port(
  clk          : in  std_logic;         --system clock
  inp          : in  DataInp;
  oRec         : in  DataOut;
  init         : in  std_logic;        --init signal
  ena          : in  std_logic;        --enable input
  encClk       : in  std_logic;        --encoder clock
  dout         : out std_logic := '0'; --data out
  encCycleDone : out std_logic := '0';  --encoder cycle done
  cycleClocks  : inout unsigned (cycleClkBits-1 downto 0) := (others => '0')
  );
end CmpTmrNewMem;

architecture Behavioral of CmpTmrNewMem is

 type countMem is array (0 to 2048-1) of
  std_logic_vector(encClkBits-1 downto 0);

 signal countHist : countMem := (others => (others => '0'));

 -- enable state machine

 type enaFSM is (waitEna, waitEnc, run);
 signal enaState : enaFSM := waitEna;

 -- control signals from enable state machine

 signal clkCtrEna : std_logic := '0';   --clock counter enable

 -- cmp statue machine

 type fsm is (idle, cycleSub, cycleAdd, cycleUpd);
 signal state : fsm := idle;

 signal done : std_logic := '0';
 signal subtract : std_logic := '0';

 constant delayBits : positive := 2;
 signal delay : unsigned(delayBits-1 downto 0) := (others => '0');

 -- cycle length register

 signal encCycle : unsigned (cycleLenBits-1 downto 0); --cycle length value

 -- cycle length counter

 signal encCount : unsigned (cycleLenBits-1 downto 0) := (others => '1');
 signal encCountSave : unsigned (cycleLenBits-1 downto 0) := (others => '1');

 -- clock up counter

 signal clockCounter :
  unsigned (encClkBits-1 downto 0) := to_unsigned(1, encClkBits); --clock ctr

 -- encoder clocks

 signal encoderClocks :
  unsigned (encClkBits-1 downto 0) := (others => '0'); --encoder clocks reg

 -- counters and register for clock counting

 signal clockTotal  :
  unsigned (cycleClkBits-1 downto 0) := (others => '0');  --clock accumulator

 constant extClocks :
  unsigned (cycleClkBits-1 downto encClkBits) := (others=> '0');

 signal oldClocks   :
  std_logic_vector(encClkBits-1 downto 0) := (others => '0');

 signal wEna: std_logic := '0';

 -- signals for register output

 signal doutCycClks : std_logic;        --output of cycle clocks

begin

 dout <= doutCycClks;

 cycleLenReg: entity work.ShiftOP       --register for cycle length
  generic map(opVal => opBase + F_Ld_Enc_Cycle,
              n     => cycleLenBits)
  port map(
   clk  => clk,
   inp  => inp,
   data => encCycle)
  ;

 -- memory: entity work.CmpTmrMem2
 --  port map (
 --   clock     => clk,
 --   data      => std_logic_vector(encoderClocks),
 --   rdaddress => std_logic_vector(encCountSave),
 --   wraddress => std_logic_vector(encCountSave),
 --   wren      => wEna,
 --   q         => oldClocks
 --   );

 cycleClocksOut: entity work.ShiftOutN
  generic map(opVal   => opBase + F_Rd_Cmp_Cyc_Clks,
              n       => cycleClkBits,
              outBits => outBits)
  port map (
   clk  => clk,
   oRec => oRec,
   data => cycleClocks,
   dout => doutCycClks
   );

 memory: process(clk)
  begin

   if rising_edge(clk) then
    if (wEna = '1') then
     countHist(to_integer(encCountSave)) <= std_logic_vector(encoderClocks);
    end if;
    oldClocks <= std_logic_vector(countHist(to_integer(encCountSave)));
   end if;
  end process memory;

 cmp_process: process(clk)
 begin
  if (rising_edge(clk)) then            --if clock active

   if (init = '1') then                 --initialize variables

    clkCtrEna <= '0';                   --disable clock counter
    enaState <= waitEna;                --wait for enable

   else                                 --if not initializing

    case enaState is                    --select state
     when  waitEna =>                   --wait for enable
      if (ena = '1') then               --if enabled
       enaState <= waitEnc;             --wait for encoder pulse
      end if;

     when  waitEnc =>                   --wait for encoder
      if (encClk = '1') then            --if encoder pulse

       clockCounter <= to_unsigned(1, encClkBits);
       clockTotal <= (others => '0');
       cycleClocks <= (others => '0');
       encoderClocks <= (others => '0');
       encCount <= (others => '0');
       clkCtrEna <= '1';               --enable clock counter
       subtract <= '0';
       done <= '0';
       state <= idle;                   --set to idle
       enaState <= run;                 --run

      end if;

     when  run =>                       --run
      if (ena = '0') then               --if enabled cleared
       clkCtrEna <= '0';                --disable counting
       enaState <= waitEna;             --wait for enable
      end if;

    end case;                           --end state machine

   end if;                              --end init

   if (clkCtrEna = '1') then                  --if clock counter enabled

    if (encClk = '1') then              --encoder event

     if (encCount < encCycle) then --not cycle end
      enccount <= encCount + 1;         --decrement counter
     else                               --if cycle end
      encCount <= (others => '0');      --reload counter
      done <= '1';                      --set cycle end flag
     end if;                            --end cycle len checks

     clockCounter <= to_unsigned(1, encClkBits); --restart clocks counter
     encoderClocks <= clockCounter;     --save before update
     encCountSave <= encCount;          --save before udpate

     if (subtract = '1') then
      delay <= to_unsigned(2, delayBits);
      state <= cycleSub;
     else
      wEna <= '1';
      state <= cycleAdd;                --
     end if;

    else                                --if no encoder event
     clockCounter <= clockCounter + 1;  --update clock
    end if;                             --end encoder checks

    case state is                       --select state
     when idle =>                       --idle
      enccycledone <= '0';              --clear done flag

     when cycleSub =>
      if (delay = to_unsigned(0, delayBits)) then
       clockTotal <= clockTotal - (extCLocks & unsigned(oldClocks));
       wEna <= '1';
       state <= cycleAdd;
      else
       delay <= delay - 1;
      end if;

     when cycleAdd =>                   --
      wEna <= '0';
      clockTotal <= clockTotal + (extClocks & encoderClocks);  --update total
      state <= cycleUpd;

     when cycleUpd =>                   --calc cycle clocks
      if (done = '1') then              --if not done
       done <= '0';                     --clear local flag
       subtract <= '1';                 --start subtracting old data
       encCycleDone <= '1';             --set output flag
       cycleClocks <= clockTotal;
      end if;
      state <= idle;                    --return to idle state

    end case;                           --end state machine

   end if;                              --end clock counter
  end if;                               --end rising_edge
 end process;

end Behavioral;

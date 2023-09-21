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
  clk          : in std_logic;          --system clock

  inp          : in DataInp;
  -- din : in std_logic;                   --spi data in
  -- dshift : in boolean;                  --spi shift signal
  -- op: in unsigned (opBits-1 downto 0);  --current operation

  oRec         : in DataOut;
  -- dshiftR : in boolean;                 --spi shift signal
  -- opR: in unsigned (opBits-1 downto 0);  --current operation
  -- copyR: in boolean;                    --copy for output

  init         : in  std_logic;        --init signal
  ena          : in  std_logic;        --enable input
  encClk       : in  std_logic;        --encoder clock
  dout         : out std_logic := '0'; --data out
  encCycleDone : out std_logic := '0';  --encoder cycle done
  cycleClocks  : inout unsigned (cycleClkBits-1 downto 0) := (others => '0')
  );
end CmpTmrNewMem;

architecture Behavioral of CmpTmrNewMem is

 -- enable state machine

 type enaFSM is (waitEna, waitEnc, run);
 signal enaState : enaFSM := waitEna;

 -- control signals from enable state machine

 signal clkCtrEna : boolean := false;   --clock counter enable

 -- cmp statue machine

 type fsm is (idle, cycleSub, cycleAdd, cycleUpd);
 signal state : fsm := idle;

 signal done : boolean := false;
 signal subtract : boolean := false;

 constant delayBits : positive := 2;
 signal delay : unsigned(delayBits-1 downto 0) := (others => '0');

 -- cycle length register

 signal encCycle : unsigned (cycleLenBits-1 downto 0); --cycle length value

 -- cycle length counter

 signal encCount : unsigned (cycleLenBits-1 downto 0) := (others => '1');
 signal encCountSave : unsigned (cycleLenBits-1 downto 0) := (others => '1');

 -- clock up counter

 signal clockCounter : unsigned (encClkBits-1 downto 0) := to_unsigned(1, encClkBits); --clock counter

 -- encoder clocks

 signal encoderClocks : unsigned (encClkBits-1 downto 0) := (others => '0'); --encoder clocks reg

 -- counters and register for clock counting

 signal clockTotal : unsigned (cycleClkBits-1 downto 0) := (others => '0');  --clock accumulator

 signal oldClocks : std_logic_vector(encClkBits-1 downto 0) := (others => '0');
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
   -- shift => dshift,
   -- op => op,
   -- din => din,

   data => encCycle);

 memory: entity work.CmpTmrMem2
  port map (
   clock     => clk,
   data      => std_logic_vector(encoderClocks),
   rdaddress => std_logic_vector(encCountSave),
   wraddress => std_logic_vector(encCountSave),
   wren      => wEna,
   q         => oldClocks
   );

 cycleClocksOut: entity work.ShiftOutN
  generic map(opVal   => opBase + F_Rd_Cmp_Cyc_Clks,
              n       => cycleClkBits,
              outBits => outBits)
  port map (
   clk  => clk,

   oRec  => oRec,
   -- dshift => dshiftR,
   -- op => opR,
   -- copy => copyR,

   data => cycleClocks,
   dout => doutCycClks
   );

 cmp_process: process(clk)
 begin
  if (rising_edge(clk)) then            --if clock active

   if (init = '1') then                 --initialize variables

    clkCtrEna <= false;                 --disable clock counter
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
       encCount <= encCycle;
       clkCtrEna <= true;               --enable clock counter
       subtract <= false;
       done <= false;
       state <= idle;                   --set to idle
       enaState <= run;                 --run

      end if;

     when  run =>                       --run
      if (ena = '0') then               --if enabled cleared
       clkCtrEna <= false;              --disable counting
       enaState <= waitEna;             --wait for enable
      end if;

    end case;                           --end state machine

   end if;                              --end init

   if (clkCtrEna) then                  --if clock counter enabled

    if (encClk = '1') then              --encoder event

     if (encCount /= to_unsigned(0, cycleLenBits)) then --not cycle end
      enccount <= encCount - 1;         --decrement counter
     else                               --if cycle end
      encCount <= encCycle;             --reload counter
      done <= true;                     --set cycle end flag
     end if;                            --end cycle len checks

     clockCounter <= to_unsigned(1, encClkBits); --restart clocks counter
     encoderClocks <= clockCounter;     --save for multiplier
     encCountSave <= encCount;          --save for multiplier
     if (subtract) then
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
       clockTotal <= (clockTotal -
                      ((cycleClkBits-1 downto encClkBits => '0') &
                       unsigned(oldClocks)));
       wEna <= '1';
       state <= cycleAdd;
      else
       delay <= delay - 1;
      end if;
      
     when cycleAdd =>                   --
      wEna <= '0';
      clockTotal <= (clockTotal + ((cycleClkBits-1 downto encClkBits => '0') &
                                   encoderClocks));  --update total clocks
      state <= cycleUpd;

     when cycleUpd =>                   --calc cycle clocks
      if (done) then                    --if not done
       done <= false;                   --clear local flag
       subtract <= true;                --start subtracting old data
       encCycleDone <= '1';             --set output flag
       cycleClocks <= clockTotal;
      end if;
      state <= idle;                    --return to idle state

    end case;                           --end state machine

   end if;                              --end clock counter
  end if;                               --end rising_edge
 end process;

end Behavioral;

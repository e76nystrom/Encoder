-- Create Date:    05:23:10 04/09/2018 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.regDef.all;
use work.IORecord.all;

entity CmpTmrNew is
 generic(opBase       : unsigned := x"00";
         cycleLenBits : positive := 16;
         encClkBits   : positive := 24;
         cycleClkbits : positive := 32;
         outBits      : positive := 32);
 port(
  clk         : in std_logic;           --system clock

  inp         : in  DataInp;
  -- din : in std_logic;                   --spi data in
  -- dshift : in boolean;                  --spi shift signal
  -- op: in unsigned (opBits-1 downto 0);  --current operation

  oRec        : in  DataOut;
  -- dshiftR : in boolean;                 --spi shift signal
  -- opR: in unsigned (opBits-1 downto 0);  --current operation
  -- copyR: in boolean;                    --copy for output

  init         : in  std_logic;         --init signal
  ena          : in  std_logic;         --enable input
  encClk       : in  std_logic;         --encoder clock
  dout         : out std_logic := '0';  --data out
  encCycleDone : out std_logic := '0';  --encoder cycle done
  cycleClocks  : inout unsigned (cycleClkBits-1 downto 0) := (others => '0')
  );
end CmpTmrNew;

architecture Behavioral of CmpTmrNew is

component Mult is
  port(
   clr : in std_logic;
   clkEna : in std_logic;
   clk : in std_logic;
   aIn : in std_logic_vector(15 downto 0);
   bIn : in std_logic_vector(23 downto 0);
   rslt : out std_logic_vector(39 downto 0)
   );
end Component;

 -- enable state machine

 type enaFSM is (waitEna, waitEnc, run);
 signal enaState : enaFSM := waitEna;

 signal done : boolean := false;

 -- control signals from enable state machine

 signal clkCtrEna : boolean := false;   --clock counter enable

 -- cmp statue machine

 type fsm is (idle, cycleCalc, cycleUpd);
 signal state : fsm := idle;

 -- control signals from state machine

 signal cycCalcUpd : std_logic := '0';  --cycle calculation update

 -- cycle length register

 signal encCycle : unsigned (cycleLenBits-1 downto 0); --cycle length value

 -- cycle length counter

 signal encCount : unsigned (cycleLenBits-1 downto 0) := (others => '1');
 signal encCountDly : unsigned (cycleLenBits-1 downto 0) := (others => '1');

 -- clock up counter

 signal clockCounter : unsigned (encClkBits-1 downto 0) := to_unsigned(1, encClkBits); --clock counter

 -- encoder clocks

 signal encoderClocks : unsigned (encClkBits-1 downto 0) := (others => '0'); --encoder clocks reg

 -- counters and register for clock counting

 signal clockTotal : unsigned (cycleClkBits-1 downto 0) := (others => '0');  --clock accumulator
 signal encClksExt : unsigned (cycleClkBits-1 downto 0) := (others => '0');  --enc clks extended
  
 -- multiplier

 signal multRst : std_logic := '1';
 signal encCntCLks :
  std_logic_vector((cycleLenBits+encClkBits)-1 downto 0); --mult output

 -- signals for register output

 signal doutCycClks : std_logic;        --output of cycle clocks

begin

 dout <= doutCycClks;

 cycleLenReg : entity work.ShiftOP      --register for cycle length
  generic map(opVal => opBase + F_Ld_Enc_Cycle,
              n => cycleLenBits)
  port map(
   clk => clk,
   inp => inp,
   -- shift => dshift,
   -- op => op,
   -- din => din,
   data => encCycle);

 clockMult: Mult
  port map(
   clr    => multRst,
   clkEna => cycCalcUpd,
   clk    => clk,
   aIn    => std_logic_vector(encCountDly),
   bIn    => std_logic_vector(encoderClocks),
   rslt   => encCntClks);

 cycleClocksOut : entity work.ShiftOutN
  generic map(opVal => opBase + F_Rd_Cmp_Cyc_Clks,
              n => cycleClkBits,
              outBits => outBits)
  port map (
   clk  => clk,
   oRec => oRec,
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

    multRst <= '0';                     --clear multiplier reset
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
     encCountDly <= encCount;           --save for multiplier
     cycCalcUpd <= '1';                 --enable multiplier
     state <= cycleCalc;                --update calc for cycle length

    else                                --if no encoder event
     clockCounter <= clockCounter + 1;  --update clock
    end if;                             --end encoder checks
    
    case state is                       --select state
     when idle =>                       --idle
      enccycledone <= '0';              --clear done flag
      
     when cycleCalc =>                  --calc parts of cycle length
      cycCalcUpd <= '0';                --clear multiply flag
      clockTotal <= (clockTotal +
                     ((cycleClkBits-1 downto encClkBits => '0') &
                      encoderClocks));  --update total clocks
      state <= cycleUpd;                --add for final result

     when cycleUpd =>                   --calc cycle clocks
      cycleClocks <= (unsigned(encCntClks(cycleClkBits-1 downto 0)) +
                      clockTotal);      --calc cycle clocks

      if (done) then                    --if not done
       done <= false;                   --clear local flag
       encCycleDone <= '1';             --set output flag
       clockTotal <= to_unsigned(0, cycleClkBits); --clear total
      end if;
      state <= idle;                    --return to idle state

    end case;                           --end state machine

   end if;                              --end clock counter
  end if;                               --end rising_edge
 end process;

end Behavioral;

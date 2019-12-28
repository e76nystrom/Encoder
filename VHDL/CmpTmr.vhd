--------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    05:23:10 04/09/2018 
-- Design Name: 
-- Module Name:    CmpTmr - Behavioral 
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

entity CmpTmr is
 generic(opBase : unsigned := x"00";
         opBits : positive := 8;
         cycleLenBits : positive := 16;
         encClkBits : positive := 24;
         cycleClkbits : positive := 32);
 port(
  clk : in std_logic;                   --system clock
  din : in std_logic;                   --spi data in
  dshift : in std_logic;                --spi shift signal
  op: in unsigned (opBits-1 downto 0);  --current operation
  copy: in std_logic;                   --copy for output
  init : in std_logic;                  --init signal
  ena : in std_logic;                   --enable input
  encClk : in std_logic;                --encoder clock
  dout: out std_logic := '0';           --data out
  encCycleDone: out std_logic := '0';   --encoder cycle done
  cycleClocks: inout unsigned (cycleClkBits-1 downto 0)
  );
end CmpTmr;

architecture Behavioral of CmpTmr is

 component Shift is
  generic(n : positive);
  port(
   clk : in std_logic;
   shift : in std_logic;
   din : in std_logic;
   data : inout unsigned (n-1 downto 0));
 end component;

 component DownCounter is
  generic(n : positive);
  port(
   clk : in std_logic;
   ena : in std_logic;
   load : in std_logic;
   preset : in unsigned (n-1 downto 0);
   counter : inout  unsigned (n-1 downto 0);
   zero : out std_logic);
 end component;

 component UpCounterOne is
  generic(n : positive);
  port(
   clk : in std_logic;
   init : in std_logic;
   ena : in std_logic;
   counter : inout  unsigned (n-1 downto 0));
 end component;

 component BufN is
  generic(n : positive);
  port (
   clk : in std_logic;
   ena : in std_logic;
   bufIn  : in unsigned (n-1 downto 0);
   bufOut : out unsigned (n-1 downto 0));
 end Component;

 component AccumPlusClr is
  generic(n : positive);
  port(
   clk : in std_logic;
   clr : in std_logic;
   ena : in std_logic;
   a : in unsigned (n-1 downto 0);
   sum : inout unsigned (n-1 downto 0));
 end component;

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

-- component multiplier is
--   port(
--    aclr : in std_logic;
--    clken : in std_logic;
--    clock : in std_logic;
--    dataa : in std_logic_vector(15 downto 0);
--    datab : in std_logic_vector(23 downto 0);
--    result : out std_logic_vector(39 downto 0));
--  end component;

 component AdderTwoInp is
  generic(n : positive := 32);
  port(
   clk : in std_logic;
   clr : in std_logic;
   ena : in std_logic;
   a : in unsigned (n-1 downto 0);
   b : in unsigned (n-1 downto 0);
   sum : out unsigned (n-1 downto 0));
  end component;

 component ShiftOut is
  generic(opVal : unsigned;
          opBits : positive;
          n : positive);
  port (
   clk : in std_logic;
   dshift : in std_logic;
   op : in unsigned (opBits-1 downto 0);
   load : in std_logic;
   data : in unsigned(n-1 downto 0);
   dout : out std_logic
   );
 end Component;

 -- enable state machine

 type enaFSM is (waitEna, waitEnc, run);
 signal enaState : enaFSM := waitEna;

 -- control signals from enable state machine

 signal clkCtrEna : std_logic := '0';   --clock counter enable

 -- cmp statue machine

 type fsm is (idle, cycleCalc, cycleDly, cycEndChk, cycleEnd);
 signal state : fsm := idle;

 -- control signals from state machine

 signal initClear : std_logic := '0';   --initialization clear
 signal initLoad : std_logic := '0';    --initial load
 signal encPulseUpd : std_logic := '0'; --encoder pulse update
 signal cycCalcUpd : std_logic := '0';  --cycle calculation update
 signal cycChkUpd : std_logic := '0';   --cycle check update
 signal cycEndUpd : std_logic := '0';   --cycle end update

 -- cycle length register

 signal cycleLenShift : std_logic;      --shift into cycle len register
 signal encCycle : unsigned (cycleLenBits-1 downto 0); --cycle length value

 -- cycle length counter

 signal loadCycCtr : std_logic;         --load cycle counter
 signal cycleDone : std_logic;          --encoder cycle done
 signal encCount : unsigned (cycleLenBits-1 downto 0); --cycle length counter

 -- clock up counter

 signal clkCtrClr : std_logic;          --clock counter clear
 signal clockCounter : unsigned (encClkBits-1 downto 0); --clock counter

 -- encoder clocks

 signal encoderClocks : unsigned (encClkBits-1 downto 0); --encoder clocks reg

 -- counters and register for clock counting

 signal clrClockTotal : std_logic;      --clear clock accumulator
 signal clockTotal : unsigned (cycleClkBits-1 downto 0);  --clock accumulator
 signal encClksExt : unsigned (cycleClkBits-1 downto 0);  --enc clks extended
  
 -- multiplier

 signal multRst : std_logic := '1';
 signal encCntCLks :
  std_logic_vector((cycleLenBits+encClkBits)-1 downto 0); --mult output

 -- signals for register output

 signal cycleClocksShift : std_logic;   --select cycle clocks
 signal doutCycClks : std_logic;        --output of cycle clocks

begin

 dout_mux: process(op, doutCycClks)
 begin
  if (op = opBase + F_Rd_Cmp_Cyc_Clks) then
   dout <= doutCycClks;
  else
   dout <= '0';
  end if;
 end process dout_mux;

 cycleLenShift <= '1' when ((op = opBase + F_Ld_Enc_Cycle) and (dshift = '1')) else '0';
 
 cycleLenReg: Shift                     --register for cycle length
  generic map(cycleLenBits)
  port map(
   clk => clk,
   shift => cycleLenShift,
   din => din,
   data => encCycle);

 loadCycCtr <= initLoad;

 encCounter: DownCounter                --counter to count down cycle length
  generic map(cycleLenBits)
  port map(
   clk => clk,
   ena => cycCalcUpd,
   load => loadCycCtr,
   preset => encCycle,
   counter => encCount,
   zero => cycleDone);

 clkCtrClr <= initClear or encPulseUpd;
 
 encClkCtr: UpCounterOne            	--count clocks between encoder pulses
 generic map(encClkBits)
  port map(
   clk => clk,
   init => clkCtrClr,
   ena => clkCtrEna,
   counter => clockCounter);

 encClks: BufN
  generic map(n => encClkBits)
  port map (
  clk => clk,
  ena => encPulseUpd,
  bufIn  => clockCounter,
  bufOut => encoderClocks);

 encClksExt <= (cycleClkBits-1 downto encClkBits => '0') & encoderClocks;
 clrClockTotal <= initClear or cycEndUpd;

 clockAccum: AccumPlusClr               --accumulate clock count
  generic map(cycleClkBits)
  port map(
   clk => clk,
   clr => clrClockTotal,
   ena => cycCalcUpd,
   a => encClksExt,
   sum => clockTotal);

 clockMult: Mult
  port map(
   clr => multRst,
   clkEna => cycCalcUpd,
   clk => clk,
   aIn => std_logic_vector(encCount),
   bIn => std_logic_vector(encoderClocks),
   rslt => encCntClks);

 -- clockMult: multiplier                  --multiply encoder count encoder clocks
 --  port map(
 --   aclr => multRst,
 --   clken => cycCalcUpd,
 --   clock => clk,
 --   dataa => std_logic_vector(encCount),
 --   datab => std_logic_vector(encoderClocks),
 --   result => encCntClks);

 cycleClockAdder: AdderTwoInp           --cycle counter
  generic map(cycleClkBits)
  port map(
   clk => clk,
   clr => initClear,
   ena => cycChkUpd,
   a => clockTotal,
   b => unsigned(encCntClks(cycleClkBits-1 downto 0)),
   sum => cycleClocks);

 cycleClocksOut: ShiftOut
  generic map(opVal => opBase + F_Rd_Cmp_Cyc_Clks,
              opBits => opBits,
              n => cycleClkBits)
  port map (
   clk => clk,
   dshift => dshift,
   op => op,
   load => copy,
   data => cycleClocks,
   dout => doutCycClks
   );

 ena_process: process(clk)
 begin
  if (rising_edge(clk)) then            --if clock active
   if (init = '1') then                 --initialize variables
    initClear <= '1';                   --perform initialization clear
    clkCtrEna <= '0';                   --disable clock counter
    initLoad <= '0';                    --clear initial load
    enaState <= waitEna;                --wait for enable
   else
    case enaState is                    --select state
     when  waitEna =>                   --wait for enable
      if (ena = '1') then               --if enabled
       enaState <= waitEnc;             --wait for encoder pulse
      end if;

     when  waitEnc =>                   --wait for encoder
      if (encClk = '1') then            --if encoder pulse
       initClear <= '0';                --initialization done
       initLoad <= '1';                 --perform initial load
       enaState <= run;                 --run
      end if;

     when  run =>                       --run
      initLoad <= '0';                  --clear initial load
      if (ena = '0') then               --if enabled cleared
       clkCtrEna <= '0';                --disable counting
       initClear <= '1';                --perform initialzation clear
       enaState <= waitEna;             --wait for enable
      else
       clkCtrEna <= '1';                --enable clock counter
      end if;

    end case;
   end if;
  end if;
 end process;

 cmp_process: process(clk)
 begin
  if (rising_edge(clk)) then            --if clock active
   if (init = '1') then                 --initialize variables
    multRst <= '0';
    encPulseUpd <= '0';
    cycCalcUpd <= '0';
    cycChkUpd <= '0';
    -- cycDoneUpd <= '0';
    cycEndUpd <= '0';
    encCycleDone <= '0';
    state <= idle;                      --set to idle
   else
    if (clkCtrEna = '1') then           --if clock counter enabled
     case state is                      --select state
      when idle =>                      --idle
       cycChkUpd <= '0';
       cycEndUpd <= '0';
       if (encClk = '1') then           --if encoder clock
        encPulseUpd <= '1';
        state <= cycleCalc;             --update tick
       end if;

      when cycleCalc =>                 --calc cycle length
       encPulseUpd <= '0';
       cycCalcUpd <= '1';
       state <= cycleDly;               --delay a while

       when cycleDly =>                 --cycle delay
       cycCalcUpd <= '0';
       state <= cycEndChk;              --perform end check

      when cycEndChk =>                 --cycle end check
       cycChkUpd <= '1';
       if (cycleDone = '1') then        --if cycle done
        encCycleDone <= '1';
        -- cycDoneUpd <= '1';
        state <= cycleEnd;              --end of cycle processing
       else                             --if not done
        state <= idle;             	--return to idle
       end if;

      when cycleEnd =>                  --end of cycle
       encCycleDone <= '0';
       cycChkUpd <= '0';
       -- cycDoneUpd <= '0';
       cycEndUpd <= '1';
       state <= idle;                   --return to idle state

     end case;
    end if;
   end if;
  end if;
 end process;

end Behavioral;

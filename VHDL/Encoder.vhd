--------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    05:59:16 04/24/2015 
-- Design Name: 
-- Module Name:    Encoder - Behavioral 
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

use work.regDef.all;

entity Encoder is
 port(
  sysClk : in std_logic;
  
  led : out std_logic_vector(7 downto 0) := (7 downto 0 => '0');
  dbg : out std_logic_vector(7 downto 0) := (7 downto 0 => '0');
  anode : out std_logic_vector(3 downto 0) := (3 downto 0 => '1');
  seg : out std_logic_vector(6 downto 0) := (6 downto 0 => '1');

  dclk : in std_logic;
  dout : out std_logic := '0';
  din  : in std_logic;
  dsel : in std_logic;

  encClkOut : out std_logic;
  intClkOut : out std_logic;
  start  : in std_logic;
  ready  : out std_logic := '0';

  a_in : in std_logic;
  b_in : in std_logic
  -- sync_in : in std_logic;
  
  -- EPCS_ASDO : out std_logic;
  -- EPCS_DATA0 : in std_logic;
  -- EPCS_DCLK : out std_logic;
  -- EPCS_NCSO : out std_logic
  );
end Encoder;

architecture Behavioral of Encoder is

 component SystemClk is
  port(
   areset : in std_logic  := '0';
   inclk0 : in std_logic  := '0';
   c0 : out std_logic ;
   locked : out std_logic
   );
 end component;

 component Display is
  port (
   clk : in std_logic;
   dspReg : in unsigned(15 downto 0);
   digSel : in unsigned(1 downto 0);
   anode : out std_logic_vector(3 downto 0);
   seg : out std_logic_vector(6 downto 0)
   );
 end component;

 component Shift is
  generic(n : positive);
  port(
   clk : in std_logic;
   init : in std_logic;
   shift : in std_logic;
   din : in std_logic;
   data : inout unsigned (n-1 downto 0)
   );
 end component;

 component QuadEncoder is
  port(
   clk : in std_logic;
   a : in std_logic;
   b : in std_logic;
   ch : inout std_logic;
   dir : out std_logic;
   dir_ch : out std_logic;
   err : out std_logic
   );
 end component;

 component SPI
  generic (opBits : positive := 8);
  port(
   clk : in std_logic;
   dclk : in std_logic;
   dsel : in std_logic;
   din : in std_logic;
   op : out unsigned (opBits-1 downto 0);
   copy : out std_logic;
   shift : out std_logic;
   load : out std_logic;
   header : inout std_logic
   );
 end component;

 -- component CtlReg is
 --  generic(opVal : unsigned;
 --          opb : positive := 8;
 --          n : positive);
 --  port(
 --   clk : in std_logic;
 --   din : in std_logic;
 --   op : in unsigned(opb-1 downto 0);
 --   shift : in std_logic;
 --   load : in std_logic;
 --   data : inout  unsigned (n-1 downto 0));
 -- end component;

 component ClockEnable is
  port(
   clk : in  std_logic;
   ena : in  std_logic;
   clkena : out std_logic
   );
 end component;

 component CmpTmr
  generic (opBits : positive := 8;
           cycleLenBits : positive := 16;
           encClkBits : positive := 24;
           cycleClkbits : positive := 32);
  port(
   clk : in std_logic;                   --system clock
   initialReset : in std_logic;          --initial reset
   din : in std_logic;                   --spi data in
   dshift : in std_logic;                --spi shift signal
   op: in unsigned (opBits-1 downto 0);  --current operation
   copy: in std_logic;                   --copy for output
   dout: out std_logic;                  --data out
   init : in std_logic;                  --init signal
   ena : in std_logic;                   --enable input
   encClk : in std_logic;                --encoder clock
   encCycleDone: out std_logic;          --encoder cycle done
   cycleClocks: inout unsigned (cycleClkBits-1 downto 0) --cycle counter
   );
 end component;

 component IntTmr is
  generic (opBits : positive := 8;
           cycleLenBits : positive := 16;
           encClkBits : positive := 24;
           cycleClkbits : positive := 32);
  port(
   clk : in std_logic;                  --system clock
   initialReset : in std_logic;         --initial reset
   din : in std_logic;                  --spi data in
   dshift : in std_logic;               --spi shift in
   op: in unsigned (opBits-1 downto 0); --current operation
   copy: in std_logic;                  --copy for output
   dout: out std_logic;                 --data out
   init : in std_logic;                 --init signal
   intClk : out std_logic;              --output clock
   encCycleDone: in std_logic;          --encoder cycle done
   cycleClocks: in unsigned (cycleClkBits-1 downto 0) --cycle counter
   );
 end component;

 component PulseGen is
  generic (step_width : positive := 25);
  port (
   clk : in std_logic;
   step_in : in std_logic;
   step_out : out std_logic
   );
 end component;

 constant opb : positive := 8;
 constant opBits : positive := 8;

 -- system clock

 signal clk1 : std_logic;
 signal locked : std_logic;

 -- quadrature encoder outputs

 signal encClk : std_logic;

 -- clock divider

 constant div_range : integer := 26;
 signal div : unsigned (div_range downto 0);
 alias digSel: unsigned(1 downto 0) is div(19 downto 18);

 -- initialzation and start control variables

 constant delayBits : integer := 4;
 signal initialReset : std_logic := '0';
 signal ctlInit : std_logic := '0';
 signal ctlEna  : std_logic := '0';
 signal ctlDelay : unsigned (delayBits-1 downto 0) := (delayBits-1 downto 0 => '1');

 -- spi interface

 constant out_bits : positive := 32;
 signal copy : std_logic;               --copy to output register
 signal dshift : std_logic;             --shift data
 signal load : std_logic;               --load to register
 signal op : unsigned (opBits-1 downto 0); --operation code
 signal outReg : unsigned (out_bits-1 downto 0); --output register
 signal header : std_logic;

 -- cmpTmr

 constant cycleLenBits : positive := 16;
 constant encClkBits : positive := 24;
 constant cycleClkBits : positive := 32;

 signal encCycleDone : std_logic;
 signal cycleClocks : unsigned (cycleClkBits-1 downto 0);
 signal doutCmpTmr : std_logic;

 -- intTmr

 signal intClk : std_logic;
 signal doutIntTmr : std_logic;

 type ctlFsm is (initial, reset, idle, setReady, init, enable);
 signal ctlState : ctlFsm := initial;

 -- display signals

 constant dspBits : integer := 16;
 signal dspReg : unsigned(opb-1 downto 0);
 -- signal dspUpd : std_logic;
 signal dspData : unsigned(15 downto 0);
 signal dspShift : std_logic;

 -- test signals

 signal test1 : std_logic;
 signal test2 : std_logic;

begin

 led(7) <= locked;
 led(6) <= div(div_range);
 led(5) <= div(div_range-1);
 led(4) <= div(div_range-2);
 led(3) <= op(3);
 led(2) <= op(2);
 led(1) <= op(1);
 led(0) <= op(0);

 -- test 1 output pulse

 testOut1 : PulseGen
  generic map (step_width => 25)
  port map (
   clk => clk1,
   step_in => encCycleDone,
   step_out => test1
   );

-- test 2 output pulse

 testOut2 : PulseGen
  generic map (step_width => 25)
  port map (
   clk => clk1,
   step_in => load,
   step_out => test2
   );

 dbg(0) <= header;
 dbg(1) <= test1;
 dbg(2) <= test2;
 dbg(3) <= div(div_range-3);

 dbg(4) <= div(div_range-4);
 dbg(5) <= div(div_range-5);
 dbg(6) <= div(div_range-6);
 dbg(7) <= div(div_range-7);

 -- system clock

 sys_Clk: SystemClk
  port map (
   areset  => '0',
   inclk0  => sysClk,
   c0      => clk1,
   locked  => locked
   );

 -- quadrature encoder
 
 quad_encoder: QuadEncoder
  port map (
   clk => clk1,
   a => a_in,
   b => b_in,
   ch => encClk,
   dir => open,
   dir_ch => open,
   err => open
   );

 -- encoder output

 enc_clk_out : PulseGen
  generic map (step_width => 50)
  port map (
   clk => clk1,
   step_in => encClk,
   step_out => encClkOut
   );

 -- clock divider

 clk_div: process(clk1)
 begin
  if (rising_edge(clk1)) then
   div <= div + 1;
  end if;
 end process;

 -- -- test clock

 -- testEncClk : ClockEnable
 --  port map (
 --   clk => clk1,
 --   ena => div(20),
 --   clkena => encClk);

 -- display register

 dspShift <= '1' when ((op = F_Ld_Enc_Cycle) and (dshift = '1')) else '0';

 display_reg: Shift
  generic map(dspBits)
  port map(
   clk => clk1,
   init => '0',
   shift => dspShift,
   din => din,
   data => dspData
   );

 -- led display

 led_display : Display
  port map (
   clk => clk1,
   dspReg => dspData,
   digSel => digSel,
   anode => anode,
   seg => seg
   );

 -- spi interface

 spi_int : SPI
  generic map (opBits)
  port map (
   clk => clk1,
   dclk => dclk,
   dsel => dsel,
   din => din,
   op => op,
   copy => copy,
   shift => dshift,
   load => load,
   header => header
   --info => spiInfo
   );

 -- spi return data

 dout <= doutCmpTmr or doutIntTmr;

 outReg_proc : process(clk1)
 begin
  if (rising_edge(clk1)) then
   if (copy = '1') then
    case op is
     when x"00" => 
      outReg <= (out_bits-1 downto 0 => '0');
     when x"01" =>
      outReg <= cycleClocks;
     when others =>
      outReg <= x"55aa55aa";
    end case;
   else
    if (dshift = '1') then
     outReg <= outReg(out_bits-2 downto 0) & outReg(out_bits-1);
    end if;
   end if;
  end if;
 end process;

 -- rCtl : CtlReg
 --  generic map (opVal => XLDCTL,
 --               opb => opb,
 --               n => rCtlSize)
 --  port map (
 --   clk => clk1,
 --   din => din,
 --   op => op,
 --   shift => dshift,
 --   load => load,
 --   data => rCtlReg);

 ctl_process: process(clk1)
 begin
  if (rising_edge(clk1)) then            --if clock active
   case ctlState is
    when initial =>
     initialReset <= '1';
     ready <= '0';
     ctlDelay <= (delayBits-1 downto 0 => '1');
     ctlState <= reset;

    when reset =>
     if (ctlDelay = 0) then
      initialReset <= '0';
      ctlState <= idle;
     else
      ctlDelay <= ctlDelay - 1;
     end if;

    when idle =>
     if (start = '1') then
      ready <= '0';
      ctlEna <= '0';
      ctlInit <= '1';
      ctlDelay <= (delayBits-1 downto 0 => '1');
      ctlState <= init;
     end if;
     
    when init =>
     if (ctlDelay = 0) then
      ctlInit <= '0';
      ctlState <= enable;
     else
      ctlDelay <= ctlDelay - 1;
     end if;

    when enable =>
     ctlEna <= '1';
     ready <= '1';
     ctlState <= setReady;

    when setReady =>
     if (start = '0') then
      ctlState <= idle;
     end if;
   end case;
  end if;
 end process;

 cmp_tmr : CmpTmr
  generic map (cycleLenBits => cycleLenBits,
               encClkBits => encClkBits,
               cycleClkbits => cycleClkBits)
  port map (
   clk => clk1,
   initialReset => initialReset,
   din => din,
   dshift => dshift,
   op => op,
   copy => copy,
   dout => doutCmpTmr,
   init => ctlInit,
   ena => ctlEna,
   encClk => encClk,
   encCycleDone => encCycleDone,
   cycleClocks => cycleClocks
   );

 int_tmr : IntTmr
  generic map (cycleLenBits => cycleLenBits,
               encClkBits => encClkBits,
               cycleClkbits => cycleClkBits)
  port map (
   clk => clk1,
   initialReset => initialReset,
   din => din,
   dshift => dshift,
   init => ctlInit,
   op => op,
   copy => copy,
   dout => doutIntTmr,
   intClk => intClk,
   encCycleDone => encCycleDone,
   cycleClocks => cycleClocks
   );

 -- intTmr  output

 int_tmr_out : PulseGen
  generic map (step_width => 50)
  port map (
   clk => clk1,
   step_in => intClk,
   step_out => intClkOut
   );

end Behavioral;

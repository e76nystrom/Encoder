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

entity Encoder is
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
  intClk  : out std_logic := '0';
  start  : in std_logic;
  ready  : out std_logic := '0';
  
  initialReset : in std_logic
  );
end Encoder;

architecture Behavioral of Encoder is

 component SystemClk is
  PORT
   (
    areset : IN STD_LOGIC  := '0';
    inclk0 : IN STD_LOGIC  := '0';
    c0 : OUT STD_LOGIC ;
    locked : OUT STD_LOGIC 
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
   clkena : out std_logic);
 end component;

 component CmpTmr
  generic (opBits : positive := 8;
           cycleLenBits : positive := 16;
           encClkBits : positive := 24;
           cycleClkbits : positive := 32);
  port(
   clk : in std_logic;                   --system clock
   din : in std_logic;                   --spi data in
   dshift : in std_logic;                --spi shift signal
   initialReset : in std_logic;          --initial reset
   init : in std_logic;                  --init signal
   ena : in std_logic;                   --enable input
   encClk : in std_logic;                --encoder clock
   cycleSel: in std_logic;               --cycle length register select
   encCycleDone: out std_logic;          --encoder cycle done
   cycleClocks: inout unsigned (cycleClkBits-1 downto 0); --cycle counter
   op: in unsigned (opBits-1 downto 0);
   copy: in std_logic;
   dout: out std_logic
   );
 end component;

 component IntTmr is
  generic (cycleLenBits : positive := 16;
           encClkBits : positive := 24;
           cycleClkbits : positive := 32);
  port(
   clk : in std_logic;                 --system clock
   din : in std_logic;                 --spi data in
   dshift : in std_logic;              --spi shift in
   initialReset : in std_logic;          --initial reset
   init : in std_logic;                --init signal
   intClk : out std_logic;             --output clock
   cycleSel : in std_logic;            --cycle length register select
   encCycleDone: in std_logic;         --encoder cycle done
   cycleClocks: in unsigned (cycleClkBits-1 downto 0) --cycle counter
   );
 end component;

 constant opb : positive := 8;
 constant opBits : positive := 8;

-- skip register zero

 constant XNOOP        : unsigned(opb-1 downto 0) := x"00"; -- register 0

 constant XLDENCCYCLE : unsigned (opBits-1 downto 0) := x"01";
 constant XLDINTCYCLE : unsigned (opBits-1 downto 0) := x"02";
 constant XLDCTL : unsigned (opBits-1 downto 0) := x"03";

 -- system clock

 signal clk1 : std_logic;
 signal locked : std_logic;

 -- clock divider

 constant div_range : integer := 26;
 signal div : unsigned (div_range downto 0);

 signal ctlInit : std_logic := '0';
 signal ctlEna  : std_logic := '0';
 signal ctlDelay : unsigned (4-1 downto 0);

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

 -- signal encClk : std_logic;
 signal cmpCycleSel : std_logic;
 signal encCycleDone : std_logic;
 signal cycleClocks : unsigned (cycleClkBits-1 downto 0);
 signal doutCmpTmr : std_logic;

 -- intTmr

 signal intCycleSel : std_logic;

 -- constant rCtlSize : positive := 2;
 -- signal rCtlReg : unsigned (rCtlSize-1 downto 0) := "00";
 -- alias ctlInit : std_logic is rCtlReg(0);
 -- alias ctlEna  : std_logic is rCtlReg(1);

 type ctlFsm is (idle, setReady, init, enable);
 signal ctlState : ctlFsm := idle;

begin

 led(7) <= locked;
 led(6) <= div(div_range);
 led(5) <= div(div_range-1);
 led(4) <= div(div_range-2);
 led(3) <= div(div_range);
 led(2) <= div(div_range);
 led(1) <= div(div_range);
 led(0) <= div(div_range);

 dbg0 <= div(div_range-3);
 dbg1 <= div(div_range-4);
 dbg2 <= header;
 dbg3 <= load;

 -- system clock

 sys_Clk: SystemClk
  port map (
   areset  => '0',
   inclk0  => sysClk,
   c0      => clk1,
   locked  => locked
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

 -- dout <= outReg(out_bits-1);
 dout <= doutCmpTmr;

 outReg_proc : process(clk1)
 begin
  if (rising_edge(clk1)) then
--   if (copy = '1') or ((dspUpd = '1') and (dsel = '1')) then
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
    when idle =>
     if (start = '1') then
      ctlEna <= '0';
      ctlInit <= '1';
      ctlDelay <= x"f";
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

 cmpCycleSel <= '1' when (op = XLDENCCYCLE) else '0';
 
 cmp_tmr : CmpTmr
  generic map (cycleLenBits => cycleLenBits,
               encClkBits => encClkBits,
               cycleClkbits => cycleClkBits)
  port map (
   clk => clk1,
   din => din,
   dshift => dshift,
   initialReset => initialReset,
   init => ctlInit,
   ena => ctlEna,
   encClk => encClk,
   cycleSel => cmpCycleSel,
   encCycleDone => encCycleDone,
   cycleClocks => cycleClocks,
   op => op,
   copy => copy,
   dout => doutCmpTmr
   );

 intCycleSel <= '1' when (op = XLDINTCYCLE) else '0';

 int_tmr : IntTmr
  generic map (cycleLenBits => cycleLenBits,
               encClkBits => encClkBits,
               cycleClkbits => cycleClkBits)
  port map (
   clk => clk1,
   din => din,
   dshift => dshift,
   init => ctlInit,
   initialReset => initialReset,
   intClk => intClk,
   cycleSel => intCycleSel,
   encCycleDone => encCycleDone,
   cycleClocks => cycleClocks
   );

end Behavioral;

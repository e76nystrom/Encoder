--------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:31:15 04/05/2015 
-- Design Name: 
-- Module Name:    DbgClk - Behavioral 
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
use work.FpgaEncBits.all;

entity DbgClk is
 generic(opBits : positive := 8;
         freq_bits : positive;
         count_bits : positive);
 port (
  clk : in std_logic;
  a : in std_logic;
  b : in std_logic;
  din : in std_logic;
  dshift : in std_logic;
  op: in unsigned (opBits-1 downto 0);
  load : in std_logic;
  a_out : out std_logic := '0';
  b_out : out std_logic := '0';
  dbgPulse : out std_logic := '0';
  dbgDone: out std_logic := '0');
end DbgClk;

architecture Behavioral of DbgClk is

 component CtlReg is
 generic(opVal : unsigned;
         n : positive);
  port (
   clk : in std_logic;
   din : in std_logic;
   op : unsigned(opb-1 downto 0);
   shift : in std_logic;
   load : in std_logic;
   data : inout  unsigned (n-1 downto 0));
 end component;

 component FreqGen
  generic(freq_bits : positive);
  port(
   clk : in std_logic;
   ena : in std_logic;
   dshift : in std_logic;
   freq_sel : in std_logic;
   din : in std_logic;
   pulse_out : out std_logic
   );
 end component;

 component Shift is
  generic(n : positive);
  port (
   clk : in std_logic;
   init : in std_logic;
   shift : in std_logic;
   din : in std_logic;
   data : inout unsigned(n-1 downto 0));
 end component;

 component DownCounter is
  generic(n : positive);
  port (
   clk : in std_logic;
   clr : in std_logic;
   ena : in std_logic;
   load : in std_logic;
   preset : in unsigned (n-1 downto 0);
   counter : inout  unsigned (n-1 downto 0);
   zero : out std_logic);
 end component;

 type fsm is (idle, run, upd_output);
 signal state : fsm;

 signal sq : std_logic_vector(1 downto 0) := "00";
 signal count : unsigned(count_bits-1 downto 0);
 signal counter : unsigned(count_bits-1 downto 0);
 signal freqShift : std_logic;
 signal countShift : std_logic;
 signal countLoad : std_logic := '0';
 signal pulseOut : std_logic;
 signal freqEna : std_logic := '0';
 signal countDown : std_logic := '0';
 signal countZero : std_logic;

begin

 -- debug control register

 dbgctl : CtlReg
  generic map (opVal => F_Ld_Dbg_Ctl,
               n => dCtl_size)
  port map (
   clk => clk,
   din => din,
   op => op,
   shift => dshift,
   load => load,
   data => dCtlReg);

 freqShift <= '1' when ((op = F_Ld_Dbg_Freq) and (dshift = '1')) else '0';

 clock: FreqGen
  generic map(freq_bits)
  port map (
   clk => clk,
   ena => freqEna,
   dshift => dshift,
   freq_sel => freqShift,
   din => din,
   pulse_out => pulseOut
   );

 countShift <= '1' when ((op = F_Ld_Dbg_Count) and (dshift = '1'))
               else '0';

 countreg: Shift
  generic map(count_bits)
  port map (
   clk => clk,
   init => '0',
   shift => countShift,
   din => din,
   data => count);
 
 dbgCtr: DownCounter
  generic map(count_bits)
  port map (
   clk => clk,
   clr => '0',
   ena => countDown,
   load => countLoad,
   preset => count,
   counter => counter,
   zero => countZero);

 a_out <= sq(0) when (DbgSel = '1') else a;
 b_out <= sq(1) when (DbgSel = '1') else b;

 dbg_proc: process(clk)
 begin
  if (rising_edge(clk)) then
   if (dbgEna = '0') then               --if not enabled
    state <= idle;                      --set sart state
    freqEna <= '0';                     --stop frequency generator
    dbgDone <= '0';                     --clear done flag
    dbgPulse <= '0';                    --clear debug clock
   else
    case state is
     when idle =>                      --idle state
      freqEna <= '1';                  --enable frequency generator
      countLoad <= '1';                --load counter
      state <= run;                    --set state to run

     when run =>                        --runnint state
      countLoad <= '0';                 --clear count load
      DbgPulse <= '0';                  --clear debug pulse
      if (pulseOut = '1') then          --if clock pulse present
       if (DbgCount = '0') then         --if not using count
        state <= upd_output;
       else                             --if using count
        if (countZero = '0') then       --if counter non zero
         countDown <= '1';              --set to count down
         state <= upd_output;
        else
         freqEna <= '0';                --stop frequency generator
         dbgDone <= '1';                --set done flag
         state <= idle;                 --return to idle state
        end if;
       end if;
      end if;

     when upd_output =>                 --update output
      countDown <= '0';                 --clear count down flag
      dbgPulse <= '1';                  --ouput debug pulse
      state <= run;
      if (DbgDir = '1') then
       case (sq) is
        when "00" => sq <= "01";
        when "01" => sq <= "11";
        when "11" => sq <= "10";
        when "10" => sq <= "00";
        when others => sq <= "00";    
       end case;
      else
       case (sq) is
        when "00" => sq <= "10";
        when "10" => sq <= "11";
        when "11" => sq <= "01";
        when "01" => sq <= "00";
        when others => sq <= "00";    
       end case;
      end if;
    end case;
   end if;
  end if;
 end process;
end Behavioral;

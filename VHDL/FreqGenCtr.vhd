--------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:00:00 12/12/2019
-- Design Name: 
-- Module Name:    FreqGenCtr - Behavioral 
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

entity FreqGenCtr is
 generic(opBits : positive := 8;
         freqOp : unsigned;
         countOp : unsigned;
         freqBits : positive;
         countBits: positive);
 port (
  clk : in std_logic;
  din : in std_logic;
  dshift : in std_logic;
  load : in std_logic;
  op : in unsigned(opBits-1 downto 0);
  pulseOut : out std_logic := '0'
  );
end FreqGenCtr;

architecture Behavioral of FreqGenCtr is

 component Shift is
  generic(n : positive);
  port (
   clk : in std_logic;
   shift : in std_logic;
   din : in std_logic;
   data : inout unsigned(n-1 downto 0));
 end component;

 type fsm is (idle, run, updCount, chkCount);
 signal state : fsm := idle;

 
 signal freqSel : std_logic;
 signal freqShift : std_logic;

 signal freqVal : unsigned(freqBits-1 downto 0);
 signal freqCounter : unsigned(freqBits-1 downto 0) :=
  (freqBits-1 downto 0 => '0');

 signal countSel : std_logic;
 signal countShift : std_logic;

 signal countVal : unsigned(countBits-1 downto 0);
 signal outputCounter : unsigned(countBits-1 downto 0) :=
  (countBits-1 downto 0 => '0');

begin

 freqSel <= '1' when (op = freqOp) else '0';
 freqShift <= '1' when ((freqSel = '1') and (dshift = '1')) else '0';

 freqReg: Shift
  generic map(freqBits)
  port map (
   clk => clk,
   shift => freqShift,
   din => din,
   data => freqVal);

 countSel <= '1' when (op = countOp) else '0';
 countShift <= '1' when ((countSel = '1') and (dshift = '1')) else '0';
 
 countReg: Shift
  generic map(countBits)
  port map (
   clk => clk,
   shift => countShift,
   din => din,
   data => countVal);

 freqCtr: process(clk)
 begin
  if (rising_edge(clk)) then            --if clock active
   if (freqSel = '1') then              --if changing frequency
    state <= idle;                      --return to idle state
   else
    case state is
     when idle =>                        --idle
      if ((countSel = '1') and (load = '1')) then
       outputCounter <= countVal;
       freqCounter <= freqVal;
       state <= run;
      end if;

     when run =>                         --run
      if (freqCounter = (freqBits-1 downto 0 => '0')) then --if counter zero
       freqCounter <= freqVal;            --reload counter
       pulseOut <= '1';                   --activate frequency pulse
       state <= updCount;
      else                                --if counter non zero
       pulseOut <= '0';                   --clear output pulse
       freqCounter <= freqCounter - 1;    --count down
      end if;

     when updCount =>                    --update count
      freqCounter <= freqCounter - 1;    --count down
      pulseOut <= '0';                   --clear output pulse
      if (outputCounter = (countBits-1 downto 0 => '0')) then --if count zero
       state <= run;                     --return to run state
      else                               --if count non zero
       outputCounter <= outputCounter - 1; --count down
       state <= chkCount;                --adancee to check count state
      end if;

     when chkCount =>                    --check count
      freqCounter <= freqCounter - 1;    --count down
      if (outputCounter /= (countBits-1 downto 0 => '0')) then --if non zero
       state <= run;                     --continue in run state
      else                               --if count zero
       state <= idle;                    --return to idle state
      end if;
    end case;
   end if;
  end if;
 end process freqCtr;

end Behavioral;


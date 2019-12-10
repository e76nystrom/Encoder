--------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    05:52:53 01/29/2015 
-- Design Name: 
-- Module Name:    FreqGen - Behavioral 
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

entity FreqGen is
 generic(freq_bits : positive);
 port (
  clk : in std_logic;
  ena : in std_logic;
  din : in std_logic;
  dshift : in std_logic;
  freq_sel : in std_logic;
  pulse_out : out std_logic := '0'
  );
end FreqGen;

architecture Behavioral of FreqGen is

 component Shift is
  generic(n : positive);
  port (
   clk : in std_logic;
   init : in std_logic;
   shift : in std_logic;
   din : in std_logic;
   data : inout  unsigned (freq_bits-1 downto 0));
 end component;

 signal freq_shift : std_logic;
 signal counter :
 unsigned(freq_bits-1 downto 0) := (freq_bits-1 downto 0 => '0');
 signal freq_val : unsigned(freq_bits-1 downto 0);

begin

 freq_shift <= freq_sel and dshift;

 freqreg: Shift
  generic map(freq_bits)
  port map (
   clk => clk,
   init => '0',
   shift => freq_shift,
   din => din,
   data => freq_val);

 FreqGen: process(clk)
 begin
  if (rising_edge(clk)) then            --if clock active
   if (ena = '1') then                  --if enabled
    if (counter = (freq_bits-1 downto 0 => '0')) then --if counter zero
     counter <= freq_val;               --reload counter
     pulse_out <= '1';                  --activate frequency pulse
    else                                --if counter non zero
     pulse_out <= '0';                  --clear output pulse
     counter <= counter - 1;            --count down
    end if;
   else                                 --if not enabled
    pulse_out <= '0';                   --reset counter pulse
   end if;
  end if;
 end process FreqGen;

end Behavioral;


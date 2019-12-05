--------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:33:37 01/25/2015 
-- Design Name: 
-- Module Name:    UpCounterOne - Behavioral 
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

entity UpCounterOne is
 generic(n : positive);
 port (
  clk : in std_logic;
  init : in std_logic;
  ena : in std_logic;
  counter : inout  unsigned (n-1 downto 0));
end UpCounterOne;

architecture Behavioral of UpCounterOne is

begin

 UpCounterOne: process(clk)
 begin
  if (rising_edge(clk)) then
   if (init = '1') then
    counter <= (n-2 downto 0 => '0') & '1';
   elsif (ena = '1') then
    counter <= counter + 1;
   end if;
  end if;
 end process UpCounterOne;

end Behavioral;

--------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:34:36 01/24/2015 
-- Design Name: 
-- Module Name:    AccumPlusClr - Behavioral 
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

entity AccumPlusClr is
 generic (n : positive);
 port ( clk : in std_logic;
        clr : in std_logic;
        ena : in std_logic;
        a : in unsigned (n-1 downto 0);
        sum : inout unsigned (n-1 downto 0));
end AccumPlusClr;

architecture Behavioral of AccumPlusClr is

begin

 accumulator: process(clk)
 begin
  if (rising_edge(clk)) then
   if (clr = '1') then
    sum <= (n-1 downto 0 => '0');
   elsif (ena = '1') then
     sum <= sum + a;
   end if;
  end if;
 end process accumulator;

end Behavioral;

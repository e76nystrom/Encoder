--------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:33:37 01/25/2015 
-- Design Name: 
-- Module Name:    UpCounter - Behavioral 
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

entity UpCounter is
 generic(n : positive);
 port (
  clk : in std_logic;
  clr : in std_logic;
  ena : in std_logic;
  counter : inout  unsigned (n-1 downto 0));
end UpCounter;

architecture Behavioral of UpCounter is

begin

 upcounter: process(clk)
 begin
  if (rising_edge(clk)) then
   if (clr = '1') then
    counter <= (n-1 downto 0 => '0');
   elsif (ena = '1') then
    counter <= counter + 1;
   end if;
  end if;
 end process UpCounter;

end Behavioral;

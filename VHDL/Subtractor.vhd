--------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:34:36 01/24/2015 
-- Design Name: 
-- Module Name:    Subtractor - Behavioral 
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

entity Subtractor is
 generic (n : positive);
 port (
  clk : in std_logic;
  load : in std_logic;
  ena : in std_logic;
  a : in unsigned (n-1 downto 0);
  b : in unsigned (n-1 downto 0);
  diff : inout unsigned (n-1 downto 0));
end Subtractor;

architecture Behavioral of Subtractor is

begin

 Subtractor: process(clk)
 begin
  if (rising_edge(clk)) then
   if (load = '1') then
    diff <= a;
   else
    if (ena = '1') then
     diff <= a - b;
    end if;
   end if;
  end if;
 end process Subtractor;

end Behavioral;

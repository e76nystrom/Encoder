-------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    06:41:15 03/05/2009 
-- Design Name: 
-- Module Name:    ClockEnable - Behavioral 
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
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ClockEnable1 is
 generic (n : positive := 1);
 Port ( clk : in  std_logic;
        ena : in  std_logic;
        clkena : out std_logic);
end ClockEnable1;

architecture Behavioral of ClockEnable1 is

 constant delayLen : positive := n*2;
 signal clkdly : std_logic_vector(delayLen-1 downto 0);

begin

 ena_proc: process(clk)
 begin
  if (rising_edge(clk)) then
   if (ena = '0') then
    clkdly <= (delayLen-1 downto 0 => '0');
   else
    clkdly <= clkdly(delayLen-2 downto 0) & ena;
   end if;
  end if;
 end process;

 clkena <= '1' when clkdly = ((n-1 downto 0 => '0') & (n-1 downto 0 => '1'))
           else '0';

end Behavioral;

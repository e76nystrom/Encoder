--------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:00:00 12/23/2010
-- Design Name: 
-- Module Name:    BufN - Behavioral 
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

entity BufN is
 generic(n : positive);
 port (
  clk : in std_logic;
  ena : in std_logic;
  bufIn  : in unsigned (n-1 downto 0);
  bufOut : out unsigned (n-1 downto 0) := (others => '0'));
end BufN;

architecture Behavioral of BufN is

begin

 BufProcess: process(clk)
 begin
  if (rising_edge(clk)) then
   if (ena = '1') then
    bufOut <= bufIn;
   end if;
  end if;
 end process BufProcess;

end Behavioral;

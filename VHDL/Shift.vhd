--------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:02:29 01/24/2015 
-- Design Name: 
-- Module Name:    Shift - Behavioral 
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

entity Shift is
 generic(n : positive);
 port(
  clk : in std_logic;
  din : in std_logic;
  shift : in std_logic;
  data : inout unsigned (n-1 downto 0) := (others => '0')
  );
end Shift;

architecture Behavioral of Shift is

begin

shift_reg: process (clk)
 begin
  if (rising_edge(clk)) then
   if (shift = '1') then
    data <= data(n-2 downto 0) & din;
   end if;
  end if;
 end process shift_reg;

end Behavioral;


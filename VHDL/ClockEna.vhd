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

entity ClockEnable is
 Port ( clk : in  std_logic;
        ena : in  std_logic;
        clkena : out std_logic);
end ClockEnable;

architecture Behavioral of ClockEnable is

 signal clkdly : std_logic_vector(1 downto 0);

begin

 ena_proc: process(clk)
 begin
  if (rising_edge(clk)) then
   clkdly <= clkdly(0) & ena;
  end if;
 end process;

 clkena <= clkdly(0) and not clkdly(1);

end Behavioral;

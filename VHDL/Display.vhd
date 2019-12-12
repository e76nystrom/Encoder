----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:09:10 04/05/2015 
-- Design Name: 
-- Module Name:    Display - Behavioral 
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
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Display is
 port ( clk : in std_logic;
        dspreg : in unsigned(15 downto 0);
        digSel : in unsigned(1 downto 0);
        anode : out std_logic_vector(3 downto 0);
        seg : out std_logic_vector(6 downto 0)
        );
end Display;

architecture Behavioral of Display is

 signal digInp : unsigned(3 downto 0);

begin

 dig_display: process(clk)
 begin
  if (rising_edge(clk)) then
   case digSel is
    when "00" => anode <= "0111";
    when "01" => anode <= "1011";
    when "10" => anode <= "1101";
    when "11" => anode <= "1110";
    when others => null;
   end case;
  end if;
 end process;

 sel_digit: process(clk)
 begin
  if (rising_edge(clk)) then
   case digSel is
    when "00" => digInp <= dspreg(15 downto 12);
    when "01" => digInp <= dspreg(11 downto 8);
    when "10" => digInp <= dspreg(7 downto 4);
    when "11" => digInp <= dspreg(3 downto 0);
    when others => null;
   end case;
  end if;
 end process;

 seg_display: process(clk)
 begin
  if (rising_edge(clk)) then
   case digInp is
    when "0000" => seg <= not "1111110";
    when "0001" => seg <= not "0110000";
    when "0010" => seg <= not "1101101";
    when "0011" => seg <= not "1111001";
    when "0100" => seg <= not "0110011";
    when "0101" => seg <= not "1011011";
    when "0110" => seg <= not "1011111";
    when "0111" => seg <= not "1110000";
    when "1000" => seg <= not "1111111";
    when "1001" => seg <= not "1110011";
    when "1010" => seg <= not "1110111";
    when "1011" => seg <= not "0011111";
    when "1100" => seg <= not "1001110";
    when "1101" => seg <= not "0111101";
    when "1110" => seg <= not "1001111";
    when "1111" => seg <= not "1000111";
    when others => seg <= not "0000000";
   end case;
  end if;
 end process;

end Behavioral;


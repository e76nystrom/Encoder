--------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:09:04 01/25/2015 
-- Design Name: 
-- Module Name:    QuadEncoder - Behavioral 
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity QuadEncoder is
 port (
  clk : in std_logic;
  a : in std_logic;
  b : in std_logic;
  ch : inout std_logic;
  dir : out std_logic := '0';
  dir_ch : out std_logic := '0';
  err : out std_logic := '0');
end QuadEncoder;

architecture Behavioral of QuadEncoder is

 signal last_a : std_logic_vector(1 downto 0);
 signal last_b : std_logic_vector(1 downto 0);
 signal last_dir : std_logic_vector(1 downto 0);
 signal dirInt : std_logic;

begin

 dir <= dirInt;

 delay_proc: process(clk)
 begin
  if (rising_edge(clk)) then
   last_a <= last_a(0) & a;
   last_b <= last_b(0) & b;
   last_dir <= last_dir(0) & dirInt;
  end if;
 end process;

 ch <= (last_a(1) xor last_a(0)) or (last_b(1) xor last_b(0)); --input change
 dir_ch <= last_dir(1) xor last_dir(0);  --direction change

 -- calculate direction based upon a and b inputs
 
 direction_process: process(clk, ch)
  variable dir_inp : std_logic_vector(3 downto 0);
 begin
  if (rising_edge(clk) and (ch = '1')) then
   dir_inp := last_b(1) & last_a(1) & last_b(0) & last_a(0); --direction
   case (dir_inp) is
    when "0001" => dirInt <= '0'; err <= '0';
    when "0111" => dirInt <= '0'; err <= '0';
    when "1110" => dirInt <= '0'; err <= '0';
    when "1000" => dirInt <= '0'; err <= '0';
    when "0010" => dirInt <= '1'; err <= '0';
    when "1011" => dirInt <= '1'; err <= '0';
    when "1101" => dirInt <= '1'; err <= '0';
    when "0100" => dirInt <= '1'; err <= '0';
    when "0000" => err <= '0';
    when "0101" => err <= '0';
    when "1111" => err <= '0';
    when "1010" => err <= '0';
    when others => err <= '1';
   end case;
  end if;
 end process;

end Behavioral;


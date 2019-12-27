 --------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:42:00 11/18/2019
-- Design Name: 
-- Module Name:    ShiftOut - Behavioral 
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

entity ShiftOut is
 generic(n : positive);
 port ( clk : in std_logic;
        load : in std_logic;
        shift : in std_logic;
        data : in unsigned (n-1 downto 0);
        dout : out std_logic := '0'
        );
end ShiftOut;

architecture Behavioral of ShiftOut is

 signal shiftReg : unsigned(n-1 downto 0) := (n-1 downto 0 => '0');
 
begin

dout <= shiftReg(n-1);

shift_out: process (clk)
 begin
  if (rising_edge(clk)) then
   if (load = '1') then
    shiftReg <= data;
   elsif (shift = '1') then
    shiftReg <= shiftReg(n-2 downto 0) & shiftReg(n-1);
   end if;
  end if;
 end process shift_out;

end Behavioral;


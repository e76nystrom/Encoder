--------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:13:33 01/24/2015 
-- Design Name: 
-- Module Name:    DataSel - Behavioral 
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

entity DataSel2 is
 generic(n : positive);
 port ( sel : in std_logic;
        data0 : in unsigned (n-1 downto 0);
        data1 : in unsigned (n-1 downto 0);
        data_out : out unsigned (n-1 downto 0));
end DataSel2;

architecture Behavioral of DataSel2 is

begin

 DataSel2: process(sel, data0, data1)
 begin
  case (sel) is
   when '0' => data_out <= data0;
   when '1' => data_out <= data1;
   when others => data_out <= (n-1 downto 0 => '0');          
  end case;
 end process DataSel2;

end Behavioral;


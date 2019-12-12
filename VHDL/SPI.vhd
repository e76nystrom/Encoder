--------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    07:30:59 01/25/2015 
-- Design Name: 
-- Module Name:    SPI - Behavioral 
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

entity SPI is
 generic (opBits : positive := 8);
 port (
  clk : in std_logic;                    --system clock
  dclk : in std_logic;                   --spi clk
  dsel : in std_logic;                   --spi select
  din : in std_logic;                    --spi data in
  op : out unsigned(opBits-1 downto 0) := (opBits-1 downto 0 => '0');  --op code
  copy : out std_logic := '0';          --copy data to be shifted out
  shift : out std_logic := '0';         --shift data
  load : out std_logic := '0';          --load data shifted in
  header : inout std_logic := '0'       --receiving header
  --info : out std_logic_vector(2 downto 0) --state info
  );
end SPI;

architecture Behavioral of SPI is

 component ClockEnable1 is
 generic (n : positive);
  Port (
   clk : in  std_logic;
   ena : in  std_logic;
   clkena : out std_logic);
 end component;

 type spi_fsm is (start, idle, read_hdr, chk_count, upd_count,
                  active, dclk_wait, load_reg);
 signal state : spi_fsm := start;

 signal count : unsigned(3 downto 0) := "1000";
 signal opReg : unsigned(opbits-1 downto 0); --op code

 signal clkena : std_logic;
 constant n : positive := 4;
 signal dseldly : std_logic_vector(n-1 downto 0);
 signal dselEna : std_logic;
 signal dselDis : std_logic;

 --function convert(a: spi_fsm) return std_logic_vector is
 --begin
 -- case a is
 --  when start     => return("111");
 --  when idle      => return("000");
 --  when read_hdr  => return("001");
 --  when chk_count => return("010");
 --  when upd_count => return("011");
 --  when active    => return("100");
 --  when dclk_wait => return("101");
 --  when load_reg  => return("110");
 --  when others    => null;
 -- end case;
 -- return("000");
 --end;

begin

 --info <= convert(state);

 clk_ena: ClockEnable1
  generic map(n => 4)
  port map (
   clk => clk,
   ena => dclk,
   clkena =>clkena);

 dselEna <= '1' when dseldly = (n-1 downto 0 => '0') else '0';
 dselDis <= '1' when dseldly = (n-1 downto 0 => '1') else '0';

 din_proc: process(clk)
 begin
  if (rising_edge(clk)) then
   dseldly <= dseldly(n-2 downto 0) & dsel;
   case state is
    when start =>
     if (dsel = '1') then
      op <= (opBits-1 downto 0 => '0');
      header <= '1';
      state <= idle;
     end if;

    when idle =>
     shift <= '0';
     load <= '0';
     copy <= '0';
     if (dselEna = '1') then
      header <= '1';
      opReg <= (opBits-1 downto 0 => '0');
      count <= "1000";
      state <= read_hdr;
     end if;

    when read_hdr =>
     if (dselDis = '1') then
      state <= idle;
     else
      if (clkena = '1') then
       opReg <= opReg(opBits-2 downto 0) & din;
       state <= upd_count;
      end if;
     end if;

    when upd_count =>
     count <= count - 1;
     state <= chk_count;

    when chk_count =>
     if (count = "0000") then
      op <= opReg;
      header <= '0';
      copy <= '1';
      state <= active;
     else
      state <= read_hdr;
     end if;

    when active =>
     copy <= '0';
     if (dselDis = '1') then
      state <= load_reg;
     else
      if (clkena = '1') then
       shift <= '1';
       state <= dclk_wait;
      end if;
     end if;

    when dclk_wait =>
     shift <= '0';
     state <= active;
 
    when load_reg =>
     load <= '1';
     state <= idle;

   end case;
  end if;
 end process;

end Behavioral;

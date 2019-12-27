library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.ALL;

package SimProc is

 -- Clock period definitions
 constant clk_period : time := 10 ns;
 constant opbx : positive := 8;

 signal clk : std_logic := '0';

 -- signal dsel : std_logic;
 -- signal dout : std_logic;
 -- signal din : std_logic;
 -- signal dclk : std_logic;

 procedure delay(constant n : in integer;
                 signal clock : std_logic);
 procedure delay(constant n : in integer);
 
 procedure loadParm(constant parmIdx : in unsigned (opbx-1 downto 0);
                    signal dsel : out std_logic;
                    signal din : out std_logic;
                    signal dclk : out std_logic);

 procedure loadValue(signal value : natural;
                     constant bits: in natural;
                     signal dsel : out std_logic;
                     signal din : out std_logic;
                     signal dclk : out std_logic);

 procedure loadShift(variable value : in integer;
                     constant bits : in natural;
                     signal shift : out std_logic;
                     signal din : out std_logic);

 procedure loadCtl(variable value : in integer;
                   constant bits : in natural;
                   signal shift : out std_logic;
                   signal din : out std_logic;
                   signal load : out std_logic);

end SimProc;

package body SimProc is

 procedure delay(constant n : in integer;
                 signal clock : std_logic) is
 begin
  for i in 0 to n-1 loop
   wait until (clock = '1');
   wait until (clock = '0');
  end loop;
 end procedure delay;

 procedure delay(constant n : in integer) is
 begin
  delay(n, clk);
 end procedure delay;

 procedure loadParm(constant parmIdx : in unsigned (opbx-1 downto 0);
                    signal dsel : out std_logic;
                    signal din : out std_logic;
                    signal dclk : out std_logic) is
  variable i : integer := 0;
  variable tmp : unsigned (opbx-1 downto 0);
 begin
  dsel <= '0';                          --start of load
  delay(10);

  tmp := parmIdx;
  for i in 0 to opbx-1 loop             --load parameter
   dclk <= '0';
   din <= tmp(opbx-1);
   tmp := shift_left(tmp, 1);
   delay(2);
   dclk <= '1';
   delay(6);
  end loop;
  din <= '0';
  dclk <= '0';

  delay(10);
 end procedure loadParm;

 procedure loadValue(signal value : in natural;
                     constant bits : in natural;
                     signal dsel : out std_logic;
                     signal din : out std_logic;
                     signal dclk : out std_logic) is
  variable tmp : unsigned (32-1 downto 0);
 begin
  tmp := to_unsigned(value, 32);
  for i in 0 to bits-1 loop             --load value
   dclk <= '0';
   din <= tmp(bits-1);
   delay(6);
   dclk <= '1';
   tmp := shift_left(tmp, 1);
   delay(6);
  end loop;
  din <= '0';
  dclk <= '0';

  dsel <= '1';                          --end of load
  delay(10);
 end procedure loadValue;

 procedure loadShift(variable value : in natural;
                     constant bits : in natural;
                     signal shift : out std_logic;
                     signal din : out std_logic) is
  variable tmp: unsigned(32-1 downto 0);
 begin
  tmp := to_unsigned(value, 32);
  shift <= '1';
  for i in 0 to bits-1 loop
   din <= tmp(bits - 1);
   wait until clk = '1';
   tmp := shift_left(tmp, 1);
   wait until clk = '0';
  end loop;
  shift <= '0';
 end procedure loadShift;

 procedure loadCtl(variable value : in natural;
                   constant bits : in natural;
                   signal shift : out std_logic;
                   signal din : out std_logic;
                   signal load : out std_logic) is
  variable tmp: unsigned(32-1 downto 0);
 begin
  tmp := to_unsigned(value, 32);
  shift <= '1';
  for i in 0 to bits-1 loop
   din <= tmp(bits - 1);
   wait until clk = '1';
   tmp := shift_left(tmp, 1);
   wait until clk = '0';
  end loop;
  shift <= '0';
  load <= '1';
  delay(2);
  load <= '0';
 end procedure loadCtl;

end SimProc;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

entity Nano is
 port(
  CLOCK_50 : in std_logic;

  led : out std_logic_vector(7 downto 0);
  -- SW  : in  std_logic_vector(3 downto 0);
  -- KEY : in  std_logic_vector(1 downto 0);

  -- j1_IN0, j1_IN1 : in std_logic;
  j1_0  : in  std_logic;
  j1_1  : in  std_logic;
  j1_2  : in  std_logic;
  j1_3  : in  std_logic;

  j1_4  : out std_logic;
  j1_5  : out std_logic;
  j1_6  : out std_logic;
  j1_7  : out std_logic;

  j1_8  : in  std_logic;
  j1_9  : out std_logic;
  j1_10 : in  std_logic;
  j1_11 : in  std_logic;

  j1_12 : out std_logic;
  j1_13 : in  std_logic;
  j1_14 : in  std_logic;
  j1_15 : in  std_logic;

  j1_16 : in  std_logic
  -- j1_17 : in  std_logic;
  -- j1_18 : in  std_logic;
  -- j1_19 : in  std_logic;
  -- j1_20 : in  std_logic;
  -- j1_21 : in  std_logic;
  -- j1_22 : in  std_logic;
  -- j1_23 : in  std_logic;
  -- j1_24 : in  std_logic;
  -- j1_25 : in  std_logic;
  -- j1_26 : in  std_logic;
  -- j1_27 : in  std_logic;
  -- j1_28 : in  std_logic;
  -- j1_29 : in  std_logic;
  -- j1_30 : in  std_logic;
  -- j1_31 : in  std_logic;
  -- j1_32 : in  std_logic;
  -- j1_33 : in  std_logic;

  -- j2_IN0, j2_IN1 : in  std_logic;
  -- j2_0  : in  std_logic;
  -- j2_1  : in  std_logic;
  -- j2_2  : in  std_logic;
  -- j2_3  : in  std_logic;
  -- j2_4  : in  std_logic;
  -- j2_5  : in  std_logic;
  -- j2_6  : in  std_logic;
  -- j2_7  : in  std_logic;
  -- j2_8  : in  std_logic;
  -- j2_9  : in  std_logic;
  -- j2_10 : in  std_logic;
  -- j2_11 : in  std_logic;
  -- j2_12 : in  std_logic;
  -- j2_13 : in  std_logic;
  -- j2_14 : in  std_logic;
  -- j2_15 : in  std_logic;
  -- j2_16 : in  std_logic;
  -- j2_17 : in  std_logic;
  -- j2_18 : in  std_logic;
  -- j2_19 : in  std_logic;
  -- j2_20 : in  std_logic;
  -- j2_21 : in  std_logic;
  -- j2_22 : in  std_logic;
  -- j2_23 : in  std_logic;
  -- j2_24 : in  std_logic;
  -- j2_25 : in  std_logic;
  -- j2_26 : in  std_logic;
  -- j2_27 : in  std_logic;
  -- j2_28 : in  std_logic;
  -- j2_29 : in  std_logic;
  -- j2_30 : in  std_logic;
  -- j2_31 : in  std_logic;
  -- j2_32 : in  std_logic;
  -- j2_33 : in  std_logic
  );
end Nano;

architecture Behavioral of Nano is

component Encoder is
 port(
  sysClk : in  std_logic;
  
  sw1 : in  std_logic;
  sw0 : in  std_logic;
  sw2 : in  std_logic;
  sw3 : in  std_logic;
  
  led : out std_logic_vector(7 downto 0);

  j1_p04 : out std_logic;
  j1_p06 : out std_logic;
  j1_p08 : out std_logic;
  j1_p10 : out std_logic;

  j1_p12 : in  std_logic;
  j1_p14 : out std_logic;
  j1_p16 : in  std_logic;
  j1_p18 : in  std_logic;

  jc1 : out std_logic;
  jc2 : in  std_logic;
  jc3 : in  std_logic;
  jc4 : in  std_logic;

  initialReset : in  std_logic
  );
end component;

begin

 design: Encoder
  port map (
   sysClk => CLOCK_50,

   sw0 => j1_0,
   sw1 => j1_1,
   sw2 => j1_2,
   sw3 => j1_3,

   led => led,

   j1_p04 => j1_4,
   j1_p06 => j1_5,
   j1_p08 => j1_6,
   j1_p10 => j1_7,

   j1_p12 => j1_8,
   j1_p14 => j1_9,
   j1_p16 => j1_10,
   j1_p18 => j1_11,

   jc1 => j1_12,
   jc2 => j1_13,
   jc3 => j1_14,
   jc4 => j1_15,

   initialReset => j1_16
   );

end Behavioral;

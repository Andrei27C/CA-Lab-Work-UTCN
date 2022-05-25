library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;				   

entity numarator is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end numarator;

architecture Behavioral of numarator is

    component MPG
        Port ( btn : in STD_LOGIC;
               clk : in STD_LOGIC;
               enable : out STD_LOGIC
              );
    end component MPG;
    
    component SSD
        Port ( digit_0 : in STD_LOGIC_VECTOR (3 downto 0);
               digit_1 : in STD_LOGIC_VECTOR (3 downto 0);
               digit_2 : in STD_LOGIC_VECTOR (3 downto 0);
               digit_3 : in STD_LOGIC_VECTOR (3 downto 0);
               clk : in STD_LOGIC;
               cat : out STD_LOGIC_VECTOR (6 downto 0);
               an : out STD_LOGIC_VECTOR (3 downto 0)
              );
    end component SSD;
    
    signal MPG_enable : std_logic;
    signal count : std_logic_vector(15 downto 0) := x"0000";

begin
   MPG1 : MPG port map (btn(0), clk, MPG_enable);
   SSD1 : SSD port map (count(3 downto 0), count(7 downto 4), count(11 downto 8), count(15 downto 12), clk, cat, an);
    
    process(MPG_enable)
    begin
        if rising_edge(MPG_enable) then
            count <= count + 1;
        end if;
    end process;
end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity RF is
    Port ( 
          clk : in STD_LOGIC;
          ra1 : in STD_LOGIC_VECTOR(3 downto 0);
          ra2 : in STD_LOGIC_VECTOR(3 downto 0);
          wa : in STD_LOGIC_VECTOR(3 downto 0);
          wd : in STD_LOGIC_VECTOR(15 downto 0);
          wen : in STD_LOGIC;
          rd1 : out STD_LOGIC_VECTOR(15 DOWNTO 0);
          rd2 : out STD_LOGIC_VECTOR(15 DOWNTO 0)
         );
end RF;

architecture Behavioral of RF is
    
    type memory_type is array (15 downto 0) of std_logic_vector(15 downto 0);
    signal RF : memory_type;
    
begin
    
    process(clk)
    begin
        if rising_edge(clk) then
            if wen = '1' then
                RF(conv_integer(unsigned(wa))) <= wd;
            end if;
        end if;
    end process;
    
    rd1 <= RF(conv_integer(unsigned(ra1)));
    rd2 <= RF(conv_integer(unsigned(ra2)));
    
end Behavioral;

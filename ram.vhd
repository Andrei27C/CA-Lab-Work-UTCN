library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;                                           

entity RAM is
    Port ( clk : in STD_LOGIC;
           we : in STD_LOGIC;
           en : in STD_LOGIC;
           addr : in STD_LOGIC_VECTOR (3 downto 0);
           di : in STD_LOGIC_VECTOR (15 downto 0);
           do : out STD_LOGIC_VECTOR (15 downto 0)
    );
end RAM;

architecture Behavioral of RAM is
    
    type memory_type is array (15 downto 0) of std_logic_vector(15 downto 0);
    signal RAM : memory_type;
    
begin
    
    process(clk)
    begin
        if rising_edge(clk) then
            if en = '1' then
                if we = '1' then
                    RAM(conv_integer(unsigned(addr))) <= di;
                    do <= di;
                else 
                    do <= RAM(conv_integer(unsigned(addr)));
                end if;
            end if;        
        end if;
    end process;
    
end Behavioral;

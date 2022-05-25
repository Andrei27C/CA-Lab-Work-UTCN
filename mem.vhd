library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL; -- @suppress "Deprecated package"
use IEEE.STD_LOGIC_UNSIGNED.ALL;                                            -- @suppress "Deprecated package"

entity mem is
    Port ( clk : in STD_LOGIC;
           memWrite : in STD_LOGIC;
           Address : in STD_LOGIC_VECTOR (15 downto 0);
           RD2 : in STD_LOGIC_VECTOR (15 downto 0);
           MemData : out STD_LOGIC_VECTOR (15 downto 0);
           ALURes : out STD_LOGIC_VECTOR (15 downto 0)
    );
end mem;

architecture Behavioral of mem is
    
    type memory_type is array (256 downto 0) of std_logic_vector(15 downto 0);
    signal mem : memory_type;
    
begin
    
    process(clk)
    begin
        if rising_edge(clk) then
            if memWrite = '1' then
                mem(conv_integer(unsigned(Address(7 downto 0)))) <= RD2;
                MemData <= mem(conv_integer(unsigned(Address(7 downto 0))));
            else 
                MemData <= mem(conv_integer(unsigned(Address(7 downto 0))));
            end if;    
        end if;
    end process;
    
    ALURes <= Address;
    
end Behavioral;

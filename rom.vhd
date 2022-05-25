library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
     
entity ROM is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end ROM;

architecture Behavioral of ROM is
    
    component MPG 
        Port ( 
               btn : in STD_LOGIC;
               clk : in STD_LOGIC;
               enable : out STD_LOGIC
              );
    end component MPG;
    
    component SSD 
        Port ( 
               digit_0 : in STD_LOGIC_VECTOR (3 downto 0);
               digit_1 : in STD_LOGIC_VECTOR (3 downto 0);
               digit_2 : in STD_LOGIC_VECTOR (3 downto 0);
               digit_3 : in STD_LOGIC_VECTOR (3 downto 0);
               clk : in STD_LOGIC;
               cat : out STD_LOGIC_VECTOR (6 downto 0);
               an : out STD_LOGIC_VECTOR (3 downto 0)
               );
    end component SSD;
    
    signal count : std_logic_vector(7 downto 0) := x"00";
    signal MPG_enable : std_logic;
    type mem_array is array (255 downto 0) of std_logic_vector(15 downto 0);
    signal ROM : mem_array := (
        b"000_000_000_001_0_000", -- initializem indexul
        b"001_000_100_1000110", -- numarul de iteratii: 70
        b"000_000_000_101_0_000", -- init sum = 0
        b"100_100_001_0000011", -- begin for(i<70)
        b"000_101_001_101_0_000", -- s+=i
        b"001_001_001_0000001", --i+=i
        b"111_0000000000100", -- go to line 4
        others => x"0000"
    );
    signal ROM_out : std_logic_vector(15 downto 0);
    
begin
    MPG1 : MPG port map(btn(0), clk, MPG_enable);
    SSD1 : SSD port map(ROM_out(3 downto 0), ROM_out(7 downto 4), ROM_out(11 downto 8), ROM_out(15 downto 12),clk,cat,an);
    
    process(clk)
    begin
        if rising_edge(clk) then
            if MPG_enable = '1' then
                count <= count + 1;
            end if;
        end if;
    end process;
    
    ROM_out <= ROM(conv_integer(unsigned(count)));

end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity test_env is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0)
           );
end test_env;

architecture Behavioral of test_env is

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
    
    component RAM
        Port ( clk : in STD_LOGIC;
           we : in STD_LOGIC;
           en : in STD_LOGIC;
           addr : in STD_LOGIC_VECTOR (3 downto 0);
           di : in STD_LOGIC_VECTOR (15 downto 0);
           do : out STD_LOGIC_VECTOR (15 downto 0)
    );
    end component RAM;

    component REGISTER_FILE
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
    end component REGISTER_FILE;
    
    component IFetch is
        Port ( 
           clk : in STD_LOGIC;
           branch_target_address : in STD_LOGIC_VECTOR (15 downto 0);
           jump_address : in STD_LOGIC_VECTOR (15 downto 0);
           jump_control : in STD_LOGIC;
           pc_src_control : in STD_LOGIC;
           instr : out STD_LOGIC_VECTOR (15 downto 0);
           next_instruction_address : out STD_LOGIC_VECTOR (15 downto 0));
    end component IFetch;
        
    
    signal MPG_enable : std_logic;
    signal digits : std_logic_vector(15 downto 0) := x"0000";
    
    --ROM
    type mem_array is array (255 downto 0) of std_logic_vector(15 downto 0);
    signal ROM : mem_array := (
        x"0101",
        x"0110",
        x"0000",
        x"0011",
        x"0100",
        others => x"0000"
    );
    signal ROM_out : std_logic_vector(15 downto 0);
    
    --RAM
    signal MPG1_enable : std_logic;
    signal MPG2_enable : std_logic;
    signal count : std_logic_vector(3 downto 0) := x"0";
    signal do : std_logic_vector(15 downto 0);
    
    --REG FILE
    signal sum : std_logic_vector(15 downto 0);
    signal rd1 : std_logic_vector(15 DOWNTO 0);
    signal rd2 : std_logic_vector(15 DOWNTO 0);
    
    
    
    
begin
    MPG1 : MPG port map (btn(0), clk, MPG_enable); 
    SSD1 : SSD port map (digits(3 downto 0), digits(7 downto 4), digits(11 downto 8), digits(15 downto 12), clk, cat, an); 
    
    --ROM
    process(clk)
    begin
        if rising_edge(clk) then
            if MPG_enable = '1' then
                count <= count + 1;
            end if;
        end if;
    end process;
    
    ROM_out <= ROM(conv_integer(unsigned(count)));
    
    --RAM
    MPG2 : MPG port map(btn(1), clk, MPG2_enable);
    RAM1 : RAM port map(clk, MPG2_enable, sw(0), count, digits, do);
    
    process(clk, btn(2))
    begin
        if btn(2) = '1' then -- reset
            count <= x"0";
        elsif rising_edge(clk) then
            if MPG1_enable = '1'  then
                count <= count + 1;
            end if;
        end if;  
    end process;
    
    digits <= do(13 downto 0) & "00";
    
    --REGISTER FILE
    SSD2 : SSD port map(sum(3 downto 0), sum(7 downto 4), sum(11 downto 8), sum(15 downto 12), clk, cat, an);
    RF1 : REGISTER_FILE port map(clk, count, count, count, sum, MPG2_enable, rd1, rd2);
    
    process(clk, btn(2))
    begin
        if btn(2) = '1' then -- reset
            count <= x"0";
        elsif rising_edge(clk) then
            if MPG1_enable = '1'  then
                count <= count + 1;
            end if;
        end if;  
    end process;
    
    sum <= rd1 + rd2;
    
    --ID
    
end Behavioral;

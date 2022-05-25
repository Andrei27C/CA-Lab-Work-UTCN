library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity IFetch is
    Port ( clk : in STD_LOGIC;
           branch_target_address : in STD_LOGIC_VECTOR (15 downto 0);
           jump_address : in STD_LOGIC_VECTOR (15 downto 0);
           jump_control : in STD_LOGIC;
           pc_src_control : in STD_LOGIC;
           instr : out STD_LOGIC_VECTOR (15 downto 0);
           next_instruction_address : out STD_LOGIC_VECTOR (15 downto 0));
end IFetch;

architecture Behavioral of IFetch is

    signal pc: std_logic_vector(15 downto 0);
    type memory_type is array (255 downto 0) of std_logic_vector(15 downto 0);
    signal ROM : memory_type := (
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
    process(clk)
    begin
        if rising_edge(clk) then
            if jump_control = '1' then
                pc <= jump_address;
            else
                if pc_src_control = '1' then
                    pc <= branch_target_address;
                else
                    pc <= pc + 1;
                end if;
            end if;
        end if;
    end process;
    instr <= ROM(conv_integer(unsigned(pc))); 
    next_instruction_address <= pc + 1; 
    
end Behavioral;

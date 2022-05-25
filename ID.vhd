library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL; -- @suppress "Deprecated package"
use IEEE.STD_LOGIC_UNSIGNED.ALL; -- @suppress "Deprecated package"

entity ID is
    Port ( clk : in STD_LOGIC;
           instr : in STD_LOGIC_VECTOR (15 downto 0);
           wd : in STD_LOGIC_VECTOR (15 downto 0);
           RegWrite : in STD_LOGIC;
           RegDst : in STD_LOGIC;
           ExtOp : in STD_LOGIC;
           Rd1 : out STD_LOGIC_VECTOR (15 downto 0);
           Rd2 : out STD_LOGIC_VECTOR (15 downto 0);
           Ext_imm : out STD_LOGIC_VECTOR (15 downto 0);
           func : out STD_LOGIC_VECTOR (2 downto 0);
           sa : out STD_LOGIC);
end ID;

architecture Behavioral of ID is

    signal muxOut : std_logic_vector(2 downto 0);
    type memory_type is array (7 downto 0) of std_logic_vector(15 downto 0);
    signal RF : memory_type;
    
begin
    
    process(RegDst, instr(6 downto 4), instr(9 downto 7))
    begin
        if RegDst = '1' then
            muxOut <= instr(6 downto 4);  --rd
        else
            muxOut <= instr(9 downto 7);  --rt
        end if;
    end process;
    
    process(ExtOp, instr(6 downto 0), instr(6))
    begin
        if ExtOp = '0' then
            Ext_imm <= "000000000" & instr(6 downto 0);
        else
            if instr(6) = '0' then
                Ext_imm <= "000000000" & instr(6 downto 0);
            else
                Ext_imm <= "111111111" & instr(6 downto 0);
            end if;
        end if;
    end process;
    
    process(clk)
    begin
        if rising_edge(clk) then
            if RegWrite = '1' then
                RF(conv_integer(unsigned(muxOut))) <= wd;
            end if;
        end if;
    end process;
    
    Rd1 <= RF(conv_integer(unsigned(instr(12 downto 10))));
    Rd2 <= RF(conv_integer(unsigned(instr(9 downto 7))));
    
    sa <= instr(3);
    func <= instr(2 downto 0);

end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ExecutionUnit is
    Port ( RD1 : in STD_LOGIC_VECTOR (15 downto 0);
           RD2 : in STD_LOGIC_VECTOR (15 downto 0);
           Ext_imm : in STD_LOGIC_VECTOR (15 downto 0);
           sa : in STD_LOGIC;
           func : in STD_LOGIC_VECTOR (2 downto 0);
           ALUOp : in STD_LOGIC_VECTOR (1 downto 0);
           ALUSrc : in STD_LOGIC;
           Zero : out STD_LOGIC;
           ALURes : out STD_LOGIC_VECTOR (15 downto 0));
end ExecutionUnit;

architecture Behavioral of ExecutionUnit is

    signal ALUCtrl : STD_LOGIC_VECTOR (2 downto 0);
    signal aluIn2 : STD_LOGIC_VECTOR (15 downto 0); 
    
begin

    process(ALUOp, func)
    begin
        if ALUOp = "10" then
            case func is 
                when "000" => ALUCtrl <= "000";     --add
                when "001" => ALUCtrl <= "100";     --sub
                when "101" => ALUCtrl <= "010";     --or
                when "100" => ALUCtrl <= "001";     --and
                when "110" => ALUCtrl <= "101";     --xor
            end case;
        elsif ALUOp = "11" then                  --ori
            ALUCtrl <= "010";                      --or
        elsif ALUOp = "00" then                  --addi/lw/sw
            ALUCtrl <= "000";                  --add
        elsif ALUOp = "01" then                  --beq/bne
            ALUCtrl <= "100";                      --sub
        end if;
    end process;
    
    process(RD2, Ext_imm, ALUSrc)
    begin
        if ALUSrc = '0' then
            aluIn2 <= Rd2;
        else
            aluIn2 <= Ext_imm;
        end if;
    end process;
    
    process(RD1, aluIn2, ALUCtrl)
    begin
        case ALUCtrl is 
            when "000" => ALURes <= RD1 + aluIn2;
            when "100" => ALURes <= RD1 - aluIn2;                
            when "010" => ALURes <= RD1 or aluIn2;                
            when "001" => ALURes <= RD1 and aluIn2;
            when "101" => ALURes <= RD1 xor aluIn2;
        end case;
    end process;
    
    
end Behavioral;

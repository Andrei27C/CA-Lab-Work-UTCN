library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL; -- @suppress "Deprecated package"
use IEEE.STD_LOGIC_UNSIGNED.ALL; -- @suppress "Deprecated package"

entity ControlUnit is
    Port ( opcode : in STD_LOGIC_VECTOR(2 downto 0);
           regDst : out STD_LOGIC;
           extOp : out STD_LOGIC;
           ALUsrc : out STD_LOGIC;
           branch : out STD_LOGIC;
           jump : out STD_LOGIC;
           ALUop : out STD_LOGIC_VECTOR (1 downto 0); -- 10 - tipR, 11 - ori, 00 - addi/lw/sw, 01 - beq
           memWrite : out STD_LOGIC;
           memToReg : out STD_LOGIC;
           regWrite : out STD_LOGIC);
end ControlUnit;

architecture Behavioral of ControlUnit is

begin

    process(opcode)
    begin
        case opcode is
            when "000" => regDst <= '1'; extOp <= '0'; ALUsrc <= '0'; branch <= '0'; jump <= '0'; ALUop <= "10"; memWrite <= '0'; memToReg <= '0'; regWrite <= '1';         --tip R                                  
            when "001" => regDst <= '0'; extOp <= '1'; ALUsrc <= '1'; branch <= '0'; jump <= '0'; ALUop <= "00"; memWrite <= '0'; memToReg <= '0'; regWrite <= '1';         --addi     
            when "010" => regDst <= '0'; extOp <= '1'; ALUsrc <= '1'; branch <= '0'; jump <= '0'; ALUop <= "00"; memWrite <= '0'; memToReg <= '1'; regWrite <= '1';         --lw  
            when "011" => regDst <= '0'; extOp <= '1'; ALUsrc <= '1'; branch <= '0'; jump <= '0'; ALUop <= "00"; memWrite <= '1'; memToReg <= '0'; regWrite <= '0';         --sw                     
            when "100" => regDst <= '0'; extOp <= '1'; ALUsrc <= '0'; branch <= '1'; jump <= '0'; ALUop <= "10"; memWrite <= '0'; memToReg <= '0'; regWrite <= '0';         --beq
            when "101" => regDst <= '0'; extOp <= '1'; ALUsrc <= '0'; branch <= '1'; jump <= '0'; ALUop <= "10"; memWrite <= '0'; memToReg <= '0'; regWrite <= '0';         --bne        
            when "111" => jump <= '1';                                                                        --j
            when others => jump <= '0';
        end case;
    end process;
    
    

end Behavioral;

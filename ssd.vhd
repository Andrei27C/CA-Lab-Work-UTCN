library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
																				  

entity SSD is
    Port ( digit_0 : in STD_LOGIC_VECTOR (3 downto 0);
           digit_1 : in STD_LOGIC_VECTOR (3 downto 0);
           digit_2 : in STD_LOGIC_VECTOR (3 downto 0);
           digit_3 : in STD_LOGIC_VECTOR (3 downto 0);
           clk : in STD_LOGIC;
           cat : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0));
end SSD;

architecture Behavioral of SSD is

    signal count : std_logic_vector(15 downto 0) := x"0000";
    signal out_digit : std_logic_vector(3 downto 0) := "0000";
    
begin
    
    process(clk)
    begin
        if rising_edge(clk) then
            count <= count + 1;
        end if;
    end process;

    process(count(15 downto 14), digit_0, digit_1, digit_2, digit_3)
    begin
        case count(15 downto 14) is
            when "00" => out_digit <= digit_0;
            when "01" => out_digit <= digit_1;
            when "10" => out_digit <= digit_2;
            when others => out_digit <= digit_3;
        end case;
    end process;
    
    process(count(15 downto 14))
    begin
        case count(15 downto 14) is
            when "00" => an <= "1110";
            when "01" => an <= "1101";
            when "10" => an <= "1011";
            when others => an <= "0111";
        end case;
    end process;
    
    process(out_digit)
    begin
        case out_digit is
             when "0001" => cat <=  "1111001"; 
             when "0010" => cat <=  "0100100";
             when "0011" => cat <=  "0110000";
             when "0100" => cat <=  "0011001";
             when "0101" => cat <=  "0010010"; 
             when "0110" => cat <=  "0000010";  
             when "0111" => cat <=  "1111000"; 
             when "1000" => cat <=  "0000000"; 
             when "1001" => cat <=  "0010000"; 
             when "1010" => cat <=  "0001000";  
             when "1011" => cat <=  "0000011";  
             when "1100" => cat <=  "1000110"; 
             when "1101" => cat <=  "0100001"; 
             when "1110" => cat <=  "0000110";  
             when "1111" => cat <=  "0001110"; 
             when others => cat <=  "1000000"; 
        end case;
    end process;
    
end Behavioral;

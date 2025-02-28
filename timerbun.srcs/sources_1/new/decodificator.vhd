library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity decodificator is
    port(
        nr: in integer;
        bcd: out std_logic_vector (3 downto 0));
end entity;

architecture arh of decodificator is
begin
    process(nr)
    begin
        case nr is
            when 0 => bcd<="0000";
            when 1 => bcd<="0001";
            when 2 => bcd<="0010";
            when 3 => bcd<="0011";
            when 4 => bcd<="0100";
            when 5 => bcd<="0101";
            when 6 => bcd<="0110";
            when 7 => bcd<="0111";
            when 8 => bcd<="1000";
            when 9 => bcd<="1001";
            when 10 => bcd<="1010";
            when 11 => bcd<="1011";
            when 12 => bcd<="1100";
            when 13 => bcd<="1101";
            when 14 => bcd<="1110";
            when others => bcd<="1111";
        end case;
    end process;

end arh;

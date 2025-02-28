library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity afisor is
	port(
	datain: in std_logic_vector(3 downto 0) ;
	dataout: out std_logic_vector(6 downto 0));
end entity;

architecture arh of afisor is
begin
	process(datain)
	begin
		case datain is
			when "0000" => dataout<= "1000000";
			when "0001" => dataout<= "1111001";
			when "0010" => dataout<= "0100100";
			when "0011" => dataout<= "0110000";
			when "0100" => dataout<= "0011001";	
			when "0101" => dataout<= "0010010";
			when "0110" => dataout<= "0000010";
			when "0111" => dataout<= "1111000";
			when "1000" => dataout<= "0000000";
			when "1001" => dataout<= "0010000";
			when others => dataout<= "1111111";
		end case;
	end process;
	end arh;
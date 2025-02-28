library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;


entity afisor_complet is
	port(CLK: in STD_LOGIC;
	Digit0: in STD_LOGIC_VECTOR(3 downto 0); 
	Digit1: in STD_LOGIC_VECTOR(3 downto 0);
	Digit2: in STD_LOGIC_VECTOR(3 downto 0); 
	Digit3: in STD_LOGIC_VECTOR(3 downto 0);
	CAT: out STD_LOGIC_VECTOR(6 downto 0); 
	AN: out STD_LOGIC_vector(3 downto 0)); 
end afisor_complet;

architecture afisor of afisor_complet is   

signal Counter: STD_LOGIC_VECTOR(15 downto 0):=(others => '0');
signal aux: STD_LOGIC_VECTOR(3 downto 0):=(others => '0');	 

component afisor
	port(datain: in std_logic_vector(3 downto 0);
	dataout: out std_logic_vector(6 downto 0));	
end component;	 

begin
	process(CLK)  
	begin
		if(CLK'EVENT and CLK='1') then      
			if(Counter="1111111111111111") then
				Counter<=(others => '0');
			else
				Counter<=Counter+1;
			end if;
		end if;
	end process;

	aux<=Digit0 when Counter(15 downto 14)="00" else
	Digit1 when Counter(15 downto 14)="01" else
	Digit2 when Counter(15 downto 14)="10" else
	Digit3 when Counter(15 downto 14)="11";

	AN<= "0111" when Counter(15 downto 14)="00" else
	"1011" when Counter(15 downto 14)="01" else
	"1101" when Counter(15 downto 14)="10" else
	"1110" when Counter(15 downto 14)="11";

	
	step1: afisor port map (aux, CAT);	
	
end architecture;
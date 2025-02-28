library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity numarator_min is

port (CLK: in std_logic;   -- clock
RM: in std_logic;   -- reset
ENM: in std_logic;	--enable
M: in std_logic;  -- semnal incrementare minute
UDM: in std_logic;  -- semnal numaratoare descrescator sau crescator	 	
TC_secunde: in std_logic; -- terminal count ul de la numaratorul de secunde
TC_min: out std_logic;   --terminal count minute care intra in generatorul de stare signal in numaratorul de secunde
UM: out std_logic_vector(3 downto 0);   -- unitatile transformate in binar
ZM: out std_logic_vector(3 downto 0);   -- zecile transformate in binar
MIN: out integer  	 )	;

end numarator_min;

architecture num_min of numarator_min is
	


signal unit:integer;
signal zec: integer;
signal nrmin : integer :=0;	
signal minute: integer; 
signal Term_C: std_logic :='0';	  

component decodificator 
	port(
	nr: in integer;
	bcd: out std_logic_vector (3 downto 0));
end component;

begin  
process (CLK,RM,M,ENM,UDM,TC_secunde)	
begin
	if RM='1' then -- s-a trimis semnal pentru resetarea numaratorului
		nrmin<=0;
	elsif rising_edge(CLK) then -- suntem pe frontul crescator
		if M='1' then -- se incrementeaza signal se afiseaza minutele
			if nrmin=99 then 
				nrmin<=0; -- se incrementeaza minutele dar ajung la 0
				Term_C<='1'; -- dam semnalul generatorului de stare
			else 
				nrmin<=nrmin+1;   --incrementam minutele
				Term_C<='0'; 
			end if;
		elsif ENM='0' and TC_secunde='1' then -- daca avem voie sa numaram signal s a transmis semnalul de incrementare de la secunde
			if UDM='1' then -- numaram crescator 
				if nrmin=99 then 
					nrmin<=0;  -- am ajuns la 99 signal am sarit din nou la 0
					Term_C<='1';  -- dam semnal de terminare a numaratorii
				else 
					nrmin<=nrmin+1;	 -- nu am ajuns la 99 
					Term_C<='0';  -- nu dam semnal de finalizare al numaratorii
				end if;
			else 	-- numaram descrescator 
				if nrmin=0 then 
					Term_C<='1'; -- am terminat de numarat crescator si trimitem semnal pentru a activa alarma
				elsif nrmin=1 then
					nrmin<=nrmin-1;
					Term_C<='0';
				else 
					nrmin<=nrmin-1;	 -- nu am terminat de numarat descrescator 
					Term_C<='0';
				end if;
			end if;
		end if;
	end if;
end process;

minute<=0 when (nrmin=0 and UDM='0') else 1;

unit<=nrmin mod 10; -- unitati
zec<=nrmin/10; -- zeci  

unitatilem: decodificator port map(unit,UM);	-- conversia din decimal in binar
zecilem: decodificator port map(zec,ZM);	 -- conversia din decimal in binar

MIN<=minute;
TC_min<=Term_C;


end architecture;


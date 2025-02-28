library IEEE;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.STD_LOGIC_1164.all;

entity numarator_sec is
	port(
	CLK: in std_logic;	--clock
	UD: in std_logic;  -- numaratoare descrescatoare sau crescatoare
	R: in std_logic; -- reset
	S: in std_logic;	-- semnalul pentru incrementarea secundelor
	EN: in std_logic;  -- enable
	MIN: in integer;   --semnalul minutelor pentru numararea descrescatoare
	U: out std_logic_vector(3 downto 0);  -- cifra unitatilor convertita in binar
	Z:out std_logic_vector(3 downto 0);	   --cifra zecilor convertita in binar
	TC_sec : out std_logic;	   --terminal count de la secunde ce merge in generator signal in minute
	SEC: out integer);	-- semnalul ce merge la generatorul de stare
end entity;

architecture num_sec of numarator_sec is	 

signal unit : integer;
signal zeci :integer;
signal nrsec :integer:=0;  -- aici numaram secundele 
signal secunde: integer :=1;
signal Term_C: std_logic :='0';	   

component decodificator 
	port(
	nr: in integer;
	bcd: out std_logic_vector (3 downto 0));
end component;

begin
process  (CLK, UD, R, S, EN)
begin
	if R='1'then  -- Daca reset e activ pe 1 atunci numarul o ia din nou de la 0
		nrsec<=0;
	elsif rising_edge(CLK) then 
		if S='1' then	--S e semnalul de incrementare al secundelor 
			if nrsec=59 then -- secundele au ajuns la 59 trebuie sa se schimbe din nou la 0
				nrsec<=0; --Numarul trece din nou la 0 
				Term_C<='1'; --se transmite semnalul de incrementare al minutelor
			else 
				nrsec<=nrsec+1;	-- se incrementeaza secundele
				Term_C<='0';	-- nu se da nici un semnal la minute
			end if;
		elsif EN='0' then  -- daca enable e activ pe 0 atunci putem sa numaram
			if UD='1' then --atunci trebuie sa numaram crescator
				if nrsec=59 then
					nrsec<=0;  -- numarul trece din nou la 0
					Term_C<='0';   --nu se da aici semnal la minute deoarece exista o intarziere cauzata de process
				elsif nrsec=58 then
					nrsec<=nrsec+1;	-- dorim sa ajungem totusi la 59
					Term_C<='1'; -- aici se da semnalul pentru minute
				else nrsec<=nrsec+1;
					Term_C<='0';  
				end if;
			else -- inseamna case UD=0 deci se variable numara descrescator
				if nrsec=0	 then 	  -- daca secundele au ajuns la o
					if 	MIN=1 then -- daca am primit semnalul case minutele nu au ajuns inca la 0
						nrsec<=59; -- secundele incep din nou sa numere descrescator de la 59
					end if;
					Term_C<='0'; -- nu dam semnal minutelor sa se decrementeze
				elsif nrsec=1 then 	--aici verificam intarzierea cauzata de process
					nrsec<=nrsec-1;
					Term_C<='1'; -- aici dam semnalul de decrementare al minutelor
				else 
					nrsec<=nrsec-1;
					Term_C<='0'; --continuam scaderea secundelor
				end if;
			end if;
		end if;
	end if;
end process;
	
	
	unit<=nrsec mod 10; -- unitati
	zeci<=nrsec/10; -- zeci  
	
	unitatile: decodificator port map(unit,U);	-- conversia din decimal in binar
	zecile: decodificator port map(zeci,Z);	 -- conversia din decimal in binar
	
	secunde<=0 when (nrsec=0 and UD='0') else 1; -- aici transmitem semnalul ca secundele au ajuns la 0 prin numarare descrescatoare signal avem nevoie de alarma
    SEC<=secunde;
	TC_sec<=Term_C;
	
end num_sec;
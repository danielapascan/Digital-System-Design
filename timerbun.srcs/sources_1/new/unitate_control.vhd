library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity unitate_de_control is
port(
M: in std_logic;   --butonul de pe placuta
reset_clk: in std_logic; --butonul de pe placuta
S: in std_logic; --butonul de pe placuta
MIN: in integer;
SEC: in integer;
TC_min: in std_logic;
TC_sec: in std_logic;
CLK: in std_logic;
SS: in std_logic; --butonul de pe placuta
minute_semn: out std_logic;
secunde_semn: out std_logic;
resetc: out std_logic;
updown: out std_logic;
semnal_vizual: out std_logic; --led
ENABLE_OUT: out std_logic);
end entity;

architecture Behavioral of unitate_de_control is 

component div_frec 
	port(clk_100:in std_logic;
	clk_1hz: out std_logic;
	reset:in std_logic);
end component;	   

component debouncer 
port( DATAIN: in std_logic;
CLK: in std_logic;
DATAOUT: out std_logic);
end component;

--butoanele 
signal minute: std_logic;
signal secunde: std_logic;
signal StartStop: std_logic;

--semnale intermediare
signal UD: std_logic:='1';
signal clk_out: std_logic;
signal enable: std_logic;


type stare is (S0,S1,S2,S3,S4,S5);
signal st:stare:=S0; --initializam starea cu starea 0
begin

--aici trecem butoanele prin stabilizator
step1: debouncer port map(M, CLK, minute);
step2: debouncer port map(S,CLK, secunde);
step3: debouncer port map(SS,CLK,StartStop); 
step5: div_frec port map(CLK,clk_out,reset_clk);  

 
process(clk_out)
begin
if rising_edge(clk_out) then 
if (minute='1' and secunde='1') or (TC_sec='1' and TC_min='1' and UD='1') then
   st<=S0; 
else 
   case st is
   when S0 => if StartStop='1' then
            st<=S1;
            elsif (minute='1' or secunde='1') then 
            st<=S3; 
            end if;
   when S1 => if StartStop='1' then 
            st<= S2;
            elsif (minute='1' or secunde='1') then 
            st<=S3; 
            end if;
   when S2 => if StartStop='1' then 
            st<=S1; 
            elsif (minute='1' or secunde='1') then
            st<=S3; 
            end if;
   when S3=> if StartStop='1' then 
            st<=S4; 
            end if;
   when S4 => if minute='1' or secunde='1' then 
	          st<=S3;
              elsif MIN=0 and SEC=0 then
	          st<=S5;
              end if;
  when others =>  st<=S5;  
        
 end case; 
 end if;
 end if;
end process;

process(st)
begin
	case st is
		when S0 => enable<='1';
		           semnal_vizual<='0';
		when S1 => UD<='1';
		           enable<='0';
		           semnal_vizual<='0';
		when S2=> enable<='1';
		          semnal_vizual<='0';
		when S3=> enable<= '1';
		          semnal_vizual<='0';
		when S4=> UD<='0';
		          enable<='0';
		          semnal_vizual<='0';
		when others => enable<='1';
		               semnal_vizual<='1';
	end case;  
end process;   


resetc<=minute and secunde;
updown<=UD;
minute_semn<= minute when st=S3 else '0';
secunde_semn<= secunde when st=S3 else '0';
ENABLE_OUT<=not enable when ((st=S1 or st=S2) and StartStop='1') or ((st=S1 or st=S4) and minute='1') or ((st=S1 or st=S4)and secunde='1') else enable;

end Behavioral;

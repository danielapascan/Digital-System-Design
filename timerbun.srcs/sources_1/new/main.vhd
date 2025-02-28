library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;


entity main is
port(
    clk: in std_logic;
    btn: in std_logic_vector(4 downto 0);
    sw: in std_logic_vector(15 downto 0);
    led: out std_logic_vector(15 downto 0);
    cat: out STD_LOGIC_VECTOR(6 downto 0);
	an: out STD_LOGIC_VECTOR(3 downto 0));
end entity;

architecture arh1 of main is


component unitate_de_control 
port(
M: in std_logic; 
reset_clk: in std_logic;
S: in std_logic;
MIN: in integer;
SEC: in integer;
TC_min: in std_logic;
TC_sec: in std_logic;
CLK: in std_logic;
SS: in std_logic;
minute_semn: out std_logic;
secunde_semn: out std_logic;
resetc: out std_logic;
updown: out std_logic;
semnal_vizual: out std_logic;
ENABLE_OUT: out std_logic);
end component;

component numarator_sec 
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
end component;


component numarator_min 

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

end component;

component afisor_complet 
	port(CLK: in STD_LOGIC;
	Digit0: in STD_LOGIC_VECTOR(3 downto 0); 
	Digit1: in STD_LOGIC_VECTOR(3 downto 0); 
	Digit2: in STD_LOGIC_VECTOR(3 downto 0); 
	Digit3: in STD_LOGIC_VECTOR(3 downto 0);
	CAT: out STD_LOGIC_VECTOR(6 downto 0); 
	AN: out STD_LOGIC_vector(3 downto 0));
end component;

component div_frec 
	port(clk_100:in std_logic;
	clk_1hz: out std_logic;
	reset:in std_logic);
end component;	 


signal clk_div:std_logic;
signal updown_out: std_logic;--iesirea din unitate cu numele de updown
signal reset_out: std_logic:='0';--iesire din unitate cu numele de reset
signal secunde_semn_out: std_logic; --iesire din unitate cu numele secunde_semn
signal ENABLE_OUT2: std_logic;--iesire din unitate cu numele ENABLE_OUT
signal unitati_sec: std_logic_vector(3 downto 0); --intrare in afisor
signal zeci_sec: std_logic_vector(3 downto 0); -- intrare in afisor	
signal term_sec: std_logic; -- intrare in unitate
signal sec_alarma: integer; -- intrare in unitate	
signal minute_semn_out: std_logic; --iesirea din unitate cu numele minute_semn 
signal term_min: std_logic; --intrare in unitate
signal unitati_min: std_logic_vector(3 downto 0); --intrare in afisor
signal zeci_min: std_logic_vector(3 downto 0); --intrare in afisor 
signal min_alarma:integer; --intrare in unitate	  

begin 
	
	step1: div_frec port map(
	clk_100=>clk,
	clk_1hz=>clk_div,
	reset=>btn(0));  
	
	step2: numarator_sec port map (
	CLK=>clk_div,
	UD=> updown_out,
	R=> reset_out,
	S=> secunde_semn_out,
	EN=> ENABLE_OUT2,
	MIN=> min_alarma,
	U=>unitati_sec,
	Z=>zeci_sec,
	TC_sec=>term_sec, 
	SEC=>sec_alarma);
	
	step3: numarator_min port map (
	CLK=> clk_div,
	RM=> reset_out, 
	ENM=> ENABLE_OUT2, 
	M=> minute_semn_out,
	UDM=>updown_out,
	TC_secunde=>term_sec, 
	TC_min=> term_min, 
	UM=> unitati_min, 
	ZM=> zeci_min,
	MIN=> min_alarma);
	
	step4: unitate_de_control port map(
	M=>btn(1),
	reset_clk=>btn(0),
	S=>btn(2),
	MIN=>min_alarma, 
	SEC=> sec_alarma, 
	TC_min=> term_min,
	TC_sec=> term_sec,
	CLK=>clk, 
	SS=>btn(3), 
	minute_semn=> minute_semn_out,
	secunde_semn=>secunde_semn_out,
	resetc=> reset_out, 
	updown=>updown_out,
	semnal_vizual=>led(0),
	ENABLE_OUT=>ENABLE_OUT2);
	
	step5: afisor_complet port map(
	CLK=> clk,
	Digit0=> zeci_min,
	Digit1=> unitati_min,
	Digit2=> zeci_sec, 
	Digit3=> unitati_sec,
	CAT=>cat, 
	AN=>an);

end architecture;

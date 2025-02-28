library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.all;
 
entity debouncer is
    port (
DATAIN: in std_logic;
CLK : in std_logic;
DATAOUT : out std_logic);
end entity ;
 
architecture deb of debouncer is
signal S1,S2,S3: std_logic;
signal counter: std_logic_vector(15 downto 0);
begin
  process(CLK) 
  begin 
	  if rising_edge(CLK) then
	  if counter="1111111111111111" then 
		  S1<=DATAIN;
	  end if;
		  S2<=S1;
		  S3<=S2;
		  counter<=counter+1;
	  end if;
  end process;
 
DATAOUT<=not(S3) and S2;
-- DATAOUT<=S1 AND S2 AND S3;
end architecture;
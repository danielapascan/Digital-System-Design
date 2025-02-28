library IEEE;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.STD_LOGIC_1164.all;

entity div_frec is
	port(clk_100:in std_logic;
	clk_1hz: out std_logic;
	reset:in std_logic);
end entity;		

architecture comportamnetala of div_frec is
signal temp :std_logic;
signal num : integer range 0 to 50_000_000:=1;
begin
	divizor: process (reset, clk_100) begin
        if reset = '1' then
            temp <= '0';
            num <= 1;
        elsif rising_edge(clk_100) then
            if num = 50_000_000 then
                temp <= not temp;
                num <= 1;
            else
                num <= num + 1;
            end if;
        end if;
    end process divizor;
    
    clk_1hz <= temp;
end architecture;
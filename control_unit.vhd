library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity control_unit is
	port (clk, cond1, cond2, cond3, cond4: in std_logic;
		  start, writeInit, writePos, writeY, writeX, writeCh, writeConv: out std_logic:='0');
end control_unit;

architecture Behaviour of control_unit is



type states is (idle, init, incrementpos, incrementy, incrementx, incrementch, convolution);
signal state : states;

begin
	process(clk)
	begin
		if clk='1' and clk'event then
			case state is
				
				when idle => state <= init;
				when init =>  state <= convolution;
				when convolution => if cond1='0' then state <= incrementpos;
				elsif cond1='1' and cond2='0' then state <= incrementy;
				elsif cond1='1' and cond2='1' and cond3='0' then state <= incrementx;	
				elsif cond1='1' and cond2='1' and cond3='1' and cond4='0' then state <= incrementch; 
				elsif cond1='1' and cond2='1' and cond3='1' and cond4='1' then state <= idle;
				end if;	 
				
				when others => state <= convolution; 
				
			end case;
		end if;
	end process;  
	
	-- Funzione d'uscita --
	start <= '1' when state = idle else '0';
	writeInit <= '1' when state = init else '0';
	writePos <= '1' when state = incrementpos else '0';
	writeY <= '1' when state = incrementy else '0';
	writeX <= '1' when state = incrementx else '0';
	writeCh<= '1' when state = incrementch else '0';
	writeConv <= '1' when state = convolution else '0';
	
end Behaviour;



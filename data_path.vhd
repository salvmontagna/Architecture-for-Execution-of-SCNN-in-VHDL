library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity data_path is
    port (
        q_image: in std_logic_vector(8 downto 0); --Image bit string
        q_weight: in std_logic_vector(13 downto 0); --Weights bit string
        clk, WriteCh, WriteX, WriteY, WriteConv, WriteInit, WritePos: in std_logic;
		cond1, cond2, cond3, cond4: out std_logic:='0';
		re,rew: out std_logic:='0'; --Enabling signals for data reading in the images and weights memory
		rdaddress: out std_logic_vector(8 downto 0):="000000000"; -- In the case of 16x16 image -> 9 BIT -> 1 for the channel 4 for row and 4 for column -> 256 seq
		rdaddressw: out std_logic_vector(2 downto 0):="000"; -- 3 BITs per row
        conv: out std_logic_vector(8 downto 0):="000000000"
    );
end data_path;


architecture Behaviour of data_path is

	--Declaration of constants
	constant ChNum: integer := 2;
	constant OXImgSize: integer := 14;
    constant OYImgSize: integer := 14;
	--Signals for convolution indices
    signal first: integer:=0;
    signal pos: integer range 0 to 7:=0;
    signal x: integer range 0 to 14:=0;
    signal y: integer range 0 to 14:=0;
    signal ch: integer range 0 to 2:=0;
	signal current_image: std_logic_vector (7 downto 0):=X"00";
	signal current_weight: std_logic_vector (7 downto 0):=X"00";
	signal current_x: integer:=0;
	signal current_y: integer:=0;
	--signal current_y: std_logic_vector (2 downto 0);
	signal imgCh: integer:=0;

begin
    process (clk)
	--variable convolution: std_logic_vector (16 downto 0);
	variable convolution: integer:=0;
    begin

			--Check all the conditions to pass to the control unit and have the right state transitions
			--In particular, cond1...cond4 remain at 0 until the condition is satisfied
			--If the condition is satisfied, the index has reached its maximum value and cond1...cond4=1
			
			--Check if pos has not reached its maximum value
			if (pos < first + 2) then
				cond1 <= '0';
			else
				cond1 <= '1';
			end if;	
			--Check if y has not reached its maximum value
			if (y < OYImgSize) then
				cond2 <= '0';
			else
				cond2 <= '1';
			end if;
			
			--Check if x has not reached its maximum value
			 if (x < OXImgSize) then
			 	cond3 <= '0';
			 else
				cond3 <= '1';
			 end if;
			 
			 --Check if x has not reached its maximum value
			 if (x < OXImgSize) then
			 	cond3 <= '0';
			 else
				cond3 <= '1';
			 end if;
			 
			 --Check if ch has not reached its maximum value
			 if ( ch < ChNum) then
			 	cond4 <= '0';
			 else
				cond4 <= '1';
			 end if;
			 
    	if (clk'event and clk = '1') then			 
			--I send the current position to take the weight value other than 0. Considering that the range varies from 0 to 5, I use 3 bits for the address
			--(000,001,010,011,100) -> positions (0,1,2,3,4) -> weights (3,2,7,6,4,5) 
			rdaddressw <= std_logic_vector(to_unsigned(pos,3));
			
			--The first 6 bits I convert them into int to be able to do the sum with the indices x,y
			--I take the first 3 bits for the x coordinate of the weight and convert them to INT
			current_x <= to_integer(signed(q_weight(2 downto 0)));
			--Take the next 3 bits for the y coordinate of the weight and convert them to INT
			current_y <= to_integer(signed(q_weight(5 downto 3)));	
			--I keep the current value obtained by exchanging the address with the weight memory
			current_weight <= q_weight(13 downto 6);
			 
			--I use the ch signals, assuming we have two images, x,y (the indices) to generate the memory address using the operator
			--of concatenation "&" and then send the generated address to memory.
			
			rdaddress <=  std_logic_vector(to_unsigned(ch,1)) & std_logic_vector(to_unsigned(x+current_x,4)) &  std_logic_vector(to_unsigned(y+current_y,4));
			
			--Keep the current value obtained by exchanging the address with the image memory
			current_image <= q_image(8 downto 1);
			imgCh <= to_integer(signed(q_image(1 downto 0))); --Questo è il canale in cui si trova l'immagine
				
			
			-- State for initialization of all variables
			if (writeInit = '1') then
				first <= 0;
				x <= 0;
				y <= 0;
				ch <= 0;
				pos <= first;
			
			--Check if writeConv signal is 1, then check if all variables have not reached yet
			--the maximum of their size, since it means that the convolution is not finished yet
			elsif WriteConv = '1' then
				--I authorize the reading of images in memory
				re <= '1';
				--I authorize the reading of weights in memory 
				rew <= '1';				
				--Built the addresses and taken the corresponding values (which I convert to int), I can perform the convolution		
				convolution := convolution + (to_integer(signed(current_weight)) * to_integer(signed(current_image)));
				--Convolute out by converting back to std_logic
				conv <= std_logic_vector(to_unsigned(convolution,9));
			
			--Check if writePos signal is 1, then check if pos hasn't reached its size yet and increment it
			elsif WritePos = '1' then
				pos <= pos + 1;
			
			--Check if writeY signal is 1, then check if y hasn't reached its size yet and increment it
            elsif WriteY = '1' then
                y <= y + 1;
					 
			
			--Check if the writeX signal is 1, then check if x hasn't reached its size yet and increment it
            elsif WriteX = '1' then
                x <= x + 1;
			
			--Controllo se il segnale writeCh è 1, quindi controllo se ch non ha ancora raggiunto la sua dimensione e lo incremento
			elsif WriteCh = '1' then
               ch <= ch + 1;
					 y<=0;
					 x<=0;
					 pos<=first;
					 first <= first + 3;
--			else		
--				first <= first + ChannelSize(ch);
--				first <= first + 3;
--				pos <= first;
            end if;
        end if;
    end process;
	
end Behaviour;


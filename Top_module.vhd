library ieee;
use ieee.std_logic_1164.all;

entity Top_module is
	port (clk,we,wew: in std_logic;
			wraddress: in std_logic_vector(8 downto 0);
			wraddressw: in std_logic_vector(2 downto 0);
			dataw: in std_logic_vector(13 downto 0);
			data_image: in std_logic_vector(8 downto 0);
		  conv: out std_logic_vector(8 downto 0));
end Top_module;

architecture Behaviour of Top_module is

--Declaration of all project components: datapath, control unit and the two memories.

component control_unit is
	port (clk, cond1, cond2, cond3, cond4: in std_logic;
		  start, writeInit, writePos, writeY, writeX, writeCh, writeConv: out std_logic);
end component;

component data_path is
    port (
        q_image: in std_logic_vector(8 downto 0); --Image bit string
        q_weight: in std_logic_vector(13 downto 0); --Weights bit string
        clk, WriteCh, WriteX, WriteY, WriteConv, WriteInit, WritePos: in std_logic;
		cond1, cond2, cond3, cond4: out std_logic;
		re,rew: out std_logic; --Enabling signals for data reading in the images and weights memory
		rdaddress: out std_logic_vector(8 downto 0); -- In the case of 16x16 image -> 9 BIT -> 1 for the channel 4 for row and 4 for column -> 256 seq
		rdaddressw: out std_logic_vector(2 downto 0); -- 3 BITs per row
        conv: out std_logic_vector(8 downto 0)
    );
end component;

	component imageMemory is
		generic (
			ADDR_WIDTH     : integer := 9;        
			--DATA_WIDTH     : integer := 16;
			--Lunghezza della sequenza di BIT
			DATA_WIDTH     : integer := 9; --The first one for the word, the other 8 for the value (4 row bits, 4 column bits)
			--Number of lines of sequences
			IMAGE_SIZE  : integer := 255; --16x16
			IMAGE_FILE_NAME : string :="image.txt"
		);
		port(
		clock: in STD_LOGIC;
			data: in std_logic_vector ((DATA_WIDTH-1) downto 0);
			rdaddress: in STD_logic_vector((ADDR_WIDTH-1) downto 0);
			wraddress: in STD_logic_vector((ADDR_WIDTH-1) downto 0);
			we: in STD_LOGIC;
			re: in STD_LOGIC;
			q_image: out std_logic_vector ((DATA_WIDTH-1) downto 0));
	end component;
	
	component weightsMemory is
		generic (
			ADDR_WIDTH     : integer := 3;        
			--Length of the BIT sequence
			--(00000000000011,00000000000010,00000000000111,00000000000110, 00000000000100,00000000000101)
			--in integer After first 6 bits (3,2,7,6,4,5)
			--Sequence length 14 BIT: The first 6 bits are reserved for the x,y coordinates of the filter and are integers ranging from 0 to 2
			DATA_WIDTH     : integer := 14;
			--Nuero di righe di sequenze 6 -1 = 5 
			WEIGHT_SIZE  : integer := 5; -- Weights other than 0
			WEIGHT_FILE_NAME : string :="weights.txt"
		);
		port(
			clock: in STD_LOGIC;
			data: in std_logic_vector ((DATA_WIDTH-1) downto 0);
			rdaddressw: in STD_logic_vector((ADDR_WIDTH-1) downto 0);
			wraddressw: in STD_logic_vector((ADDR_WIDTH-1) downto 0);
			wew: in STD_LOGIC; -- the w stands for differentiating the writing mode of the image from that of the weight w(weight)
			rew: in STD_LOGIC;
			q_weight: out std_logic_vector (13 downto 0));
	end component;

signal re,rew : std_logic := '0';
signal cond1, cond2, cond3, cond4 : std_logic := '0';
signal start, writeInit, writePos, writeY, writeX, writeCh, writeConv : std_logic := '0';
signal rdaddress: std_logic_vector(8 downto 0);
signal rdaddressw: std_logic_vector(2 downto 0);
signal q_image: std_logic_vector(8 downto 0);
signal q_weight: std_logic_vector(13 downto 0);

begin

CNTRL_UNIT : control_unit
	port map (
		clk => clk,
		cond1 => cond1,
		cond2 => cond2,
		cond3 => cond3,
		cond4 => cond4,
		start => start,
		writeInit => writeInit,
		writePos => writePos,
		writeY => writeY,
		writeX => writeX,
		writeCh => writeCh,
		writeConv => writeConv
	);

	
data_path_comp : data_path
	port map (
		q_image => q_image,
		q_weight => q_weight,
		clk => clk,
		WriteCh => WriteCh,
		WriteX => WriteX,
		WriteY => WriteY,
		WriteConv => WriteConv,
		WriteInit => WriteInit,
		WritePos => WritePos,
		cond1 => cond1,
		cond2 => cond2,
		cond3 => cond3,
		cond4 => cond4,
		re => re,
		rew => rew,
		rdaddress => rdaddress,
		rdaddressw => rdaddressw,
		conv => conv
	);

   Weight_UNIT: weightsMemory PORT MAP (
          clock => clk,
          data => dataw,
          rdaddressw => rdaddressw,
          wraddressw => wraddressw,
          wew => wew,
          rew => rew,
          q_weight => q_weight
        );

   IMAGE_UNIT: imageMemory PORT MAP (
          clock => clk,
          data => data_image,
          rdaddress => rdaddress,
          wraddress => wraddress,
          we => we,
          re => re,
          q_image => q_image
        );


end Behaviour;

library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
use std.textio.all;

entity weightsMemory is
  generic (
    ADDR_WIDTH     : integer := 3;  
  --Length of the BIT sequence
  --(00000000000011,000000000000010,00000000000111,00000000000110, 00000000000100,00000000000101)
  --in integer After first 6 bits (3,2,7,6,4,5)
  --Sequence length 14 BIT: The first 6 bits are reserved for the x,y coordinates of the filter and are integers ranging from 0 to 2
	DATA_WIDTH     : integer := 14;
	--Number of lines of sequences 6 -1 = 5
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
    q_weight: out std_logic_vector (13 downto 0):="00000000000000");
end weightsMemory;

architecture behavioral of weightsMemory is

type mem_type is array (0 to WEIGHT_SIZE) of std_logic_vector((DATA_WIDTH-1) downto 0); 

--Function to open the weight file and initialize the memory array with the data from the file
impure function init_mem(weight_name : in string) return mem_type is
    file weight : text open read_mode is weight_name;
    variable line : line;
    variable temp_bv : bit_vector(DATA_WIDTH-1 downto 0);
    variable temp_mem : mem_type;
	begin
	    for i in mem_type'range loop
	        readline(weight, line);
	        read(line, temp_bv);
	        temp_mem(i) := to_stdlogicvector(temp_bv);
	    end loop;
	return temp_mem;
end function;
-- End of function

signal ram_block: mem_type := init_mem(WEIGHT_FILE_NAME);
signal read_address_reg: std_logic_vector((ADDR_WIDTH-1) downto 0) := (others=>'0');
  
begin
  process (clock)
  begin
   if (rising_edge(clock)) then
	  --If we are in reading mode
      if (wew = '1' and wraddressw<"110") then
        ram_block(to_integer(unsigned(wraddressw))) <= data;
      end if;
	  --If we are in write mode
      if (rew = '1' and rdaddressw<"110") then
		--On output to q_weight I give it the value loaded in memory at the current address (rdaddressw)
        q_weight <= ram_block(to_integer(unsigned(rdaddressw)));
      end if;
    end if;
  end process;

end behavioral;


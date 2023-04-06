library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity imageMemory is
  generic (
    ADDR_WIDTH     : integer := 9;        
	  --Length of the BIT sequence
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
    q_image: out std_logic_vector ((DATA_WIDTH-1) downto 0):="000000000");
end imageMemory;

architecture behavioral of imageMemory is

type mem_type is array (0 to IMAGE_SIZE) of std_logic_vector((DATA_WIDTH-1) downto 0);

--Function to open the image file and initialize the memory array with the data from the file
impure function init_mem(image_name : in string) return mem_type is
    file image : text open read_mode is image_name;
    variable line : line;
    variable temp_bv : bit_vector(DATA_WIDTH-1 downto 0);
    variable temp_mem : mem_type;
	begin
	    for i in mem_type'range loop
	        readline(image, line);
	        read(line, temp_bv);
	        temp_mem(i) := to_stdlogicvector(temp_bv);
	    end loop;
	return temp_mem;
end function;
-- End of function

signal ram_block: mem_type := init_mem(IMAGE_FILE_NAME);
signal read_address_reg: std_logic_vector((ADDR_WIDTH-1) downto 0) := (others=>'0');
  
begin
  process (clock)
  begin
   if (rising_edge(clock)) then
	  --If we are in write mode
      if (we = '1' and wraddress<="011111111") then
        ram_block(to_integer(unsigned(wraddress))) <= data;
      end if;
	  --If we are in reading mode
      if (re = '1' and rdaddress<="011111111")  then
		--On output to q_weight I give it the value loaded in memory at the current address (rdaddress)
        q_image <= ram_block(to_integer(unsigned(rdaddress)));
      end if;
    end if;
  end process;

end behavioral;


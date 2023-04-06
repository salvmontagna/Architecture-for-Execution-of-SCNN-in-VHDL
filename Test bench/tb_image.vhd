LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

ENTITY tb_read_image_vhdl IS
END tb_read_image_vhdl;
ARCHITECTURE behavior1 OF tb_read_image_vhdl IS 
    COMPONENT imageMemory
    PORT(
         clock : IN  std_logic;
         data : IN  std_logic_vector(7 downto 0);
         rdaddress : IN  std_logic_vector(8 downto 0);
         wraddress : IN  std_logic_vector(8 downto 0);
         we : IN  std_logic;
         re : IN  std_logic;
         q_image : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
   --Input
   signal clock : std_logic := '0';
   signal data : std_logic_vector(7 downto 0) := (others => '0');
   signal rdaddress : std_logic_vector(8 downto 0) := (others => '0');
   signal wraddress : std_logic_vector(8 downto 0) := (others => '0');
   signal we : std_logic := '0';
   signal re : std_logic := '0';
  --Output
   signal q_image : std_logic_vector(7 downto 0);

   -- Definisco il clock
   constant clock_period : time := 10 ns;
   signal i: integer;
BEGIN
 -- Viene letta l'immagine
   uut: imageMemory PORT MAP (
          clock => clock,
          data => data,
          rdaddress => rdaddress,
          wraddress => wraddress,
          we => we,
          re => re,
          q_image => q_image
        );

   -- I define the clock
   clock_process :process
   begin
  clock <= '0';
  wait for clock_period/2;
  clock <= '1';
  wait for clock_period/2;
   end process;
   -- Stimulus 
   stim_proc: process
   begin  
  data <= "00000000";
  rdaddress <= "000000000";
  wraddress <= "000000000";
  we <= '0';
  re <= '0';
  wait for 100 ns;
  re <= '1';  
  for i in 0 to 15 loop
  rdaddress <= std_logic_vector(to_unsigned(i, 9));
  wait for 20 ns;
  end loop;
      wait;
   end process;

END behavior1;
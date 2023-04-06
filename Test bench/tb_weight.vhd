LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

ENTITY tb_read_vhdl IS
END tb_read_vhdl;
ARCHITECTURE behavior OF tb_read_image_vhdl IS 
    COMPONENT weightsMemory
    PORT(
         clock : IN  std_logic;
         data : IN  std_logic_vector(13 downto 0);
         rdaddressw : IN  std_logic_vector(2 downto 0);
         wraddressw : IN  std_logic_vector(2 downto 0);
         wew : IN  std_logic;
         rew : IN  std_logic;
         q_weight : OUT  std_logic_vector(13 downto 0)
        );
    END COMPONENT;
   --Input
   signal clock : std_logic := '0';
   signal data : std_logic_vector(13 downto 0) := (others => '0');
   signal rdaddressw : std_logic_vector(2 downto 0) := (others => '0');
   signal wraddressw : std_logic_vector(2 downto 0) := (others => '0');
   signal wew : std_logic := '0';
   signal rew : std_logic := '0';
  --Output
   signal q_weight : std_logic_vector(13 downto 0);

   -- Definisco il clock
   constant clock_period : time := 10 ns;
   signal i: integer;
BEGIN

   uut: weightsMemory PORT MAP (
          clock => clock,
          data => data,
          rdaddressw => rdaddressw,
          wraddressw => wraddressw,
          wew => wew,
          rew => rew,
          q_weight => q_weight
        );

   -- Clock
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
  data <= "00000000000000";
  rdaddressw <= "000";
  wraddressw <= "000";
  wew <= '0';
  rew <= '0';
  wait for 100 ns;
  rew <= '1';  
  for i in 0 to 15 loop
  rdaddressw <= std_logic_vector(to_unsigned(i, 3));
  wait for 20 ns;
  end loop;
      wait;
   end process;

END behavior;
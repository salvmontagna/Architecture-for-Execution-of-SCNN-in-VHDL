LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY Testbench_top IS
END Testbench_top;
 
ARCHITECTURE behavior OF Testbench_top IS 
 
    -- Unit Under Test (UUT) component declaration
 
    COMPONENT Top_module
    PORT(
         clk : IN  std_logic;
         we : IN  std_logic;
         wew : IN  std_logic;
         wraddress : IN  std_logic_vector(8 downto 0);
         wraddressw : IN  std_logic_vector(2 downto 0);
         dataw : IN  std_logic_vector(13 downto 0);
         data_image : IN  std_logic_vector(8 downto 0);
         conv : OUT  std_logic_vector(8 downto 0)
        );
    END COMPONENT;
    

   --Input
   signal clk : std_logic := '0';
   signal we : std_logic := '0';
   signal wew : std_logic := '0';
   signal wraddress : std_logic_vector(8 downto 0) := (others => '0');
   signal wraddressw : std_logic_vector(2 downto 0) := (others => '0');
   signal dataw : std_logic_vector(13 downto 0) := (others => '0');
   signal data_image : std_logic_vector(8 downto 0) := (others => '0');

 	--Output
   signal conv : std_logic_vector(8 downto 0);

   -- Definizione del periodo di clock
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiation of the Unit Under Test (UUT)
   uut: Top_module PORT MAP (
          clk => clk,
          we => we,
          wew => wew,
          wraddress => wraddress,
          wraddressw => wraddressw,
          dataw => dataw,
          data_image => data_image,
          conv => conv
        );

   -- Definition of clock processes
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus 
   stim_proc: process
   begin		
      -- 
      wait for 100 ns;	

      wait for clk_period*10;


      wait;
   end process;

END;

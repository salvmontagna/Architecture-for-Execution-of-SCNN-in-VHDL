LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

 
ENTITY tb_datapath IS
END tb_datapath;
 
ARCHITECTURE behavior OF tb_datapath IS 
 
    -- Unit Under Test (UUT) component declaration
 
    COMPONENT data_path
    PORT(
         q_image : IN  std_logic_vector(8 downto 0);
         q_weight : IN  std_logic_vector(13 downto 0);
         clk : IN  std_logic;
         WriteCh : IN  std_logic;
         WriteX : IN  std_logic;
         WriteY : IN  std_logic;
         WriteConv : IN  std_logic;
         WriteInit : IN  std_logic;
         WritePos : IN  std_logic;
         cond1 : OUT  std_logic;
         cond2 : OUT  std_logic;
         cond3 : OUT  std_logic;
         cond4 : OUT  std_logic;
         re : OUT  std_logic;
         rew : OUT  std_logic;
         rdaddress : OUT  std_logic_vector(8 downto 0);
         rdaddressw : OUT  std_logic_vector(2 downto 0);
         conv : OUT  std_logic_vector(8 downto 0)
        );
    END COMPONENT;
    

   --Input
   signal q_image : std_logic_vector(8 downto 0) := (others => '0');
   signal q_weight : std_logic_vector(13 downto 0) := (others => '0');
   signal clk : std_logic := '0';
   signal WriteCh : std_logic := '0';
   signal WriteX : std_logic := '0';
   signal WriteY : std_logic := '0';
   signal WriteConv : std_logic := '0';
   signal WriteInit : std_logic := '0';
   signal WritePos : std_logic := '0';

 	--Output
   signal cond1 : std_logic;
   signal cond2 : std_logic;
   signal cond3 : std_logic;
   signal cond4 : std_logic;
   signal re : std_logic;
   signal rew : std_logic;
   signal rdaddress : std_logic_vector(8 downto 0);
   signal rdaddressw : std_logic_vector(2 downto 0);
   signal conv : std_logic_vector(8 downto 0);

   -- Definizione del periodo di clock
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiation of the Unit Under Test (UUT)
   uut: data_path PORT MAP (
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

   -- Clock
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
WritePos<='1';
wait for clk_period*1000;
WritePos<='0';
WriteX<='1';
wait for clk_period*1000;
WriteY<='1';
WriteX<='0';
wait for clk_period*1000;
WriteY<='0';
Writech<='1';
wait for clk_period*1000;
WriteY<='0';
Writech<='0';

      wait;
   end process;

END;

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY tb_cntrl IS
END tb_cntrl;
 
ARCHITECTURE behavior OF tb_cntrl IS 
 
   -- Unit Under Test (UUT) component declaration
 
    COMPONENT control_unit
    PORT(
         clk : IN  std_logic;
         cond1 : IN  std_logic;
         cond2 : IN  std_logic;
         cond3 : IN  std_logic;
         cond4 : IN  std_logic;
         start : OUT  std_logic;
         writeInit : OUT  std_logic;
         writePos : OUT  std_logic;
         writeY : OUT  std_logic;
         writeX : OUT  std_logic;
         writeCh : OUT  std_logic;
         writeConv : OUT  std_logic
        );
    END COMPONENT;
    

   --Input
   signal clk : std_logic := '0';
   signal cond1 : std_logic := '0';
   signal cond2 : std_logic := '0';
   signal cond3 : std_logic := '0';
   signal cond4 : std_logic := '0';

 	--Output
   signal start : std_logic;
   signal writeInit : std_logic;
   signal writePos : std_logic;
   signal writeY : std_logic;
   signal writeX : std_logic;
   signal writeCh : std_logic;
   signal writeConv : std_logic;

   -- Definition of the clock period
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiation of the Unit Under Test (UUT)
   uut: control_unit PORT MAP (
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

   -- Clock
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   stim_proc: process
   begin		
      wait for 100 ns;	
cond1 <= '0';
cond2 <= '0';
cond3 <= '0';
cond4 <= '0';

      wait for clk_period*10;
      wait for 100 ns;	
cond1 <= '1';
cond2 <= '0';
cond3 <= '0';
cond4 <= '0';

      wait for clk_period*10;
      wait for 100 ns;	
cond1 <= '1';
cond2 <= '1';
cond3 <= '0';
cond4 <= '0';

      wait for clk_period*10;
      wait for 100 ns;	
cond1 <= '1';
cond2 <= '1';
cond3 <= '1';
cond4 <= '0';

      wait for clk_period*10;
      wait for 100 ns;	
cond1 <= '1';
cond2 <= '1';
cond3 <= '1';
cond4 <= '1';

      wait for clk_period*10;
      wait for 100 ns;	
cond1 <= '0';
cond2 <= '0';
cond3 <= '0';
cond4 <= '0';


      wait;
   end process;

END;

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY sim_counter IS
END sim_counter;
 
ARCHITECTURE behavior OF sim_counter IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT counter
    PORT(
         rst : IN  std_logic;
         clk : IN  std_logic;
         count_up : IN  std_logic;
         leds : OUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal rst : std_logic := '0';
   signal clk : std_logic := '0';
   signal count_up : std_logic := '0';

     --Outputs
   signal leds : std_logic_vector(3 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
    -- Instantiate the Unit Under Test (UUT)
   uut: counter PORT MAP (
          rst => rst,
          clk => clk,
          count_up => count_up,
          leds => leds
        );

   -- Clock process definitions
   clk_process :process
   begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
   end process;
 

    -- Stimulus process
    stim_proc: process
    begin        
        rst <= '1';
        wait for clk_period*5;    
        rst <= '0';
        count_up <= '1';

        wait for clk_period*50;

        count_up <= '0';

      wait;
   end process;

END;

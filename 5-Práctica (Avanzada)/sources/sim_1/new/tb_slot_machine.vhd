library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.definitions.all;

entity tb_multiplier is
end tb_multiplier;

architecture beh of tb_multiplier is

    component ASM_multiplier is
        port( reset, clk : in  std_logic;
              start, stop: in  std_logic;
              leds_sequence : out std_logic_vector(7 downto 0);
              displays_enabled : out std_logic_vector(3 downto 0);
              roulettes_displays: out std_logic_vector(6 downto 0)  );
              
    end component;

    signal clk, reset, init, done  : std_logic := '0';
    signal start, stop              : std_logic := '0';
    signal leds_sequence         : std_logic_vector(7 downto 0) := (others => '0'); 
    signal displays_enabled      : std_logic_vector(3 downto 0) := (others => '0');   
    signal roulettes_displays    : std_logic_vector(6 downto 0) :=  (others =>'0');

begin

  -------------------------------------------------------------------------------
  -- Component instantiation
  -------------------------------------------------------------------------------

  i_dut : ASM_multiplier
    port map (
      reset     => reset,
      clk       => clk,
      start     => start,
      stop      => stop,
      leds_sequence => leds_sequence,
      displays_enabled => displays_enabled,
      roulettes_displays => roulettes_displays
      );

  -----------------------------------------------------------------------------
  -- Process declaration
  -----------------------------------------------------------------------------
  -- Input clock
  p_clk : process
  begin
    clk <= '0', '1' after 10 ns;
    wait for 20 ns;
  end process p_clk;

  p_driver : process
    variable v_i, v_j  : natural := 0;
    variable v_sol     : std_logic_vector(7 downto 0);
  begin
    -- reset
    reset  <= '1';
    wait for 5 ns;
    reset  <= '0';
    wait for 100 ns;
    
    start <= '1';
    wait for 10 ns;
    start <= '0';
    wait for 100 ns;
--    wait for 30 ns;
    stop <= '1';
    wait for 15 ns;
    stop <= '0';
    wait for 100 ns;
    
    
--    start <= '1';
--    wait for 10 ns;
--    start <= '0';
--    wait for 100 ns;
----    wait for 30 ns;
--    stop <= '1';
--    wait for 5 ns;
--    stop <= '0';
--    wait for 100 ns;
--    --End
    wait;
  end process p_driver;

end beh;
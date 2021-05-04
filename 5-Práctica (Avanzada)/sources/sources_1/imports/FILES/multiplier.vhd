library ieee;
use ieee.std_logic_1164.all;
use work.definitions.all;

entity ASM_multiplier is
    port( reset, clk : in  std_logic;
          start, stop: in  std_logic;
          leds_sequence : out std_logic_vector(7 downto 0);
          displays_enabled : out std_logic_vector(3 downto 0);
          roulettes_displays: out std_logic_vector(6 downto 0) );
end ASM_multiplier;


architecture arch_ASM_mult of ASM_multiplier is

    component debouncer is
        port (
            rst             : in std_logic;
            clk             : in std_logic;
            x               : in std_logic;
            xDeb            : out std_logic;
            xDebFallingEdge : out std_logic;
            xDebRisingEdge  : out std_logic
        );
        end component;
    component clock_divider
        port( 
                rst      : in  std_logic;
                clk_in   : in  std_logic; 
                clk_1hz  : out std_logic;
                clk_cnt1 : out std_logic;
                clk_cnt2 : out std_logic     
        );
    end component clock_divider;
    
    component controller
        port( reset, clk, start, stop : in std_logic;
              status           : in  std_logic_vector(W_STATUS-1  downto 0);
              control          : out std_logic_vector(W_CONTROL-1 downto 0)
              );
    end component controller;
    
    
    component data_path
        port( rst,clk, clk_counter_secs, clk_roulette_1, clk_roulette_2: in std_logic; 
              start, stop : in  std_logic;
              control    : in  std_logic_vector(W_CONTROL-1 downto 0);
              status     : out std_logic_vector(W_STATUS-1  downto 0);
              leds_atraction: out std_logic_vector(7 downto 0);
              displays_enabled : out std_logic_vector(3 downto 0);
              roulettes_displays: out std_logic_vector(6 downto 0)
              );
    end component data_path;

    signal status  : std_logic_vector(W_STATUS-1  downto 0);
    signal control : std_logic_vector(W_CONTROL-1 downto 0);
    signal xDebRisingStart, xDebRisingStop: std_logic; 
    signal outputAux0, outputAux1, outputAux2: std_logic;
    signal clk_1_hz_out, clk_out_cnt_1, clk_out_cnt_2: std_logic; 
    signal testing: std_logic_vector(2 downto 0);
begin

-- rst             : in std_logic;
--            clk             : in std_logic;
--            x               : in std_logic;
--            xDeb            : out std_logic;
--            xDebFallingEdge : out std_logic;
--            xDebRisingEdge  : out std_logic     
    DEBOUNCER_START: debouncer port map(rst => reset,
                                        clk => clk, 
                                        x => start,
                                        xDeb => outputAux0,
                                        xDebFallingEdge => outputAux1,
                                        xDebRisingEdge => xDebRisingStart);
                                        
    DEBOUNCER_STOP: debouncer port map(rst => reset,
                                       clk => clk, 
                                       x => stop,
                                       xDeb => outputAux0,
                                       xDebFallingEdge => outputAux2,
                                       xDebRisingEdge => xDebRisingStop);
     

    
    U_CLOCK: clock_divider 
        port map(rst => reset, 
                 clk_in => clk, 
                 clk_1hz => clk_1_hz_out, 
                 clk_cnt1 => clk_out_cnt_1, 
                 clk_cnt2 => clk_out_cnt_2);
    
    U_CNTRL: controller
        port map(reset, clk, start, stop, status, control);

    U_DP: data_path
        port map(rst => reset, 
                 clk => clk, 
                 clk_counter_secs => clk_1_hz_out, 
                 clk_roulette_1 => clk_out_cnt_1, 
                 clk_roulette_2 => clk_out_cnt_2, 
                 start => start,
                 stop => stop,
                 control => control, 
                 status => status,
                 leds_atraction => leds_sequence,
                 displays_enabled => displays_enabled,
                 roulettes_displays => roulettes_displays);

end arch_ASM_mult;

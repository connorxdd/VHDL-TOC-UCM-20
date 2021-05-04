library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.definitions.all;

entity clock_divider is
    port( 
        rst      : in  std_logic;
        clk_in   : in  std_logic; 
        clk_1hz  : out std_logic;
        clk_cnt1 : out std_logic;
        clk_cnt2 : out std_logic          
    );
end clock_divider;

architecture arch_divider of clock_divider is
    component freq_divider is
        generic( half_count: unsigned);
        port (
            rst     : in std_logic;
            clk_in  : in std_logic; 
            clk_out : out std_logic
        );
    end component;
begin
    
    U_1HZ: freq_divider
        generic map(FREQ_1HZ)
        port map(rst, clk_in, clk_1hz);
        
    U_1KHZ: freq_divider 
        generic map(FREQ_C1)
        port map(rst, clk_in, clk_cnt1);
        
    U_10KHZ: freq_divider 
        generic map(FREQ_C2)
        port map(rst, clk_in, clk_cnt2);

end arch_divider;

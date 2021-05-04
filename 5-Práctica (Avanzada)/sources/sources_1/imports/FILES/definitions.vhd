library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package definitions is
    -- Creates clk_out clock with a period T_out=T_in*(half_count+1)*2 
    -- for half_count greater than 0. T_in=1/100MHz=10ns
    --Original: "10111110101111000001111111"
    constant FREQ_1HZ   : unsigned := "10111110101111000001111111"; -- 1Hz   => 49999999
    
    --Original: "1100001101001111"
    constant FREQ_C1    : unsigned := "1100001101001111";           -- 1KHz  =>    49999
    
    --Original: "1001110000111"
    constant FREQ_C2    : unsigned := "1001110000111";              -- 10KHz =>     4999
    constant W_COUNTS   : integer  := 4;
    
    -- Control Constants

    -- COMPLETE...
    constant ld_seq_gen : integer := 0;
    constant seq_invert  : integer := 1;
    constant mux_sequence    : integer := 2;
    constant reset_cu   : integer := 3;
    constant ld_roulette_1: integer:= 4;
    constant ld_roulette_2: integer:= 5;
    constant counter_plus: integer:= 6;   
    constant ld_timer: integer:= 7;
    constant timer_plus: integer := 8;
    constant invert_sequence: integer := 9;
    constant result_win_lose: integer := 10;
    constant ld_reg_1: integer := 11;
    constant ld_reg_2: integer := 12;
    constant W_CONTROL  : integer := 13;   -- Control vector width

    -- Status Constants

    -- COMPLETE...
    constant has_started: integer := 0;
    constant has_stopped: integer := 1;
    constant equals     : integer := 2;
    constant ten_secs   : integer := 3;
    constant W_STATUS   : integer := 4;   -- Status vector width
end package definitions;
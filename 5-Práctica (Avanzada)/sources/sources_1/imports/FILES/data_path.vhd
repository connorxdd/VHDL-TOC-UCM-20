library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.definitions.all;

entity data_path is
    port( rst,clk, clk_counter_secs, clk_roulette_1, clk_roulette_2: in std_logic; 
          start, stop : in  std_logic;
          control    : in  std_logic_vector(W_CONTROL-1 downto 0);
          status     : out std_logic_vector(W_STATUS-1  downto 0);
          leds_atraction: out std_logic_vector(7 downto 0);
          displays_enabled : out std_logic_vector(3 downto 0);
          roulettes_displays: out std_logic_vector(6 downto 0) );
end data_path;

architecture arch_dp of data_path is
    component asynch_reg
        generic (n: natural := 8);
        port( clk, rst, load : in  std_logic;
              din            : in  std_logic_vector (n-1 downto 0);
              dout           : out std_logic_vector (n-1 downto 0) );
    end component asynch_reg;
    component adder_sub
        generic( n: natural := 8 );
        port( a   : in std_logic_vector(n-1 downto 0);
              b   : in std_logic_vector(n-1 downto 0);
              op  : in std_logic;
              res : out std_logic_vector(n-1 downto 0) );
    end component adder_sub;
    
    component left_right_shift_reg
        generic (n: natural := 6);
        port( clk, reset, load : in  std_logic;
              r_shf, l_shf     : in  std_logic;
              data_in          : in  std_logic_vector(n-1 downto 0);    
              data_out         : out std_logic_vector(n-1 downto 0) );
    end component left_right_shift_reg;
    
    component seq_generator
         port (
        clk      : in std_logic; 
        rst      : in std_logic;
        load     : in std_logic;
        shift_invert : in std_logic;
        seq_in   : in  std_logic_vector(7 downto 0);
        seq_out  : out std_logic_vector(7 downto 0)
    );
    end component;
    
    component displays
        port(
        rst : in STD_LOGIC;
        clk : in STD_LOGIC;       
        digito_0 : in  STD_LOGIC_VECTOR (3 downto 0);
        digito_1 : in  STD_LOGIC_VECTOR (3 downto 0);
        digito_2 : in  STD_LOGIC_VECTOR (3 downto 0);
        digito_3 : in  STD_LOGIC_VECTOR (3 downto 0);
        display : out  STD_LOGIC_VECTOR (6 downto 0);
        display_enable : out  STD_LOGIC_VECTOR (3 downto 0)
        );
    end component;
    
    
    component counter_n is
    generic(n: natural := 8);
    port( clk: in std_logic;
          rst: in std_logic;
          load: in std_logic;
          count_up: in std_logic;
          count_down: in std_logic;
          din: in std_logic_vector(n-1 downto 0);
          dout: out std_logic_vector(n-1 downto 0) );
    end component;

    -- INTERMEDIATE SIGNALS...
    signal mux_segment_out, testing_out, final_result: std_logic_vector(7 downto 0);
    signal roul_in_1, roul_in_2, roul_out_1, roul_out_2, timer_in, timer_out: std_logic_vector(W_COUNTS-1 downto 0);
    signal reset_final: std_logic;
    signal in_sequence, result_sequence_in, result_sequence_out: std_logic_vector(7 downto 0);
    signal counter_roulette_1, counter_roulette_2: unsigned(W_COUNTS-1 downto 0);
    signal register_out_1, register_out_2: std_logic_vector(W_COUNTS - 1 downto 0);
    signal loop_done: std_logic;
    
begin
    
--   --mux_segment_out <= (others => '0') when control(mux_seq) = '0' else final_result;
   reset_final <= rst or control(reset_cu); 
   
   
   
   
    -- when control(mux_counter) = '0' else timer_out;

----        clk      : in std_logic; 
----        rst      : in std_logic;
----        load     : in std_logic;
----        shift_invert : in std_logic;
----        seq_in   : in  std_logic_vector(7 downto 0);
----        seq_out  : out std_logic_vector(7 downto 0)


   status(equals) <= '1' when counter_roulette_1=counter_roulette_2 else '0'; 
   status(has_started) <= '1' when start = '1' else '0';
   status(has_stopped) <= '1' when stop = '1' else '0'; 
   --result_sequence_in <= "10101010" when control(result_win_lose) = '1' else "00000000";
   in_sequence <= "00000000" when control(mux_sequence) = '0' else result_sequence_in;
   SEQUENCE: seq_generator port map(clk => clk_counter_secs, 
                                    rst => rst, 
                                    load => control(ld_seq_gen), 
                                    shift_invert => control(seq_invert), 
                                    seq_in => in_sequence, 
                                    seq_out => result_sequence_out);
   leds_atraction <= result_sequence_out;
   
   
   COMB_EQ: process(counter_roulette_1, counter_roulette_2)
    begin
        if(counter_roulette_1 = counter_roulette_2) then
            result_sequence_in <= "10101010";
        else
            result_sequence_in <= "00000000";
        end if;
   end process;
   
    
   roul_in_1 <= "0000";
   ROULETTE1: counter_n generic map (W_COUNTS) port map(clk => clk_roulette_1, 
                                                        rst => reset_final, 
                                                        load => control(ld_roulette_1),
                                                        count_up => control(counter_plus),
                                                        count_down => '0',
                                                        din => roul_in_1,
                                                        dout => roul_out_1);
   
   counter_roulette_1 <= unsigned(roul_out_1);
   
   roul_in_2 <= "0000";-- when control(mux_counter) = '0' else roul_out_2;                                                     
   ROULETTE2: counter_n generic map(W_COUNTS) port map(clk => clk_roulette_2, 
                                                       rst => reset_final, 
                                                       load => control(ld_roulette_2),
                                                       count_up => control(counter_plus),
                                                       count_down => '0',
                                                       din => roul_in_2,
                                                       dout => roul_out_2);
    counter_roulette_2 <= unsigned(roul_out_2);                                                 
                                                       
                                                       
-- component asynch_reg
--        generic (n: natural := 8);
--        port( clk, rst, load : in  std_logic;
--              din            : in  std_logic_vector (n-1 downto 0);
--              dout           : out std_logic_vector (n-1 downto 0) );
--    end component asynch_reg;                                                       
                                
   REG_RIGHT: asynch_reg generic map(W_COUNTS) 
                        port map(clk, rst, control(ld_reg_1), roul_out_1, register_out_1);                                               
   REG_LEFT: asynch_reg generic map(W_COUNTS) 
                        port map(clk, rst, control(ld_reg_2), roul_out_2, register_out_2);            
                        
                                                                   
                                                       
                                    
   display_right: displays port map(rst => rst, 
                                    clk => clk, 
                                    digito_0 => roul_out_1, 
                                    digito_1 => roul_out_2, 
                                    digito_2 => register_out_1,
                                    digito_3 => register_out_2, 
                                    display => roulettes_displays, 
                                    display_enable => displays_enabled);                      

                                                                      
   --display_leds: display port map(reset, clk, digito0, digito1, "0000", "0000", out, "0011");
   timer_in <= "0000";
   TEN_SECS_TIMER: counter_n generic map(W_COUNTS) port map(clk => clk_counter_secs, 
                                                            rst => reset_final, 
                                                            load => control(ld_timer),
                                                            count_up => control(timer_plus),
                                                            count_down => '0',
                                                            din => timer_in,
                                                            dout => timer_out);
                                                            
   status(ten_secs) <= '1' when timer_out = "1001" else '0';
   loop_done <= '1' when timer_out = "1001" else '0';
   
   
   

end arch_dp;

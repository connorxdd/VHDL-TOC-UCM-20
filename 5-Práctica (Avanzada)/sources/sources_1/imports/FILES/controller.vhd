library ieee;
use ieee.std_logic_1164.all;
use work.definitions.all;

entity controller is
        port( reset, clk, start, stop : in std_logic;
              status           : in  std_logic_vector(W_STATUS-1  downto 0);
              control          : out std_logic_vector(W_CONTROL-1 downto 0)
              );
    end  controller;

architecture arch_controller of controller is
    type T_STATE is (S_reset, S_load_test, S_init, S_wait_stop, S_compare_eq, S_ld_win, S_wait_ten_secs);
    signal STATE, NEXT_STATE: T_STATE;
begin

	SYNC_STATE: process (clk, reset)
	begin
		if clk'event and clk = '1' then
			if reset = '1' then
				STATE <= S_reset;
			else
				STATE <= NEXT_STATE;
			end if;
		end if;
	end process SYNC_STATE;


    COMB: process (STATE, start, stop, status)
    begin
        control <= (others => '0');
        case STATE is
            --load todos los control(reset) a 1
            when S_reset =>
                control(reset_cu) <= '1';
                control(ld_roulette_1) <= '1';
                control(ld_roulette_2) <= '1';
                control(ld_timer) <= '1';
                control(result_win_lose) <= '0';
                
                control(mux_sequence) <= '0';
                control(ld_seq_gen) <= '1';
                
                NEXT_STATE <= S_load_test;
                
            when S_load_test =>    
                NEXT_STATE <= S_init;
                
                
           
            when S_init =>
                control(seq_invert) <= '1';
                control(counter_plus) <= '0';
                
                if(status(has_started) = '1') then    
                    NEXT_STATE <= S_wait_stop;
                else   
                    NEXT_STATE <= S_init;
                end if;
            
            when S_wait_stop =>
                control(mux_sequence) <= '0';
                control(ld_seq_gen) <= '1';
                control(counter_plus) <= '1';
                
                if (status(has_stopped) = '1') then
                    NEXT_STATE <= S_compare_eq;
                else
                    NEXT_STATE <= S_wait_stop;
                end if;
                
            when S_compare_eq =>
                control(counter_plus) <= '0'; 
                control(mux_sequence) <= '0';
                control(ld_seq_gen) <= '1';                     
                
                if(status(equals) = '1') then
                    NEXT_STATE <= S_ld_win;
                else
                    NEXT_STATE <= S_wait_ten_secs;
                end if;
                
                
            when S_ld_win =>
                control(result_win_lose) <= '1';
                control(mux_sequence) <= '1';
                control(ld_seq_gen) <= '1';
                NEXT_STATE <= S_wait_ten_secs;
                
            when S_wait_ten_secs =>
                control(timer_plus) <= '1';
                control(ld_seq_gen) <= '0';
                control(seq_invert) <= '0';
                control(ld_reg_1) <= '1';
                control(ld_reg_2) <= '1';
                if(status(ten_secs) = '1') then
                    NEXT_STATE <= S_reset;
                else                   
                    NEXT_STATE <= S_wait_ten_secs;
                end if;
                
        end case;
    end process;

end arch_controller;

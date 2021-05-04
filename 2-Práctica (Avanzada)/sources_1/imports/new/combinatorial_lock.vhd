----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.10.2020 12:39:03
-- Design Name: 
-- Module Name: combinatorial_lock - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity combinatorial_lock is
        
        port (
        rst_lock             : in std_logic;
        clk             : in std_logic;
        push_button          : in std_logic;
        password             : in std_logic_vector (7 downto 0);
        cathodes            : out std_logic_vector(3 downto 0);
        leds_lock           : out std_logic_vector(6 downto 0);
        testing:            out std_logic
    );
end combinatorial_lock;

architecture Behavioral of combinatorial_lock is
    component debouncer
        port(
                rst             : in std_logic;
                clk             : in std_logic;
                x               : in std_logic;
                x_deb            : out std_logic;
                x_deb_falling_edge : out std_logic;
                x_deb_rising_edge  : out std_logic 
        );
    end component;
    
    
    component conv_7seg is
        port ( x       : in   std_logic_vector (3 downto 0);
               display : out  std_logic_vector (6 downto 0) );
    end component;

      
    component clock_divider
        port( 
            clk_in:  in std_logic; 
            clk_out: out std_logic );
    end component;
    
    component parallel_reg is
    port( rst, clk, load: in  std_logic;
	       I:              in  std_logic_vector(7 downto 0);
	       O:              out std_logic_vector(7 downto 0) );
    end component;
    --Intermediate clock
     signal clk_aux: std_logic;
    
    --Debouncer intermediate signals.
     signal x_deb_aux :  std_logic;
     signal x_deb_falling_edge_aux :  std_logic;
     signal x_deb_rising_edge_aux  :  std_logic;
     
    --Password registered
     signal original_pw: std_logic_vector(7 downto 0);
     signal pw_output:  std_logic_vector(7 downto 0);
     signal equal : std_logic;
     signal load: std_logic;
    
    signal attemps_left: std_logic_vector (3 downto 0);    
    signal vector_final_result: std_logic_vector (6 downto 0);
    
    
    type STATES is (initial, three, two, one, final);
    signal STATE, NEXT_STATE: STATES;

    

begin

     mod_clok_divider: clock_divider port map(clk, clk_aux);


--                rst             : in std_logic;
--                clk             : in std_logic;
--                x               : in std_logic;
--                x_deb            : out std_logic;
--                x_deb_falling_edge : out std_logic;
--                x_deb_rising_edge  : out std_logic 

     
     mod_debouncer: debouncer port map('1', clk, push_button, x_deb_aux, x_deb_falling_edge_aux, x_deb_rising_edge_aux);
     
     mod_parallel_reg: parallel_reg port map(rst_lock, clk, load, password, pw_output);
         
     mod_conv_7seg: conv_7seg port map(attemps_left, leds_lock);   
     
     cathodes <= "1110";
     testing <= clk_aux;
     
     SYNC: process (clk)
        begin
            if clk'event and clk ='1' then
                if rst_lock ='1' then
                    STATE <= initial;
                else
                    STATE <= NEXT_STATE;
                end if;
            end if;
       end process SYNC;
       
       COMB: process (STATE, x_deb_rising_edge_aux, password, pw_output)
            begin
            case STATE is
            when initial =>
                load <= '1';
                attemps_left <= "0100";
                if (x_deb_rising_edge_aux = '1') then 
                    NEXT_STATE <= three;
                else
                    NEXT_STATE <= initial;                
                end if;
                
                
            when three =>
                 attemps_left <= "0011";
            
                if (x_deb_rising_edge_aux = '1') then 
                     if password = pw_output then
                        NEXT_STATE <= initial;                        
                     else
                        NEXT_STATE <= two;   
                     end if;
                else
                    NEXT_STATE <=  three;
                end if;
                
                
            when two =>
                attemps_left <= "0010";
                if (x_deb_rising_edge_aux = '1') then
                   if password = pw_output then
                        NEXT_STATE <= initial;
                    else 
                        NEXT_STATE <= one;
                    end if;
                else
                    NEXT_STATE <=  two;
                end if;
                
                
            when one =>
               attemps_left <= "0001"; 
               if (x_deb_rising_edge_aux = '1') then
                   if password = pw_output then
                        NEXT_STATE <= initial;
                        
                   else
                        NEXT_STATE <= final;
                        
                   end if;
                 else
                    NEXT_STATE <=  one;
                end if;
                
                
             when final =>
                attemps_left <= "0000";
              
            end case;
        end process COMB;
        
end Behavioral;




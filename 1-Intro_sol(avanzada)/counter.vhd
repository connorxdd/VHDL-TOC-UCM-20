library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity counter is
    Port ( rst, clk, count_up: in  STD_LOGIC;
           leds :              out STD_LOGIC_VECTOR (3 downto 0));
end counter;

architecture arch_counter of counter is
    component adder4b
        Port ( A, B : in  STD_LOGIC_VECTOR (3 downto 0);
               C    : out STD_LOGIC_VECTOR (3 downto 0) );
    end component;

    component parallel_reg
        port( rst, clk, load : in  std_logic;
              I              : in  std_logic_vector(3 downto 0);
              O              : out std_logic_vector(3 downto 0) );
    end component;
     
    component clock_divider is
        port( clk_in  : in  std_logic; 
              clk_out : out std_logic );
    end component;
     
    signal current_value : std_logic_vector(3 downto 0);
    signal add_out       : std_logic_vector(3 downto 0);
    signal clk_aux       : std_logic;
     
begin
    ADDER: adder4b
          port map("0001", current_value, add_out);

    U_CLOCKDIV: clock_divider 
        port map(clk, clk_aux);
        
    REG: parallel_reg
        port map(rst, clk_aux, count_up, add_out, current_value);

    leds <= current_value;

end arch_counter;


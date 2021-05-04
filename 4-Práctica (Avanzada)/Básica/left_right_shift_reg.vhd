library ieee;
use ieee.std_logic_1164.all;

entity left_right_shift_reg is
    generic (n: natural := 6);
    port( clk, reset, load : in std_logic;
          r_shf, l_shf     : in std_logic;
          data_in          : in std_logic_vector(n-1 downto 0);    
          data_out         : out std_logic_vector(n-1 downto 0) );
end left_right_shift_reg;

architecture ARCH of left_right_shift_reg is

    signal aux : std_logic_vector(n-1 downto 0);

begin

    process (clk) 
    begin 
        if rising_edge(clk) then
            if reset = '1' then 
                aux <= (others => '0'); 
            elsif load = '1' then 
                aux <= data_in; 
            elsif r_shf = '1' then 
                aux <= '0' & aux (n-1 downto 1);
            elsif l_shf = '1' then
                aux <= aux(n-2 downto 0) & '0';
            end if; 
        end if; 
    end process;

    data_out <= aux;

end ARCH;

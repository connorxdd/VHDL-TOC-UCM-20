library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity seq_generator is
    port (
        clk      : in std_logic; 
        rst      : in std_logic;
        load     : in std_logic;
        shift_invert : in std_logic;
        seq_in   : in  std_logic_vector(7 downto 0);
        seq_out  : out std_logic_vector(7 downto 0)
    );
end seq_generator;

architecture divider_arch of seq_generator is
    signal reg : std_logic_vector(7 downto 0);
begin

    counter:
    process(rst, clk, load, seq_in)
    begin
        if(rst='1') then
            reg <= (others=>'0');
        elsif rising_edge(clk) then
            if(load='1') then
                reg <= seq_in;
            elsif (shift_invert = '1') then 
                reg <= not(reg(0)) & reg(7 downto 1);
            else
                reg <= not(reg);
            end if;
        end if;
    end process counter;

    seq_out <= reg;

end divider_arch;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity seq_generator is
    port (
        clk      : in std_logic; 
        rst      : in std_logic;
        load     : in std_logic;
        shift_invert : in std_logic;
        seq_in   : in  std_logic_vector(7 downto 0);
        seq_out  : out std_logic_vector(7 downto 0)
    );
end seq_generator;

architecture divider_arch of seq_generator is
    signal reg : std_logic_vector(7 downto 0);
begin

    counter:
    process(rst, clk, load, seq_in)
    begin
        if(rst='1') then
            reg <= (others=>'0');
        elsif rising_edge(clk) then
            if (load='1') then
                reg <= seq_in;
            elsif (shift_invert = '1') then 
                reg <= not(reg(0)) & reg(7 downto 1);
            else
                reg <= not(reg);
            end if;
        end if;
    end process counter;

    seq_out <= reg;

end divider_arch;

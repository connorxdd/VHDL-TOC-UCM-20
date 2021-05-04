library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mult8b_std is
    port( X : in  std_logic_vector(3 downto 0);
          Y : in  std_logic_vector(3 downto 0);
          Z : out std_logic_vector(7 downto 0) );
end mult8b_std;

architecture arch_mult8b of mult8b_std is
   
    signal x_u, y_u : unsigned(3 downto 0);
    signal s_u      : unsigned(7 downto 0);

begin
    x_u <= unsigned(X);
    y_u <= unsigned(Y);
    
    s_u <= x_u * y_u;
    Z   <= std_logic_vector(s_u);

end architecture arch_mult8b;

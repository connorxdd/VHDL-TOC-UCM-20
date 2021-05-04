library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder_mul is
    port( 
          X : in  std_logic_vector(3 downto 0);
          Y : in  std_logic_vector(3 downto 0);
          Z : out std_logic_vector(7 downto 0) );
end adder_mul;

architecture arch_adder8b of adder_mul is
    component adder4b is 
        port (
                a: in  std_logic_vector(7 downto 0);
                b: in  std_logic_vector(7 downto 0);
                c: out std_logic_vector(7 downto 0)
        );
    end component;

    --First level
    signal y_part_left, y_part_right: std_logic_vector(3 downto 0):= "0000";
    signal a_mul, b_mul, c_mul: std_logic_vector(7 downto 0):= "00000000";
    
    --Second level
    signal y_part_left_sec: std_logic_vector(3 downto 0):= "0000";
    signal a_mul_sec, c_mul_sec: std_logic_vector(7 downto 0):= "00000000";
    
    --Third level
    signal y_part_left_thi: std_logic_vector(3 downto 0):= "0000";
    signal a_mul_thi: std_logic_vector(7 downto 0):= "00000000";
      
begin

    --Primer adder;
   
   
      y_part_right <= (3 downto 0 => Y(0));
      b_mul <= "0000" & (X and y_part_right);
     
      y_part_left<= (3 downto 0 => Y(1));
      a_mul(4 downto 1) <= X and y_part_left;
      adder1:  adder4b port map(a_mul, b_mul, c_mul);
      
      y_part_left_sec <= (3 downto 0 => Y(2));
      a_mul_sec(5 downto 2) <= X and y_part_left_sec;
      
      adder2:  adder4b port map(a_mul_sec, c_mul, c_mul_sec);
      
      y_part_left_thi <= (3 downto 0 => Y(3));
      a_mul_thi(6 downto 3) <= X and y_part_left_thi;
      
      adder3:  adder4b port map(a_mul_thi, c_mul_sec, Z);
      --Z   <= "0000" & std_logic_vector(y_u);

end architecture arch_adder8b;

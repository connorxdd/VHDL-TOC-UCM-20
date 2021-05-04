library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.definitions.all;

entity data_path is
    port( clk, reset : in  std_logic;
          a_in, b_in : in  std_logic_vector (W_FACTORS-1 downto 0);
          control    : in  std_logic_vector (W_CONTROL-1 downto 0);
          status     : out std_logic_vector (W_STATUS-1  downto 0);
          output_segments: out std_logic_vector (W_FACTORS - 1  downto 0);
          r          : out std_logic_vector (W_RESULT - 2  downto 0) );
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
    
    component displays is
    Port ( 
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

    component conv_7seg is
        Port ( x : in  STD_LOGIC_VECTOR (3 downto 0);
               display : out  STD_LOGIC_VECTOR (6 downto 0));
    end component;
    
    signal in_rn, out_rn, zeroes: std_logic_vector(a_in'RANGE);
    signal in_ra, out_ra: std_logic_vector(W_RESULT-1 downto 0);
    signal in_rb, out_rb: std_logic_vector(a_in'RANGE);
    signal sub_n, sub_one: std_logic_vector(a_in'RANGE);
    signal in_racc_add, in_a_add, add_acc, in_racc, out_racc: std_logic_vector(W_RESULT-1 downto 0);
    
    signal seven_segments_one, seven_segments_two: std_logic_vector(W_FACTORS downto 0);
    signal left_number, right_number: std_logic_vector(W_RESULT-1 downto 0);
    
    
begin
    in_ra <= "0000" & a_in;
    in_rb <= b_in;
    zeroes <= (others => '0');
    U_REG_A: left_right_shift_reg 
                generic map(W_RESULT)
                port map(clk, reset, control(ld_ra), '0', control(shl_ra), in_ra, out_ra);
                
    U_REG_B: left_right_shift_reg 
                generic map(W_FACTORS)
                port map(clk, reset, control(ld_rb), control(shr_rb), '0', in_rb, out_rb);
                
    U_REG_N: asynch_reg 
                generic map(W_FACTORS)
                port map(clk, reset, control(ld_rn), in_rn, out_rn);
                
    U_REG_ACC: asynch_reg 
                generic map(W_RESULT)
                port map(clk, reset, control(ld_racc), in_racc, out_racc);     
                
                
    sub_one <= (0 => '1', others => '0');            
    N_SUB: adder_sub
                generic map(W_FACTORS)
                port map(out_rn, sub_one, '1', sub_n);    
                
    in_rn <= sub_n when control(mux_n) = '1' else "0100";
    
    in_racc_add <= out_racc;   
    in_a_add <= out_ra;      
    ACC_ADD: adder_sub
                generic map(W_RESULT)
                port map(in_racc_add, in_a_add, '0', add_acc);   
    in_racc <= add_acc when control(mux_acc) = '0' else (others => '0');            
                
    
    status(zero) <= '1' when out_rn = zeroes else '0';
    status(b0) <= out_rb(0);
    
    --r <= out_racc when out_rn = zeroes;
        
    display_right: displays port map(rst => reset, clk => clk, digito_0 => out_racc(W_FACTORS - 1 downto 0), digito_1 => out_racc(W_RESULT - 1  downto W_FACTORS), digito_2 => "0000", digito_3 => "0000", 
    display => r, display_enable => output_segments);
    
end arch_dp;

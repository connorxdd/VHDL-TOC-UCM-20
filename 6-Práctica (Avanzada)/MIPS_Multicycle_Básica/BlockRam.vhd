library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity BlockRam is
  port (
    clka, wea, ena : in  STD_LOGIC;
    addra          : in  STD_LOGIC_VECTOR (8  downto 0);
    dina           : in  STD_LOGIC_VECTOR (31 downto 0);
    douta          : out STD_LOGIC_VECTOR (31 downto 0)
  );
end BlockRam;

architecture Behavioral of BlockRam is

  type ram_type is array (0 to 511) of std_logic_vector (31 downto 0);
  signal ram : ram_type := 
    (  
            --                                                          ADDR
    x"40030000",         --mv R3, #0
    x"48640000",         --mv R4, R3     
 
    x"8C80002C",--         lw  R0, 44(R4)      (lw A, R0)               0x00000008  1000 1100 1000 0000 0000 0000 0010 1100
    x"8C810030",--         lw  R1, 48(R4)      (lw B, R1)               0x0000000C  1000 1100 1000 0001 0000 0000 0011 0000
    
    x"40020001",           --mv R2, #1
    x"10240003",-- WHILE:  beq R1, R4, END                              0x00000014  0001 0000 0010 0100 0000 0000 0000 0011
    x"00601820",--         add R3, R3, R0                               0x00000018  0000 0000 0110 0000 0001 1000 0010 0000
    x"00220822",--         sub R1, R1, R2                               0x0000001C  0000 0000 0010 0010 0000 1000 0010 0010
                                                                                
    x"08000005",         -- j WHILE                                      0x00000020  0000 1000 0000 0000 0000 0000 0001 0100
    x"AC830038",-- END:    sw R3, 56(R4)       (sw R3, C)               0x00000024  1010 1100 1000 0011 0000 0000 0011 1000
    
    --V1
    --x"1000FFFF",-- DONE:   beq R0, R0, DONE                             0x00000028  0001 0000 0000 0000 1111 1111 1111 1111
    --V2
    x"0800000A",         --j DONE                                       0x00000028  0001 0000 0000 0000 0000 0000 0010 1000
    x"00000007",--         A                                            0x0000002C  0x00000007
    x"00000003",--         B                                            0x00000030  0x00000003
    x"00000001",--         1                                            0x00000034  0x00000001
                        -- C = A*B                                      0x00000038
    others => x"00000000"
    );

begin

  process( clka )
  begin
    if rising_edge(clka) then
      if ena = '1' then
        if wea = '1' then
          ram(to_integer(unsigned(addra))) <= dina;
          douta <= dina;
        else
          douta <= ram(to_integer(unsigned(addra)));
        end if;
      end if;
    end if;
  end process;
  
end Behavioral;


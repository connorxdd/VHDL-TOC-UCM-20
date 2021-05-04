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
--                                       COMMENTS               			    ADDR		INSTRUCTION (BINARY)
 x"40030000",--			mv R3, #0 		Result				0x00000000	010000 00000 00011 0000000000000000
 x"48640000",--			mv R4, R3 		To get a 0			0x00000004	010010 00011 00100 0000000000000000
 x"40050004",--			mv R5, #4		N				0x00000008	010000 00000 00101 0000000000000100
 x"8C800040",--			lw R0, 0x40(R4)		(lw A, R0)			0x0000000C	100011 00100 00000 0000000001000000
 x"8C810044",--			lw R1, 0x44(R4)		(lw B, R0)			0x00000010	100011 00100 00001 0000000001000100
 x"40020001",--			mv R2, #1		To get a 1			0x00000014	010000 00000 00010 0000000000000001
 x"10A40007",--		WHILE:	beq R5, R4, END		Check if N iterations		0x00000018	000100 00101 00100 0000000000000111
 x"00223024",--			and R6, R1, R2		B AND 00...01			0x0000001C	000000 00001 00010 00110 00000 100100
 x"10C40001",--			beq R6, R4, CONT	Check if (B AND 00...01) = 0	0x00000020	000100 00110 00100 0000000000000001
 x"00601820",--			add R3, R3, R0		Add (if (B AND 00...01) = 0)	0x00000024	000000 00011 00000 00011 00000 100000
 x"00000002",--		CONT:	sll1 R0, R0		<<A				0x00000028	000000 00000 00000 00000 00000 000010
 x"00200800",--			sra1 R1, R1		B>>				0x0000002C	000000 00001 00000 00001 00000 000000
 x"00A22822",--			sub R5, R5, R2		N--				0x00000030	000000 00101 00010 00101 00000 100010
 x"08000006",--			j WHILE							0x00000034	000010 00000000000000000000000110
 x"AC830048",--		END: 	sw R3, 0x48(R4) 	Store result			0x00000038	101011 00100 00011 0000000001001000
 x"0800000F",--		FINAL:	j FINAL			Jump to itself			0x0000003C	000010 00000000000000000000001111
 x"00000007",--			A=7							0x00000040
 x"00000003",--			B=3							0x00000044
 x"00000000",--			VALUE C = A*B (Initially 0)				0x00000048
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

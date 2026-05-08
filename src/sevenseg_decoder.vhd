----------------------------------------------------------------------------------
-- FILENAME      : sevenseg_decoder.vhd
-- AUTHOR        : [Your Name]
-- DESCRIPTION   : Hex-to-seven-segment decoder for Basys 3 (Active Low).
--                 Maps 4-bit Hex input to 7-bit cathode output.
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sevenseg_decoder is
    Port ( 
        i_hex : in  STD_LOGIC_VECTOR (3 downto 0);
        o_seg : out STD_LOGIC_VECTOR (6 downto 0)
    );
end sevenseg_decoder;

architecture Behavioral of sevenseg_decoder is
begin

    with i_hex select
        o_seg <=
            "1000000" when x"0",
            "1111001" when x"1",
            "0100100" when x"2",
            "0110000" when x"3",
            "0011001" when x"4",
            "0010010" when x"5",
            "0000010" when x"6",
            "1111000" when x"7",
            "0000000" when x"8",
            "0010000" when x"9",
            "0001000" when x"A",
            "0000011" when x"B",
            "1000110" when x"C",
            "0100001" when x"D",
            "0000110" when x"E",
            "0001110" when x"F",
            "1111111" when others;

end Behavioral;
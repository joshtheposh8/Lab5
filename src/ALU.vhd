----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/18/2025 02:50:18 PM
-- Design Name: 
-- Module Name: ALU - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU is
    Port ( i_A : in STD_LOGIC_VECTOR (7 downto 0);
           i_B : in STD_LOGIC_VECTOR (7 downto 0);
           i_op : in STD_LOGIC_VECTOR (2 downto 0);
           o_result : out STD_LOGIC_VECTOR (7 downto 0);
           o_flags : out STD_LOGIC_VECTOR (3 downto 0));
end ALU;

architecture Behavioral of ALU is

begin
process(i_A, i_B, i_op)
        variable temp9  : unsigned(8 downto 0);
        variable result : STD_LOGIC_VECTOR(7 downto 0);
        variable Z      : STD_LOGIC;
        variable N      : STD_LOGIC;
        variable C      : STD_LOGIC;
        variable V      : STD_LOGIC;
    begin
        result := (others => '0');
        C := '0';
        V := '0';

        case i_op is
--add
            when "000" =>  
                temp9 := ('0' & unsigned(i_A)) + ('0' & unsigned(i_B));
                result := std_logic_vector(temp9(7 downto 0));
                C := temp9(8);

                if (i_A(7) = i_B(7)) and (result(7) /= i_A(7)) then
                    V := '1';
                end if;
--subtract
            when "001" =>  
                temp9 := ('0' & unsigned(i_A)) - ('0' & unsigned(i_B));
                result := std_logic_vector(temp9(7 downto 0));
                C := temp9(8);

                if (i_A(7) /= i_B(7)) and (result(7) /= i_A(7)) then
                    V := '1';
                end if;
--and
            when "010" =>  
                result := i_A and i_B;
--or
            when "011" => 
                result := i_A or i_B;
--xor
            when "100" =>  
                result := i_A xor i_B;
--not a
            when "101" =>  
                result := not i_A;
--left shift
            when "110" =>  
                result := i_A(6 downto 0) & '0';
                C := i_A(7);
--right shift
            when "111" =>  
                result := '0' & i_A(7 downto 1);
                C := i_A(0);
--else
            when others =>
                result := (others => '0');

        end case;

        if result = "00000000" then
            Z := '1';
        else
            Z := '0';
        end if;

        N := result(7);

        o_result <= result;

   
        o_flags <= Z & N & C & V;
    end process;
end Behavioral;

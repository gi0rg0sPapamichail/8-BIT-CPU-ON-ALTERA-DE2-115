library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity ALU_8bit is
  generic ( 
     constant N: natural := 1  -- number of shifted or rotated bits
  );
  Port (
    A, B     : in  STD_LOGIC_VECTOR(7 downto 0);
    ALU_Sel  : in  STD_LOGIC_VECTOR(3 downto 0);
    ALU_Out  : out STD_LOGIC_VECTOR(7 downto 0);
    Carryout : out STD_LOGIC;
    zero     : out STD_LOGIC
  );
end ALU_8bit;

architecture Behavioral of ALU_8bit is
  signal ALU_Result : STD_LOGIC_VECTOR(7 downto 0);
  signal tmp        : UNSIGNED(8 downto 0);
begin

  process(A,B,ALU_Sel)
  begin
    case ALU_Sel is
      when "0000" => -- Addition
        ALU_Result <= std_logic_vector(unsigned(A) + unsigned(B));
      when "0001" => -- Subtraction
        ALU_Result <= std_logic_vector(unsigned(A) - unsigned(B));
      when "0010" => -- Logical OR
        ALU_Result <= A or B;
      when "0011" => -- Logical AND
        ALU_Result <= A and B;
      when "0100" => -- Logical NOT
        ALU_Result <= not A;
      when "0101" => -- Logical XOR
        ALU_Result <= A xor B;
      when "0110" => -- Increment
        ALU_Result <= std_logic_vector(unsigned(A) + 1);
      when "0111" => -- Decrement
        ALU_Result <= std_logic_vector(unsigned(A) - 1);
      when "1000" => -- Shift left
        ALU_Result <= A(6 downto 0) & '0';
      when "1001" => -- Shift right
        ALU_Result <= '0' & A(7 downto 1);
      when others =>
        ALU_Result <= (others => '0');
    end case;
  end process;

  ALU_Out <= ALU_Result;
  tmp <= ('0' & unsigned(A)) + ('0' & unsigned(B));
  Carryout <= tmp(8) when (ALU_Sel = "0000") or (ALU_Sel = "0001") else '0';
  zero <= '1' when ALU_Result = "00000000" else '0';
end Behavioral;

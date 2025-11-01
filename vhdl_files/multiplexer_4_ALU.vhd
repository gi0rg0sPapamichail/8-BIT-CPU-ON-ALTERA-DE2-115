library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity multiplexer_4_ALU is
    Port (
		 A_select : in  STD_LOGIC_VECTOR(1 downto 0);		--output selection
		 B_select : in  STD_LOGIC_VECTOR(1 downto 0);		--output selection
		 A        : in  STD_LOGIC_VECTOR(7 downto 0);		--fisrt input
		 B        : in  STD_LOGIC_VECTOR(7 downto 0);		--second input
		 C        : in  STD_LOGIC_VECTOR(7 downto 0);		--third input	
		 D        : in  STD_LOGIC_VECTOR(7 downto 0);		--fourth input
		 A_out    : out STD_LOGIC_VECTOR(7 downto 0); 		--selected inpout
		 B_out    : out STD_LOGIC_VECTOR(7 downto 0) 		--selected inpout
    );
end multiplexer_4_ALU;

architecture Behavioral of multiplexer_4_ALU is
	signal A_reg_data : STD_LOGIC_VECTOR(7 downto 0); -- internal register
	signal B_reg_data : STD_LOGIC_VECTOR(7 downto 0); -- internal register
begin
	process(A_select, B_select, A, B, C, D)
	begin
		case A_select is
			when "00" =>
				A_reg_data <= A;
			when "01" =>
				A_reg_data <= B;
			when "10" =>
				A_reg_data <= C;
			when "11" =>
				A_reg_data <= D;
		end case;
		
		case B_select is
			when "00" =>
				B_reg_data <= A;
			when "01" =>
				B_reg_data <= B;
			when "10" =>
				B_reg_data <= C;
			when "11" =>
				B_reg_data <= D;
		end case;
	end process;
		
	A_out <= A_reg_data;
	B_out <= B_reg_data;
end Behavioral;
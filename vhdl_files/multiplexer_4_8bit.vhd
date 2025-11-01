library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity multiplexer_4_8bit is
    Port (
		 selector : in  STD_LOGIC_VECTOR(1 downto 0);		--output selection
		 A        : in  STD_LOGIC_VECTOR(7 downto 0);		--fisrt input
		 B        : in  STD_LOGIC_VECTOR(7 downto 0);		--second input
		 C        : in  STD_LOGIC_VECTOR(7 downto 0);		--third input	
		 D        : in  STD_LOGIC_VECTOR(7 downto 0);		--fourth input
		 output   : out STD_LOGIC_VECTOR(7 downto 0) 		--selected inpout
    );
end multiplexer_4_8bit;

architecture Behavioral of multiplexer_4_8bit is
	signal reg_data : STD_LOGIC_VECTOR(7 downto 0); -- internal register
begin
	process(selector, A, B, C, D)
	begin
		case selector is
			when "00" =>
				reg_data <= A;
			when "01" =>
				reg_data <= B;
			when "10" =>
				reg_data <= C;
			when "11" =>
				reg_data <= D;
		end case;
	end process;
		
	output <= reg_data;
end Behavioral;
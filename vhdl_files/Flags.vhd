library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FLAGS is
	Port(
		c_in   : in STD_LOGIC;
		z_in	 : in STD_LOGIC;
		load   : in STD_LOGIC;
		clock	 :	in STD_LOGIC;
		carry  : out STD_LOGIC;
		zero  : out STD_LOGIC
	);
end FLAGS;

architecture Behavioral of FLAGS is
begin
	process(clock)
	begin
		if rising_edge(clock) then
			if load = '1' then
				carry <= c_in;
				zero <= z_in;
			end if;
		end if;
	end process;
end Behavioral;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity base_register is
    Port (
        clk    : in  STD_LOGIC;                    -- clock
        rst    : in  STD_LOGIC;                    -- reset
        load   : in  STD_LOGIC;                    -- load
        input  : in  STD_LOGIC_VECTOR(7 downto 0);-- 8-bit input
        output : out STD_LOGIC_VECTOR(7 downto 0)  -- output
    );
end base_register;

architecture Behavioral of base_register is
    signal reg_data : STD_LOGIC_VECTOR(7 downto 0); -- internal register
begin
		process(clk, rst)
		begin
			if rst = '0' then      -- reset the output to 00000000
            reg_data <= "00000000";
			elsif rising_edge(clk) then -- copy the value of the input to the reg_data
				if load = '1' then	
					reg_data <= input;
				end if;
			end if;
		end process;
		
		output <= reg_data; -- copy the saved value to the output
end Behavioral;

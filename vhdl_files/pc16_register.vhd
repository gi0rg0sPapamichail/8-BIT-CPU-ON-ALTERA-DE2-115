library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity pc16_register is
    Port (
        clk    : in  STD_LOGIC;                    -- clock
        rst    : in  STD_LOGIC;                    -- reset
        load   : in  STD_LOGIC;                    -- load
        inc    : in  STD_LOGIC;                    -- incriment
        input  : in  STD_LOGIC_VECTOR(15  downto 0);-- 8-bit input
        output : out STD_LOGIC_VECTOR(15 downto 0)  -- output
    );
end pc16_register;

architecture Behavioral of pc16_register is
    signal reg_data : STD_LOGIC_VECTOR(15 downto 0); -- internal register
begin
		process(clk, rst)
		
		begin
			if rst = '0' then      -- reset the output to 00000000 if the reset is pressed
            reg_data <= "0000000000000000";
			elsif rising_edge(clk) then -- copy the value of the input to the reg_data
				if inc = '1' then
					reg_data <= std_logic_vector(unsigned(reg_data) + 1);
				elsif load = '1' then	
					reg_data <= input;
				end if;
			end if;
		end process;
		
		output <= reg_data; -- copy the saved value to the output
end Behavioral;

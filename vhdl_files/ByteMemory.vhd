library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ByteMemory is
    Port (
        clk      : in  STD_LOGIC;
        we       : in  STD_LOGIC;                   -- Write enable
        addr     : in  UNSIGNED(7 downto 0);        -- 8-bit address (0–255)
        data_in  : in  STD_LOGIC_VECTOR(7 downto 0);
        data_out : out STD_LOGIC_VECTOR(7 downto 0)
    );
end ByteMemory;

architecture Behavioral of ByteMemory is
    type ram_type is array (0 to 255) of STD_LOGIC_VECTOR(7 downto 0);
    signal RAM : ram_type := (others => (others => '0'));
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if we = '1' then
                RAM(to_integer(addr)) <= data_in;  -- Write operation
            end if;
            data_out <= RAM(to_integer(addr));     -- Read operation
        end if;
    end process;
end Behavioral;

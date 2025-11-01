library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity multiplexer3_8 is
    Port (
        selector : in  STD_LOGIC_VECTOR(1 downto 0);  -- 2-bit selector
        A        : in  STD_LOGIC_VECTOR(7 downto 0); -- first input
        B        : in  STD_LOGIC_VECTOR(7 downto 0); -- second input
        C        : in  STD_LOGIC_VECTOR(7 downto 0); -- third input
        output   : out STD_LOGIC_VECTOR(7 downto 0)  -- selected input
    );
end multiplexer3_8;

architecture Behavioral of multiplexer3_8 is
    signal reg_data : STD_LOGIC_VECTOR(7 downto 0);
begin
    process(selector, A, B, C)
    begin
        case selector is
            when "00" =>
                reg_data <= A;
            when "01" =>
                reg_data <= B;
            when "10" =>
                reg_data <= C;
            when others =>
                reg_data <= A;
        end case;
    end process;

    output <= reg_data;
end Behavioral;

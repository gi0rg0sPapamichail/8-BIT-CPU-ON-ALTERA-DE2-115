library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity lcd_ctrl is
    Port(
        clk         : in    STD_LOGIC;
        data        : in    STD_LOGIC_VECTOR(7 downto 0);  -- ASCII character
        load        : in    STD_LOGIC;                      -- write data
        clr         : in    STD_LOGIC;                      -- clear display
        LCD_RS      : out   STD_LOGIC;                      -- register select
        LCD_RW      : out   STD_LOGIC;                      -- write only
        LCD_EN      : out   STD_LOGIC;                      -- enable strobe
        LCD_DATA    : out   STD_LOGIC_VECTOR(7 downto 0);   -- LCD data bus
        available   : out   STD_LOGIC                       -- high when idle
    );
end lcd_ctrl;

architecture Behavioral of lcd_ctrl is

    type STATE_TYPE is (
        S_INIT,
        S_IDLE,
        S_CMD,
        S_WRITE,
        S_CLEAR,
        S_EN_HIGH,
        S_EN_LOW,
        S_WAIT
    );
    signal state         : STATE_TYPE := S_INIT;

    signal cmd_data      : STD_LOGIC_VECTOR(7 downto 0);
    signal rs_reg        : STD_LOGIC := '0';
    signal en_reg        : STD_LOGIC := '0';
    signal wait_count    : unsigned(19 downto 0) := (others => '0');
    signal init_step     : integer := 0;

    signal char_count    : integer range 0 to 31 := 0;  -- count printed characters
    signal line          : integer range 0 to 1 := 0;   -- current line (0/1)

    signal pending_char  : STD_LOGIC_VECTOR(7 downto 0) := (others => '0'); -- store char after line jump
    signal pending_write : STD_LOGIC := '0';

    constant WAIT_TIME   : unsigned(19 downto 0) := to_unsigned(100000, 20); -- ~5ms @50MHz

begin

    LCD_DATA <= cmd_data;
    LCD_RS   <= rs_reg;
    LCD_RW   <= '0';       -- always write
    LCD_EN   <= en_reg;
    available <= '1' when state = S_IDLE else '0';

    process(clk)
    begin
        if rising_edge(clk) then
            case state is

                -- Initialization sequence for 8-bit, 2-line mode
                when S_INIT =>
                    case init_step is
                        when 0 =>
                            cmd_data <= x"38";  -- 8-bit, 2 lines
                            rs_reg <= '0';
                            state <= S_EN_HIGH;
                            init_step <= 1;
                        when 1 =>
                            cmd_data <= x"0C";  -- Display ON, cursor OFF
                            rs_reg <= '0';
                            state <= S_EN_HIGH;
                            init_step <= 2;
                        when 2 =>
                            cmd_data <= x"01";  -- Clear display
                            rs_reg <= '0';
                            state <= S_EN_HIGH;
                            init_step <= 3;
                        when 3 =>
                            cmd_data <= x"06";  -- Entry mode (increment cursor)
                            rs_reg <= '0';
                            state <= S_EN_HIGH;
                            init_step <= 4;
                        when 4 =>
                            state <= S_IDLE;    -- done
                        when others =>
                            null;
                    end case;

                when S_IDLE =>
                    if clr = '1' then
                        cmd_data <= x"01";   -- Clear display command
                        rs_reg <= '0';
                        state <= S_EN_HIGH;
                        char_count <= 0;     -- reset char counter
                        line <= 0;

                    elsif load = '1' then
                        if char_count = 16 and line = 0 then
                            -- Move to 2nd line
                            cmd_data <= x"C0";
                            rs_reg <= '0';
                            state <= S_EN_HIGH;
                            line <= 1;
                            char_count <= 0;

                            -- Save character to write after move
                            pending_char <= data;
                            pending_write <= '1';

                        else
                            -- Normal write
                            cmd_data <= data;
                            rs_reg <= '1';
                            state <= S_EN_HIGH;
                            char_count <= char_count + 1;
                        end if;
                    end if;

                when S_EN_HIGH =>
                    en_reg <= '1';
                    wait_count <= (others => '0');
                    state <= S_EN_LOW;

                when S_EN_LOW =>
                    if wait_count = WAIT_TIME then
                        en_reg <= '0';
                        state <= S_WAIT;
                        wait_count <= (others => '0');
                    else
                        wait_count <= wait_count + 1;
                    end if;

                when S_WAIT =>
                    if wait_count = WAIT_TIME then
                        wait_count <= (others => '0');

                        if pending_write = '1' then
                            -- Write stored char after jumping to 2nd line
                            cmd_data <= pending_char;
                            rs_reg <= '1';
                            state <= S_EN_HIGH;
                            char_count <= char_count + 1;
                            pending_write <= '0';

                        elsif clr = '1' then
                            state <= S_IDLE;

                        elsif load = '1' then
                            state <= S_IDLE;

                        elsif state = S_INIT then
                            null;

                        else
                            if init_step < 4 then
                                state <= S_INIT;
                            else
                                state <= S_IDLE;
                            end if;
                        end if;

                    else
                        wait_count <= wait_count + 1;
                    end if;

                when others =>
                    state <= S_IDLE;

            end case;
        end if;
    end process;

end Behavioral;

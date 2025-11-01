library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity py_rom is
    Port (
        pc        : in  UNSIGNED(15 downto 0);
        instr_out : out STD_LOGIC_VECTOR(31 downto 0)
    );
end py_rom;

architecture Behavioral of py_rom is
    type rom_type is array (0 to 65535) of STD_LOGIC_VECTOR(31 downto 0);

    -- ==== Opcodes ====
	constant MOV_OP 	: STD_LOGIC_VECTOR(7 downto 0) := "00001010";
	constant LD_OP 	: STD_LOGIC_VECTOR(7 downto 0) := "00001011";
	constant ST_OP 	: STD_LOGIC_VECTOR(7 downto 0) := "00001100";
	constant MVR_OP 	: STD_LOGIC_VECTOR(7 downto 0) := "00001101";
	
	constant ADD1_OP 	: STD_LOGIC_VECTOR(7 downto 0) := "00010001";
	constant SUB1_OP 	: STD_LOGIC_VECTOR(7 downto 0) := "00010010";
	constant OR1_OP 	: STD_LOGIC_VECTOR(7 downto 0) := "00010011";
	constant AND1_OP 	: STD_LOGIC_VECTOR(7 downto 0) := "00010100";
	constant NOT1_OP 	: STD_LOGIC_VECTOR(7 downto 0) := "00010101";
	constant XOR1_OP 	: STD_LOGIC_VECTOR(7 downto 0) := "00010110";
	constant INC1_OP 	: STD_LOGIC_VECTOR(7 downto 0) := "00010111";
	constant DINC1_OP : STD_LOGIC_VECTOR(7 downto 0) := "00011000";
	
	
	
	constant ADD2_OP 	: STD_LOGIC_VECTOR(7 downto 0) := "00100001";
	constant SUB2_OP 	: STD_LOGIC_VECTOR(7 downto 0) := "00100010";
	constant OR2_OP 	: STD_LOGIC_VECTOR(7 downto 0) := "00100011";
	constant AND2_OP 	: STD_LOGIC_VECTOR(7 downto 0) := "00100100";
	constant NOT2_OP 	: STD_LOGIC_VECTOR(7 downto 0) := "00100101";
	constant XOR2_OP 	: STD_LOGIC_VECTOR(7 downto 0) := "00100110";
	constant INC2_OP 	: STD_LOGIC_VECTOR(7 downto 0) := "00100111";
	constant DINC2_OP : STD_LOGIC_VECTOR(7 downto 0) := "00101000";
	
	constant SHR_OP 	: STD_LOGIC_VECTOR(7 downto 0) := "00011001";
	constant SHL_OP 	: STD_LOGIC_VECTOR(7 downto 0) := "00011010";
	
	constant CMP_OP 			: STD_LOGIC_VECTOR(7 downto 0) := "11101100";
	constant CMPRR_OP 		: STD_LOGIC_VECTOR(7 downto 0) := "11101111";
	constant CMPRROM_OP 		: STD_LOGIC_VECTOR(7 downto 0) := "11101110";
	constant CMPRRAM_OP 		: STD_LOGIC_VECTOR(7 downto 0) := "11101101";
	
	constant CMPROMR_OP 		: STD_LOGIC_VECTOR(7 downto 0) := "11011111";
	constant CMPROMROM_OP 	: STD_LOGIC_VECTOR(7 downto 0) := "11011110";
	constant CMPROMRAM_OP 	: STD_LOGIC_VECTOR(7 downto 0) := "11011101";
	
	constant CMPRAMR_OP 		: STD_LOGIC_VECTOR(7 downto 0) := "11001111";
	constant CMPRAMROM_OP 	: STD_LOGIC_VECTOR(7 downto 0) := "11001110";
	constant CMPRAMRAM_OP 	: STD_LOGIC_VECTOR(7 downto 0) := "11001101";

	
	constant JMP_OP 	: STD_LOGIC_VECTOR(7 downto 0) := "11110000";
	constant JE_OP 	: STD_LOGIC_VECTOR(7 downto 0) := "11110001";
	constant JA_OP 	: STD_LOGIC_VECTOR(7 downto 0) := "11110010";
	constant JB_OP 	: STD_LOGIC_VECTOR(7 downto 0) := "11110011";
	constant JEA_OP 	: STD_LOGIC_VECTOR(7 downto 0) := "11110100";
	constant JEB_OP 	: STD_LOGIC_VECTOR(7 downto 0) := "11110101";
	constant JC_OP 	: STD_LOGIC_VECTOR(7 downto 0) := "11110110";
	constant JZ_OP 	: STD_LOGIC_VECTOR(7 downto 0) := "11110111";
	constant JCZ_OP 	: STD_LOGIC_VECTOR(7 downto 0) := "11111000";
	
	constant IN_OP 	: STD_LOGIC_VECTOR(7 downto 0) := "11111100";
	constant PRT_OP 	: STD_LOGIC_VECTOR(7 downto 0) := "11111101";
	constant CLR_OP 	: STD_LOGIC_VECTOR(7 downto 0) := "11111110";
	constant HLT_OP 	: STD_LOGIC_VECTOR(7 downto 0) := "11111111";

    -- ==== Registers ====
   constant A_REG 	: STD_LOGIC_VECTOR(7 downto 0) := "00001010";
	constant B_REG 	: STD_LOGIC_VECTOR(7 downto 0) := "00001011";
	constant C_REG 	: STD_LOGIC_VECTOR(7 downto 0) := "00001100";
	constant ACC1_REG : STD_LOGIC_VECTOR(7 downto 0) := "00000001";
	constant ACC2_REG : STD_LOGIC_VECTOR(7 downto 0) := "00000010";


	signal ROM : rom_type := (
        0 => ADD1_OP & A_REG & x"00" & x"00",
        1 => MOV_OP & A_REG & x"47" & x"00",
        2 => ST_OP & x"0F" & A_REG & x"00",
        3 => MOV_OP & ACC1_REG & x"49" & x"00",
        4 => MOV_OP & ACC2_REG & x"05" & x"00",
        5 => SUB1_OP & A_REG & x"00" & x"00",
        6 => ST_OP & x"AF" & A_REG & x"00",
        7 => LD_OP & C_REG & x"0F" & x"00",
        8 => PRT_OP & x"00" & x"00" & x"00",
        9 => MOV_OP & C_REG & x"47" & x"00",
        10 => JMP_OP & x"00" & x"0C" & x"00",
        11 => PRT_OP & x"00" & x"00" & x"00",
        12 => LD_OP & ACC1_REG & x"AF" & x"00",
        13 => MOV_OP & ACC2_REG & x"05" & x"00",
        14 => ADD1_OP & B_REG & x"00" & x"00",
        15 => MVR_OP & C_REG & B_REG & x"00",
        16 => PRT_OP & x"00" & x"00" & x"00",
        17 => MOV_OP & ACC1_REG & x"4F" & x"00",
        18 => SHL_OP & ACC1_REG & x"01" & x"00",
        19 => SHR_OP & ACC1_REG & x"01" & x"00",
        20 => MOV_OP & ACC2_REG & x"00" & x"00",
        21 => ADD1_OP & C_REG & x"00" & x"00",
        22 => PRT_OP & x"00" & x"00" & x"00",
        23 => MOV_OP & A_REG & x"FF" & x"00",
        24 => MOV_OP & B_REG & x"FF" & x"00",
        25 => ADD2_OP & A_REG & B_REG & x"00",
        26 => JC_OP & x"00" & x"1F" & x"00",
        27 => MOV_OP & C_REG & x"49" & x"00",
        28 => PRT_OP & x"00" & x"00" & x"00",
        29 => MOV_OP & C_REG & x"30" & x"00",
        30 => PRT_OP & x"00" & x"00" & x"00",
        31 => MOV_OP & ACC1_REG & x"AC" & x"00",
        32 => XOR2_OP & A_REG & ACC1_REG & x"00",
        33 => MVR_OP & C_REG & A_REG & x"00",
        34 => PRT_OP & x"00" & x"00" & x"00",
        35 => LD_OP & C_REG & x"0F" & x"00",
        36 => LD_OP & C_REG & x"0F" & x"00",
        37 => PRT_OP & x"00" & x"00" & x"00",
        38 => MOV_OP & ACC1_REG & x"7F" & x"00",
        39 => MOV_OP & ACC2_REG & x"4F" & x"00",
        40 => AND1_OP & C_REG & x"00" & x"00",
        41 => PRT_OP & x"00" & x"00" & x"00",
        42 => MOV_OP & A_REG & x"02" & x"00",
        43 => SHL_OP & A_REG & x"04" & x"00",
        44 => MVR_OP & C_REG & A_REG & x"00",
        45 => MVR_OP & C_REG & A_REG & x"00",
        46 => PRT_OP & x"00" & x"00" & x"00",
        47 => MOV_OP & A_REG & x"00" & x"00",
        48 => JMP_OP & x"00" & x"3B" & x"00",
        49 => MOV_OP & C_REG & x"30" & x"00",
        50 => PRT_OP & x"00" & x"00" & x"00",
        51 => MOV_OP & C_REG & x"30" & x"00",
        52 => PRT_OP & x"00" & x"00" & x"00",
        53 => MOV_OP & C_REG & x"30" & x"00",
        54 => PRT_OP & x"00" & x"00" & x"00",
        55 => MOV_OP & C_REG & x"30" & x"00",
        56 => PRT_OP & x"00" & x"00" & x"00",
        57 => MOV_OP & C_REG & x"30" & x"00",
        58 => PRT_OP & x"00" & x"00" & x"00",
        59 => MOV_OP & C_REG & x"50" & x"00",
        60 => PRT_OP & x"00" & x"00" & x"00",
        61 => JMP_OP & x"00" & x"3E" & x"00",
        62 => MOV_OP & C_REG & x"41" & x"00",
        63 => MOV_OP & C_REG & x"41" & x"00",
        64 => PRT_OP & x"00" & x"00" & x"00",
        65 => INC2_OP & A_REG & A_REG & x"00",
        66 => CMPRROM_OP & A_REG & x"01" & x"00",
        67 => JEB_OP & x"00" & x"3B" & x"00",
        68 => MOV_OP & C_REG & x"4D" & x"00",
        69 => MOV_OP & C_REG & x"4D" & x"00",
        70 => PRT_OP & x"00" & x"00" & x"00",
        71 => MOV_OP & C_REG & x"49" & x"00",
        72 => MOV_OP & C_REG & x"49" & x"00",
        73 => PRT_OP & x"00" & x"00" & x"00",
        74 => MOV_OP & C_REG & x"43" & x"00",
        75 => MOV_OP & C_REG & x"43" & x"00",
        76 => PRT_OP & x"00" & x"00" & x"00",
        77 => MOV_OP & C_REG & x"48" & x"00",
        78 => MOV_OP & C_REG & x"48" & x"00",
        79 => PRT_OP & x"00" & x"00" & x"00",
        80 => MOV_OP & C_REG & x"41" & x"00",
        81 => MOV_OP & C_REG & x"41" & x"00",
        82 => PRT_OP & x"00" & x"00" & x"00",
        83 => MOV_OP & C_REG & x"49" & x"00",
        84 => MOV_OP & C_REG & x"49" & x"00",
        85 => PRT_OP & x"00" & x"00" & x"00",
        86 => IN_OP & C_REG & x"00" & x"00",
        87 => MVR_OP & C_REG & C_REG & x"00",
        88 => PRT_OP & x"00" & x"00" & x"00",
        89 => HLT_OP & x"00" & x"00" & x"00",
        others => (others => '0')
    );

begin
    instr_out <= ROM(to_integer(pc));
end Behavioral;

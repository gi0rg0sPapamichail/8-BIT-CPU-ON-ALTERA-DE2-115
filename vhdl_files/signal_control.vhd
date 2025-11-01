library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity signal_control is
	Port(
		clk				: in STD_LOGIC;
		instruction		: in STD_LOGIC_VECTOR(31 downto 0);
		carry				: in  STD_LOGIC;
		zero				: in  STD_LOGIC;
		lcd_in			: in STD_LOGIC;
		user_input		: in STD_LOGIC_VECTOR(7 downto 0);
		confirm			: in STD_LOGIC;
		acc1_ld			: out STD_LOGIC;
		acc2_ld			: out STD_LOGIC;
		A_ld				: out STD_LOGIC;
		B_ld				: out STD_LOGIC;
		C_ld				: out STD_LOGIC;
		flag_ld			: out STD_LOGIC;
		pc_inc			: out STD_LOGIC;
		pc_ld				: out STD_LOGIC;
		ir_ld				: out STD_LOGIC;
		ram_wr			: out STD_LOGIC;
		ram_addr			: out STD_LOGIC_VECTOR(7 downto 0);
		mux_sel			: out STD_LOGIC_VECTOR(1 downto 0);
		alu_mux_selA	: out STD_LOGIC_VECTOR(1 downto 0);
		alu_mux_selB	: out STD_LOGIC_VECTOR(1 downto 0);
		pc_mux_sel		: out STD_LOGIC_VECTOR(1 downto 0);
		alu_sel			: out STD_LOGIC_VECTOR(3 downto 0);
		jmp				: out STD_LOGIC_VECTOR(15 downto 0);
		var				: out STD_LOGIC_VECTOR(7 downto 0);
		data_bus_sel	: out STD_LOGIC_VECTOR(1 downto 0);
		clr_lcd			: out STD_LOGIC;
		write_lcd		: out STD_LOGIC
	);
end signal_control;
		

architecture Behavioral of signal_control is
	--Resgisters indentifiers
	constant A_REG 	: STD_LOGIC_VECTOR(7 downto 0) := "00001010";
	constant B_REG 	: STD_LOGIC_VECTOR(7 downto 0) := "00001011";
	constant C_REG 	: STD_LOGIC_VECTOR(7 downto 0) := "00001100";
	constant ACC1_REG : STD_LOGIC_VECTOR(7 downto 0) := "00000001";
	constant ACC2_REG : STD_LOGIC_VECTOR(7 downto 0) := "00000010";
	
	--operations
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
	
	--selectors for the multiplexers
	--alu
	constant add_sel 	: STD_LOGIC_VECTOR(3 downto 0) := "0000";
	constant sub_sel 	: STD_LOGIC_VECTOR(3 downto 0) := "0001";
	constant or_sel 	: STD_LOGIC_VECTOR(3 downto 0) := "0010";
	constant and_sel 	: STD_LOGIC_VECTOR(3 downto 0) := "0011";
	constant not_sel 	: STD_LOGIC_VECTOR(3 downto 0) := "0100";
	constant xor_sel 	: STD_LOGIC_VECTOR(3 downto 0) := "0101";
	constant inc_sel 	: STD_LOGIC_VECTOR(3 downto 0) := "0110";
	constant dinc_sel : STD_LOGIC_VECTOR(3 downto 0) := "0111";
	constant shr_sel  : STD_LOGIC_VECTOR(3 downto 0) := "1001";
	constant shl_sel  : STD_LOGIC_VECTOR(3 downto 0) := "1000";
	
	
	
	--data bus
	constant register_mux_sel 	: STD_LOGIC_VECTOR(1 downto 0) := "00";
	constant ram_sel 				: STD_LOGIC_VECTOR(1 downto 0) := "01";
	constant rom_sel 				: STD_LOGIC_VECTOR(1 downto 0) := "10";
	
	--register mux
	constant A_sel 				: STD_LOGIC_VECTOR(1 downto 0) := "00";
	constant B_sel 				: STD_LOGIC_VECTOR(1 downto 0) := "01";
	constant C_sel 				: STD_LOGIC_VECTOR(1 downto 0) := "10";
	constant alu_result_sel 	: STD_LOGIC_VECTOR(1 downto 0) := "11";
	
	--pc mux
	constant ir_sel 		: STD_LOGIC_VECTOR(1 downto 0) := "00";
	constant pc_sel		: STD_LOGIC_VECTOR(1 downto 0) := "01";
	constant jmp_sel		: STD_LOGIC_VECTOR(1 downto 0) := "10";	
	
	--alu inputs
	constant acc1_sel 	: STD_LOGIC_VECTOR(1 downto 0) := "00";
	constant acc2_sel		: STD_LOGIC_VECTOR(1 downto 0) := "01";
	constant A_alu_sel 	: STD_LOGIC_VECTOR(1 downto 0) := "10";
	constant B_alu_sel	: STD_LOGIC_VECTOR(1 downto 0) := "11";
	--end of the selectors for the multiplexers
	
	type state_type is (
		 FETCH1, FETCH2, DECODE,
		 MOV_1, MOV_2,
		 ST_1, ST_2, ST_3,
		 LD_1,
		 alu_1, alu_2,
		 shift, shift2,
		 CMPR_1, CMPROM_1, CMPRAM_1 , CMP_final, CMP_end,
		 JMP_1,
		 lcd_1,
		 IN_1
	);


	signal state 		: state_type := FETCH1;
	signal shifting 	: STD_LOGIC_VECTOR(7 downto 0);
	signal input_ok	: STD_LOGIC := '0';	
	signal data_in		: STD_LOGIC_VECTOR(7 downto 0);
	signal prev_confirm : std_logic := '0';

	
begin
	process(clk, lcd_in)
	begin

	if rising_edge(clk) then
		case state is
			when FETCH1 =>
				state <= FETCH2;
				pc_mux_sel <= pc_sel;
				ir_ld <= '1';
				pc_inc <= '1';
				a_ld <= '0'; -- Clear all loads
				b_ld <= '0';
				c_ld <= '0';
				acc1_ld <= '0';
				acc2_ld <= '0';
				

			when FETCH2 =>
				pc_mux_sel <= ir_sel;
				ir_ld <= '0';
				pc_inc <= '0';
				state <= DECODE;
			
			when DECODE =>
				case instruction(31 downto 24) is
					when MOV_OP  => 
						state <= MOV_1;
						data_bus_sel <= rom_sel;
						var <= instruction(15 downto 8);
						case instruction(23 downto 16) is
							when A_REG => a_ld <= '1';
							when B_REG => b_ld <= '1';
							when C_REG => c_ld <= '1';
							when ACC1_REG => acc1_ld <= '1';
							when ACC2_REG => acc2_ld <= '1';
							when others => state <= FETCH1;
						end case;
						
					when LD_OP   => 
						state <= LD_1;
						data_bus_sel <= ram_sel;
						ram_addr <= instruction(15 downto 8);
						ram_wr <= '0';
						
					
					when ST_OP 	 => 
						state <= ST_1;
						data_bus_sel <= register_mux_sel;
						case instruction(15 downto 8) is
							when A_REG => mux_sel <= A_sel;
							when B_REG => mux_sel <= B_sel;
							when C_REG => mux_sel <= C_sel;
							when others => state <= FETCH1;
						end case;
						ram_addr <= instruction(23 downto 16);
						acc1_ld <= '1';

						
						
					when MVR_OP => 
						state <= MOV_1;
						data_bus_sel <= register_mux_sel;
						case instruction(15 downto 8) is
							when A_REG => mux_sel <= A_sel;
							when B_REG => mux_sel <= B_sel;
							when C_REG => mux_sel <= C_sel;
							when others => state <= FETCH1;
						end case;
						
						case instruction(23 downto 16) is
							when A_REG => a_ld <= '1';
							when B_REG => b_ld <= '1';
							when C_REG => c_ld <= '1';
							when ACC1_REG => acc1_ld <= '1';
							when ACC2_REG => acc2_ld <= '1';
							when others => state <= FETCH1;
						end case;
					
					when ADD1_OP | SUB1_OP | OR1_OP | AND1_OP | NOT1_OP
							| XOR1_OP | INC1_OP | DINC1_OP =>				
						state <= alu_1;
		
						flag_ld <= '1';
						alu_mux_selA <= acc1_sel;
						alu_mux_selB <= acc2_sel;
						data_bus_sel <= register_mux_sel;
						mux_sel <= alu_result_sel;
						
						case instruction(31 downto 24) is
							when ADD1_OP => alu_sel <= add_sel;
							when SUB1_OP => alu_sel <= sub_sel;
							when OR1_OP => alu_sel <= or_sel;
							when AND1_OP => alu_sel <= and_sel;
							when NOT1_OP => alu_sel <= not_sel;
							when XOR1_OP => alu_sel <= xor_sel;
							when INC1_OP => alu_sel <= inc_sel;
							when DINC1_OP => alu_sel <= dinc_sel;
							when others => alu_sel <= add_sel;
						end case;
						
						case instruction(23 downto 16) is
							when A_REG => a_ld <= '1';
							when B_REG => b_ld <= '1';
							when C_REG => c_ld <= '1';
							when ACC1_REG => acc1_ld <= '1';
							when ACC2_REG => acc2_ld <= '1';
							when others => state <= FETCH1;
						end case;
						
					when ADD2_OP | SUB2_OP | OR2_OP | AND2_OP | NOT2_OP
							| XOR2_OP | INC2_OP | DINC2_OP =>				
						state <= alu_1;
						
						flag_ld <= '1';
						data_bus_sel <= register_mux_sel;
						mux_sel <= alu_result_sel;
		
						case instruction(31 downto 24) is
							when ADD2_OP => alu_sel <= add_sel;
							when SUB2_OP => alu_sel <= sub_sel;
							when OR2_OP => alu_sel <= or_sel;
							when AND2_OP => alu_sel <= and_sel;
							when NOT2_OP => alu_sel <= not_sel;
							when XOR2_OP => alu_sel <= xor_sel;
							when INC2_OP => alu_sel <= inc_sel;
							when DINC2_OP => alu_sel <= dinc_sel;
							when others => alu_sel <= add_sel;
						end case;
						
						case instruction(23 downto 16) is
							when A_REG => alu_mux_selA <= A_alu_sel;
							when B_REG => alu_mux_selA <= B_alu_sel;
							when ACC1_REG => alu_mux_selA <= acc1_sel;
							when ACC2_REG => alu_mux_selA <= acc2_sel;
							when others => state <= FETCH1;
						end case;
						
						case instruction(15 downto 8) is
							when A_REG => alu_mux_selB <= A_alu_sel;
							when B_REG => alu_mux_selB <= B_alu_sel;
							when ACC1_REG => alu_mux_selB <= acc1_sel;
							when ACC2_REG => alu_mux_selB <= acc2_sel;
							when others => state <= FETCH1;
						end case;	
						
						case instruction(23 downto 16) is
							when A_REG => a_ld <= '1';
							when B_REG => b_ld <= '1';
							when C_REG => c_ld <= '1';
							when ACC1_REG => acc1_ld <= '1';
							when ACC2_REG => acc2_ld <= '1';
							when others => state <= FETCH1;
						end case;
	
						
					
					when SHR_OP | SHL_OP =>
						state <= shift;
						
						if instruction(31 downto 24) = SHR_OP then
							alu_sel <= shr_sel;
						else
							alu_sel <= shl_sel;
						end if;
						
						flag_ld <= '0';
						
						data_bus_sel <= register_mux_sel;
						mux_sel <= alu_result_sel;
						shifting <= std_logic_vector(unsigned(instruction(15 downto 8)) - 1);
						
						case instruction(23 downto 16) is
							when A_REG => alu_mux_selA <= A_alu_sel; a_ld <= '1';
							when B_REG => alu_mux_selA <= B_alu_sel; b_ld <= '1';
							when ACC1_REG => alu_mux_selA <= acc1_sel; acc1_ld <= '1';
							when ACC2_REG => alu_mux_selA <= acc2_sel; acc2_ld <= '1';
							when others => state <= FETCH1;
						end case;
						
						
						if instruction(15 downto 8) = "00000000" then
							state <= FETCH1;
							
							case instruction(23 downto 16) is
								when A_REG => a_ld <= '0';
								when B_REG => b_ld <= '0';
								when ACC1_REG => acc1_ld <= '0';
								when ACC2_REG => acc2_ld <= '0';
								when others => state <= FETCH1;
							end case;
						end if;
						
						
						
					when CMP_OP =>
						state <= CMP_end;
						flag_ld <= '1';
						data_bus_sel <= register_mux_sel;
						mux_sel <= alu_result_sel;
						
						alu_sel <= sub_sel;
						
						case instruction(23 downto 16) is
							when A_REG => alu_mux_selA <= A_alu_sel;
							when B_REG => alu_mux_selA <= B_alu_sel;
							when ACC1_REG => alu_mux_selA <= acc1_sel;
							when ACC2_REG => alu_mux_selA <= acc2_sel;
							when others => state <= FETCH1;
						end case;
						
						case instruction(15 downto 8) is
							when A_REG => alu_mux_selB <= A_alu_sel;
							when B_REG => alu_mux_selB <= B_alu_sel;
							when ACC1_REG => alu_mux_selB <= acc1_sel;
							when ACC2_REG => alu_mux_selB <= acc2_sel;
							when others => state <= FETCH1;
						end case;
					
					when CMPRR_OP =>
						state <= CMPR_1;
						
						alu_sel <= sub_sel;
						alu_mux_selA <= acc1_sel; -- ACC1 is Source1
						alu_mux_selB <= acc2_sel; -- ACC2 is Source2
						
						data_bus_sel <= register_mux_sel;
						case instruction(23 downto 16) is
							when A_REG => mux_sel <= A_sel; acc1_ld <= '1';
							when B_REG => mux_sel <= B_sel; acc1_ld <= '1';
							when C_REG => mux_sel <= C_sel; acc1_ld <= '1';
							when ACC1_REG => mux_sel <= alu_result_sel; acc1_ld <= '1'; -- assuming acc1 is a source option
							when ACC2_REG => mux_sel <= alu_result_sel; acc1_ld <= '1'; -- assuming acc2 is a source option
							when others => state <= FETCH1; acc1_ld <= '0';
						end case;

						
					when CMPRROM_OP =>
						-- R to ROM
						state <= CMPROM_1; -- Target state for R-ROM comparison logic
						
						alu_sel <= sub_sel;
						alu_mux_selA <= acc1_sel; -- ACC1 is Source1
						alu_mux_selB <= acc2_sel; -- ACC2 is Source2
						
						-- Load ACC1 with the source register (instruction(23 downto 16))
						data_bus_sel <= register_mux_sel;
						case instruction(23 downto 16) is
							when A_REG => mux_sel <= A_sel; acc1_ld <= '1';
							when B_REG => mux_sel <= B_sel; acc1_ld <= '1';
							when C_REG => mux_sel <= C_sel; acc1_ld <= '1';
							when ACC1_REG => mux_sel <= alu_result_sel; acc1_ld <= '0'; 
							when ACC2_REG => mux_sel <= alu_result_sel; acc1_ld <= '0';
							when others => state <= FETCH1; acc1_ld <= '0';
						end case;
						
					when CMPRRAM_OP =>
						-- R to RAM
						state <= CMPRAM_1; -- Target state for R-RAM comparison logic
						
						alu_sel <= sub_sel;
						alu_mux_selA <= acc1_sel; -- ACC1 is Source1
						alu_mux_selB <= acc2_sel; -- ACC2 is Source2
						
						-- Load ACC1 with the source register (instruction(23 downto 16))
						data_bus_sel <= register_mux_sel;
						case instruction(23 downto 16) is
							when A_REG => mux_sel <= A_sel; acc1_ld <= '1';
							when B_REG => mux_sel <= B_sel; acc1_ld <= '1';
							when C_REG => mux_sel <= C_sel; acc1_ld <= '1';
							when ACC1_REG => mux_sel <= alu_result_sel; acc1_ld <= '0'; 
							when ACC2_REG => mux_sel <= alu_result_sel; acc1_ld <= '0';
							when others => state <= FETCH1; acc1_ld <= '0';
						end case;
										
					when CMPROMR_OP =>
						-- ROM to R
						state <= CMPROM_1;
						
						alu_sel <= sub_sel;
						alu_mux_selA <= acc1_sel; -- ACC1 is Source1
						alu_mux_selB <= acc2_sel; -- ACC2 is Source2
						
						data_bus_sel <= rom_sel;
						var <= instruction(23 downto 16);
						acc1_ld <= '1';
						mux_sel <= alu_result_sel; -- The data from ROM will be on the data bus
						
					when CMPROMROM_OP =>
						-- ROM to ROM
						state <= CMPROM_1;
						
						alu_sel <= sub_sel;
						alu_mux_selA <= acc1_sel; -- ACC1 is Source1
						alu_mux_selB <= acc2_sel; -- ACC2 is Source2
						
						data_bus_sel <= rom_sel;
						var <= instruction(23 downto 16);
						acc1_ld <= '1';
						mux_sel <= alu_result_sel;
						
					when CMPROMRAM_OP =>
						-- ROM to RAM
						state <= CMPRAM_1;
						
						alu_sel <= sub_sel;
						alu_mux_selA <= acc1_sel; -- ACC1 is Source1
						alu_mux_selB <= acc2_sel; -- ACC2 is Source2
						
						data_bus_sel <= rom_sel;
						var <= instruction(23 downto 16);
						acc1_ld <= '1';
						mux_sel <= alu_result_sel;
						
					when CMPRAMR_OP =>
						-- RAM to R
						state <= CMPRAM_1;
						
						alu_sel <= sub_sel;
						alu_mux_selA <= acc1_sel; -- ACC1 is Source1
						alu_mux_selB <= acc2_sel; -- ACC2 is Source2
						
						data_bus_sel <= ram_sel;
						ram_addr <= instruction(23 downto 16);
						acc1_ld <= '1';
						mux_sel <= alu_result_sel;
						
					when CMPRAMROM_OP =>
						-- RAM to ROM
						state <= CMPROM_1;
						
						alu_sel <= sub_sel;
						alu_mux_selA <= acc1_sel; -- ACC1 is Source1
						alu_mux_selB <= acc2_sel; -- ACC2 is Source2
						
						data_bus_sel <= ram_sel;
						ram_addr <= instruction(23 downto 16);
						acc1_ld <= '1';
						mux_sel <= alu_result_sel;
						
					when CMPRAMRAM_OP =>
						-- RAM to RAM
						state <= CMPRAM_1;
						
						alu_sel <= sub_sel;
						alu_mux_selA <= acc1_sel; -- ACC1 is Source1
						alu_mux_selB <= acc2_sel; -- ACC2 is Source2
						
						data_bus_sel <= ram_sel;
						ram_addr <= instruction(23 downto 16);
						acc1_ld <= '1';
						mux_sel <= alu_result_sel;
						
					when JMP_OP =>
						state <= JMP_1;
						jmp <= instruction(23 downto 8);
						pc_mux_sel <= jmp_sel;
						pc_ld <= '1';
					
					when JE_OP | JEA_OP | JEB_OP | JA_OP | JB_OP =>
						state <= FETCH1;

						-- Condition for JE, JEA, JEB (zero = '1' carry = '0')
						if (instruction(31 downto 24) = JE_OP or instruction(31 downto 24) = JEA_OP or instruction(31 downto 24) = JEB_OP) and zero = '1' and carry = '0' then
						  state <= JMP_1;
						  jmp <= instruction(23 downto 8);
						  pc_mux_sel <= jmp_sel;
						  pc_ld <= '1';
						end if;

						-- Condition for JA, JEA (zero = x and carry = '0')
						if (instruction(31 downto 24) = JA_OP or instruction(31 downto 24) = JEA_OP) and carry = '0' then
						  state <= JMP_1;
						  jmp <= instruction(23 downto 8);
						  pc_mux_sel <= jmp_sel;
						  pc_ld <= '1';
						end if;

						-- Condition for JA, JEA (zero = x and carry = '1')
						if (instruction(31 downto 24) = JB_OP or instruction(31 downto 24) = JEB_OP) and carry = '1' then
						  state <= JMP_1;
						  jmp <= instruction(23 downto 8);
						  pc_mux_sel <= jmp_sel;
						  pc_ld <= '1';
						end if;
					
					when JC_OP =>
						state <= FETCH1;
						if carry = '1' then
						  state <= JMP_1;
						  jmp <= instruction(23 downto 8);
						  pc_mux_sel <= jmp_sel;
						  pc_ld <= '1';
						end if;
					
					when JZ_OP =>
						state <= FETCH1;
						if zero = '1' then
						  state <= JMP_1;
						  jmp <= instruction(23 downto 8);
						  pc_mux_sel <= jmp_sel;
						  pc_ld <= '1';
						end if;
						
					when JCZ_OP =>
						state <= FETCH1;
						if carry = '1' and zero = '1' then
						  state <= JMP_1;
						  jmp <= instruction(23 downto 8);
						  pc_mux_sel <= jmp_sel;
						  pc_ld <= '1';
						end if;
						
					when IN_OP =>
						if confirm = '0' then
							prev_confirm <= '1';
						elsif prev_confirm = '1' and confirm = '1' then
							prev_confirm <= '0';
							var <= user_input;
							state <= IN_1;
						else
							state <= DECODE;
						end if;

									
						
					when CLR_OP =>
						if lcd_in = '1' then
							state <= lcd_1;
							
							write_lcd <= '0';
							clr_lcd <= '1';
						end if;
						
					when PRT_OP =>
						if lcd_in = '1' then
							state <= lcd_1;
							
							write_lcd <= '1';
							clr_lcd <= '0';
						end if;
						
					when HLT_OP =>
						acc1_ld			<= '0';
						acc2_ld			<= '0';
						A_ld				<= '0';
						B_ld				<= '0';
						C_ld				<= '0';
						flag_ld			<= '0';
						pc_inc			<= '0';
						pc_ld				<= '0';
						ir_ld				<= '0';
						ram_wr			<= '0';
						ram_addr			<= "00000000";
						mux_sel			<= "00";
						alu_mux_selA	<= "00";
						alu_mux_selB	<= "00";
						pc_mux_sel		<= "00";
						alu_sel			<= "0000";
						jmp				<= "0000000000000000";
						var				<= "00000000";
						data_bus_sel	<= "00";
						clr_lcd			<= '0';
						write_lcd		<= '0';

					
					when others => state <= FETCH1;					
				end case;
				
			-----------DATA FLOW----------
			
			when MOV_1 =>
				state <= FETCH1;
				case instruction(23 downto 16) is
					when A_REG => a_ld <= '0';
					when B_REG => b_ld <= '0';
					when C_REG => c_ld <= '0';
					when ACC1_REG => acc1_ld <= '0';
					when ACC2_REG => acc2_ld <= '0';
					when others => state <= FETCH1;
				end case;				
				
			
			when ST_1 =>
				state <= ST_2;
				acc1_ld <= '0';
			
			when ST_2 =>
				state <= ST_3;
				ram_wr <= '1';
			
			when ST_3 =>
				state <= FETCH1;
				ram_wr <= '0';
			
			when LD_1 =>
				state <= MOV_1;
				case instruction(23 downto 16) is
					when A_REG => a_ld <= '1';
					when B_REG => b_ld <= '1';
					when C_REG => c_ld <= '1';
					when ACC1_REG => acc1_ld <= '1';
					when ACC2_REG => acc2_ld <= '1';
					when others => state <= FETCH1;
				end case;
			------ALU PART-------
			
			when alu_1 =>
				state <= FETCH1;
				case instruction(23 downto 16) is
					when A_REG => a_ld <= '0';
					when B_REG => b_ld <= '0';
					when C_REG => c_ld <= '0';
					when ACC1_REG => acc1_ld <= '0';
					when ACC2_REG => acc2_ld <= '0';
					when others => state <= FETCH1;
				end case;
				flag_ld <= '0';
								
			
			when shift =>
			 if unsigned(shifting) = 0 then
				  -- finished
				  state <= FETCH1;
				  case instruction(23 downto 16) is
						when A_REG => a_ld <= '0';
						when B_REG => b_ld <= '0';
						when ACC1_REG => acc1_ld <= '0';
						when ACC2_REG => acc2_ld <= '0';
						when others => null;
				  end case;
			 else
				shifting <= std_logic_vector(signed(shifting) - 1);
			 end if;
			 
				
				
			-----------Bit shifting---------------
			
			-----------flagg/jumps--------------
			-----------flagg/jumps--------------
			when CMPR_1 =>
				state <= CMP_final;
				
				acc1_ld <= '0'; -- Clear the load signal for ACC1!
				
				-- Now load ACC2 with the second operand (Source2)
				data_bus_sel <= register_mux_sel;
				case instruction(15 downto 8) is
					when A_REG => mux_sel <= A_sel; acc2_ld <= '1';
					when B_REG => mux_sel <= B_sel; acc2_ld <= '1';
					when C_REG => mux_sel <= C_sel; acc2_ld <= '1';
					when ACC1_REG => acc2_ld <= '0';
					when ACC2_REG => acc2_ld <= '0';
					when others => state <= FETCH1; acc2_ld <= '0';
				end case;
				
			when CMPROM_1 =>
				state <= CMP_final;
				
				acc1_ld <= '0'; -- Clear the load signal for ACC1!
				
				-- Now load ACC2 with the second operand (ROM)
				var <= instruction(15 downto 8);
				data_bus_sel <= rom_sel;
				
				acc2_ld <= '1';
				mux_sel <= alu_result_sel; -- Data from ROM on bus, ready for ACC2
				
			when CMPRAM_1 =>
				state <= CMP_final;
				
				acc1_ld <= '0'; -- Clear the load signal for ACC1!
				
				-- Now load ACC2 with the second operand (RAM)
				ram_addr <= instruction(15 downto 8);
				data_bus_sel <= ram_sel;
				acc2_ld <= '1';
				mux_sel <= alu_result_sel; -- Data from RAM on bus, ready for ACC2
				
						
			when CMP_final =>
				state <= CMP_end;
				
				acc2_ld <= '0'; -- Clear the load signal for ACC2!
				flag_ld <= '1'; -- Set flag load
				mux_sel <= alu_result_sel;
				-- Setup ALU for comparison (subtraction for flags)
				
				
				
				-- Note: The ALU output is not written back to any register (no R_LD signal active).
				-- Its only effect is setting the flags.
				
			
			when CMP_end =>
				state <= FETCH1;
				flag_ld <= '0'; -- Clear flag load
			
			when JMP_1 =>
				state <= FETCH1;
				pc_ld <= '0';
				
			when lcd_1 =>
				write_lcd <= '0';
			  clr_lcd <= '0';
				if lcd_in = '1' then
					  write_lcd <= '0';
					  clr_lcd <= '0';
					  state <= FETCH1;
				 end if;
				 
			when IN_1 =>
			
			 data_bus_sel <= rom_sel;
			 case instruction(23 downto 16) is
				  when A_REG   => a_ld <= '1';
				  when B_REG   => b_ld <= '1';
				  when C_REG   => c_ld <= '1';
				  when ACC1_REG=> acc1_ld <= '1';
				  when ACC2_REG=> acc2_ld <= '1';
				  when others  => null;
			 end case;

    -- next cycle clear loads and return to fetch
    state <= FETCH1;

				
			when others => state <= FETCH1;
				
		end case;
	end if;
	end process;
	
	
	
end Behavioral;
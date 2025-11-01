
keywords = {
    "MOV": ["MOV_OP", "LD_OP", "ST_OP", "MVR_OP"],

    "ADD": ["ADD1_OP", "ADD2_OP"],
    "SUB": ["SUB1_OP", "SUB2_OP"],
    "OR": ["OR1_OP", "OR2_OP"],
    "AND": ["AND1_OP", "AND2_OP"],
    "XOR": ["XOR1_OP", "XOR2_OP"],
    "NOT": ["NOT1_OP", "NOT2_OP"],
    "INC": ["INC1_OP", "INC2_OP"],
    "DINC": ["DINC1_OP", "DINC2_OP"],

    "SHR": "SHR_OP",
    "SHL": "SHL_OP",

    "CMP": ["CMP_OP", "CMPRR_OP", "CMPRROM_OP", "CMPRRAM_OP", "CMPROMR_OP", "CMPROMROM_OP", "CMPROMRAM_OP", "CMPRAMR_OP", "CMPRAMROM_OP", "CMPRAMRAM_OP"],

    "JMP": "JMP_OP",
    "JE": "JE_OP",
    "JA": "JA_OP",
    "JAE": "JEA_OP",
    "JB": "JB_OP",
    "JBE": "JEB_OP",
    "JC": "JC_OP",
    "JZ": "JZ_OP",
    "JCZ": "JCZ_OP",

    "IN": "IN_OP",
    "PRT": "PRT_OP",
    "CLR": "CLR_OP",
    "HLT": "HLT_OP",
}

registers = {
    'A': "A_REG",
    'B': "B_REG",
    'C': "C_REG",
    "ACC1": "ACC1_REG",
    "ACC2": "ACC2_REG",
}

# variable name : address value
ram_vars = {}

#for jumps
jumpers = {}

VHDL_FILE_START = """library IEEE;
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


	signal ROM : rom_type := (\n"""


END_VHDL_FILE = """        others => (others => '0')
    );

begin
    instr_out <= ROM(to_integer(pc));
end Behavioral;
"""


def has_letters_except(value, allowed=('x', 'b', ':')):
    value = value.lower()
    allowed = [a.lower() for a in allowed]
    for ch in value:
        if ch.isalpha() and ch not in allowed:
            return True
    return False

def get_hex_or_bits(value):
    value = value.lower()
    if value.startswith('x'):  # Hex
        hex_digits = value[1:]
        if len(hex_digits) != 2 or any(c not in '0123456789abcdef' for c in hex_digits):
            raise ValueError(f"Invalid 8-bit hex value: {value}")
        return int(hex_digits, 16)
    elif value.startswith('b'):  # Binary
        bin_digits = value[1:]
        if len(bin_digits) != 8 or any(c not in '01' for c in bin_digits):
            raise ValueError(f"Invalid 8-bit binary value: {value}")
        return int(bin_digits, 2)
    else:  # Decimal
        ivalue = int(value)
        if not (0 <= ivalue <= 255):
            raise ValueError(f"Decimal value out of 8-bit range: {value}")
        return ivalue



def remove_comments(line):
    if ';' in line:
        line = line.split(';')[0]
    return line

############ MOV
def get_mov_opcode(dest, src):

    if src == "ACC1" or src == "ACC2":
        raise ValueError("MOV instruction cannot use ACC1 or ACC2 as source")

    dest_is_ram = dest.startswith('*')
    src_is_ram = src.startswith('*')
    dest_is_reg = dest in registers
    src_is_reg = src in registers

    src_l = src.lower()
    
    if dest_is_reg and src_is_reg:
        return "MVR_OP"      # reg <- reg
    elif dest_is_reg and (src_l.isdigit() or src_l.startswith(('x', 'b'))):
        return "MOV_OP"      # reg <- immediate
    elif dest_is_reg and src_is_ram:
        return "LD_OP"       # reg <- *ram
    elif dest_is_ram and src_is_reg:
        return "ST_OP"       # *ram <- reg
    else:
        raise ValueError(f"Unknown MOV pattern: {dest}, {src}")


def to_vhdl_operand(op):
    op = op.strip()
    op_l = op.lower()

    # pointer (RAM access)
    if op_l.startswith('*'):
        value = op_l[0:]  # remove '*'
        if value in ram_vars:
            return f'x"{ram_vars[value]:02X}"'
        if value.startswith('x'):
            value = get_hex_or_bits(value[1:])
            return f'x"{int(value, 16):02X}"'
        elif value.startswith('b'):
            value = get_hex_or_bits(value[1:])
            return f'x"{int(value, 2):02X}"'
        else:
            return f'x"{int(value):02X}"'

    # variable stored in RAM
    if op_l in ram_vars:
        return f'x"{ram_vars[op_l]:02X}"'

    # register
    if op in registers:
        return registers[op]

    # immediate value
    if op_l.startswith('x'):
        get_hex_or_bits(op_l)# we do this just to throw the error if its wrong hex
        return f'x"{int(op_l[1:], 16):02X}"'
    elif op_l.startswith('b'):
        get_hex_or_bits(op_l)# we do this just to throw the error if its wrong bin
        return f'x"{int(op_l[1:], 2):02X}"'
    else:
        return f'x"{int(op_l):02X}"'


############ ARITHMETIC
arithmetic_ops = {
    "ADD": ["ADD1_OP", "ADD2_OP"],
    "SUB": ["SUB1_OP", "SUB2_OP"],
    "OR":  ["OR1_OP", "OR2_OP"],
    "AND": ["AND1_OP", "AND2_OP"],
    "XOR": ["XOR1_OP", "XOR2_OP"],
    "NOT": ["NOT1_OP", "NOT2_OP"],
    "INC": ["INC1_OP", "INC2_OP"],
    "DINC":["DINC1_OP","DINC2_OP"],
}

def get_arith_opcode(op, operands):
    operands = [x.strip().upper() for x in operands]
    
    if len(operands) == 1:
        return arithmetic_ops[op][0]  # single-operand opcode
    elif len(operands) == 2:
        # C is forbidden in two-operand form
        if 'C' in operands:
            raise ValueError(f"Register C is not allowed in two-operand {op}")
        return arithmetic_ops[op][1]  # two-operand opcode
    else:
        raise ValueError(f"Invalid number of operands for {op}: {operands}")

def assemble_arith_vhdl(line, index):
    line = line.strip().upper()
    parts = line.split(None, 1)
    op = parts[0]
    
    if len(parts) < 2:
        raise ValueError(f"No operands provided for {op}")
    
    operands = [x.strip() for x in parts[1].split(',')]
    
    opcode = get_arith_opcode(op, operands)
    
    dest_vhdl = registers[operands[0]]  # first operand always
    if len(operands) == 1:
        src_vhdl = 'x"00"'
    else:
        src_vhdl = registers[operands[1]]  # second operand
    
    vhdl_line = f'        {index} => {opcode} & {dest_vhdl} & {src_vhdl} & x"00",\n'
    return vhdl_line




def assemble_mov_vhdl(line, index):
    line = line.strip().upper()
    if not line.startswith("MOV"):
        raise ValueError("Line is not a MOV instruction")

    # remove 'MOV' and split operands
    args = line[4:]  # remove first 4 chars ('MOV ')
    dest, src = [x.strip() for x in args.split(",")]

    opcode = get_mov_opcode(dest, src)
    dest_vhdl = to_vhdl_operand(dest)
    src_vhdl = to_vhdl_operand(src)

    # 32-bit instruction: 8-bit opcode + 8-bit dest + 8-bit src + 8-bit zeros
    vhdl_line = f'        {index} => {opcode} & {dest_vhdl} & {src_vhdl} & x"00",\n'
    return vhdl_line


############# BIT shifting
shift_ops = {
    "SHL": "SHL_OP",
    "SHR": "SHR_OP",
}

def assemble_shift_vhdl(line, index):
    """
    line: 'SHL A, 3' or 'SHR B, x0F'
    returns VHDL ROM line like: 0 => SHL_OP & A_REG & x"03" & x"00",
    """
    line = line.strip().upper()
    parts = line.split(None, 1)
    op = parts[0]

    if len(parts) < 2:
        raise ValueError(f"No operands provided for {op}")

    operands = [x.strip() for x in parts[1].split(',')]
    if len(operands) != 2:
        raise ValueError(f"{op} requires exactly 2 operands")

    reg, value = operands

    if reg == "C":
        raise ValueError(f"Register C is not allowed in {op}")

    if reg not in registers:
        raise ValueError(f"Invalid register: {reg}")

    reg_vhdl = registers[reg]

    # convert value to VHDL literal
    value_l = value.lower()
    if value_l.startswith('x'):
        val_vhdl = f'x"{int(value_l[1:], 16):02X}"'
    elif value_l.startswith('b'):
        val_vhdl = f'x"{int(value_l[1:], 2):02X}"'
    else:
        val_vhdl = f'x"{int(value_l):02X}"'

    vhdl_line = f'        {index} => {shift_ops[op]} & {reg_vhdl} & {val_vhdl} & x"00",\n'
    return vhdl_line


########## COMPARE 
def operand_type(op):
    op = op.strip().upper()
    if op in ("A", "B", "ACC1", "ACC2"):
        return "R"
    if op == "C":
        return "C"
    if op.startswith("*"):
        return "RAM"
    elif op.startswith('X') or op.startswith('B') or op.isdigit(): 
        return "ROM"
    else: 
        raise ValueError(f"Unknown operand type: {op}")


def assemble_cmp_vhdl(line, index):
    line = line.strip().upper()
    parts = line.split(None, 1)
    if len(parts) < 2:
        raise ValueError("No operands provided for CMP")
    
    operands = [x.strip() for x in parts[1].split(",")]
    if len(operands) != 2:
        raise ValueError("CMP needs exactly 2 operands")

    op1_type = operand_type(operands[0])
    op2_type = operand_type(operands[1])

    # Detect correct opcode
    if op1_type == "C" or op2_type == "C":
        if op1_type == "C":
            op1_type = "R"
        if op2_type == "C":
            op2_type = "R"

        opcode_map = {
            ("R", "R"): "CMPRR_OP",
            ("R", "ROM"): "CMPRROM_OP",
            ("R", "RAM"): "CMPRRAM_OP",
            ("ROM", "R"): "CMPROMR_OP",
            ("ROM", "ROM"): "CMPROMROM_OP",
            ("ROM", "RAM"): "CMPROMRAM_OP",
            ("RAM", "R"): "CMPRAMR_OP",
            ("RAM", "ROM"): "CMPRAMROM_OP",
            ("RAM", "RAM"): "CMPRAMRAM_OP",
        }
        opcode = opcode_map.get((op1_type, op2_type))
        if opcode is None:
            raise ValueError(f"Unsupported CMP operands: {operands}")
    else:
        opcode_map = {
            ("R", "R"): "CMP_OP",
            ("R", "ROM"): "CMPRROM_OP",
            ("R", "RAM"): "CMPRRAM_OP",
            ("ROM", "R"): "CMPROMR_OP",
            ("ROM", "ROM"): "CMPROMROM_OP",
            ("ROM", "RAM"): "CMPROMRAM_OP",
            ("RAM", "R"): "CMPRAMR_OP",
            ("RAM", "ROM"): "CMPRAMROM_OP",
            ("RAM", "RAM"): "CMPRAMRAM_OP",
        }
        opcode = opcode_map.get((op1_type, op2_type))
        if opcode is None:
            raise ValueError(f"Unsupported CMP operands: {operands}")

    # Convert operands to VHDL
    def to_vhdl(op):
        op_l = op.lower()
        if op_l.startswith("*"):
            value = op_l
            if value in ram_vars:
                return f'x"{ram_vars[value]:02X}"'
            if value[1:].startswith('x'):
                return f'x"{int(value[2:],16):02X}"'
            elif value[1:].startswith('b'):
                return f'x"{int(value[2:],2):02X}"'
            else:
                return f'x"{int(value[1:]):02X}"'
        if op in registers:
            return registers[op]
        if op_l.startswith('x'):
            return f'x"{int(op_l[1:],16):02X}"'
        elif op_l.startswith('b'):
            return f'x"{int(op_l[1:],2):02X}"'
        else:
            return f'x"{int(op_l):02X}"'

    dest_vhdl = to_vhdl(operands[0])
    src_vhdl  = to_vhdl(operands[1])

    vhdl_line = f'        {index} => {opcode} & {dest_vhdl} & {src_vhdl} & x"00",\n'
    return vhdl_line

############ JUMPS

jump_format = ["JA", "JE", "JB", "JAE", "JBE", "JC", "JZ", "JCZ", "JMP"]

def to_vhdl_address(value):
    value = int(value) & 0xFFFF
    high = (value >> 8) & 0xFF
    low = value & 0xFF
    return f'x"{high:02X}" & x"{low:02X}"'

def assemble_jump_vhdl(line, index):
    line = line.strip().upper()
    parts = line.split(None)

    if len(parts) > 2:
        raise ValueError("Invalid jump instruction format it takes only one argument")
    
    opcode = keywords.get(parts[0])
    label = parts[1].strip().lower()

    if label not in jumpers:
        raise ValueError(f"Undefined jump label: {label}")
    
    address = to_vhdl_address(jumpers[label])
    
    vhdl_line = f'        {index} => {opcode} & {address} & x"00",\n'
    
    return vhdl_line


############## USER INPUT
def assemble_input_vhdl(line, index):
    line = line.strip().upper()
    parts = line.split(None)

    if len(parts) != 2:
        raise ValueError("IN instruction requires exactly one operand")

    dest = parts[1].strip()

    if dest in registers:
        dest =  registers[dest]
    else:
        raise ValueError(f"Invalid destination for IN instruction: {dest}. \nONLY A REGISTER CAN BE AN INPUT")

    opcode = keywords.get("IN")

    vhdl_line = f'        {index} => {opcode} & {dest} & x"00" & x"00",\n'

    return vhdl_line


################## PRINT TO LCD
def assemble_print_vhdl(line, index):
    line = line.strip().upper()
    parts = line.split(None)

    if len(parts) != 1:
        raise ValueError("PRT instruction takes no operands")
    
    opcode = keywords.get("PRT")

    vhdl_line = f'        {index} => {opcode} & x"00" & x"00" & x"00",\n'

    return vhdl_line

############## CLEAR LCD
def assemble_clear_vhdl(line, index):
    line = line.strip().upper()
    parts = line.split(None)

    if len(parts) != 1:
        raise ValueError("CLR instruction takes no operands")
    
    opcode = keywords.get("CLR")

    vhdl_line = f'        {index} => {opcode} & x"00" & x"00" & x"00",\n'

    return vhdl_line


################ Terminate program
def assemble_halt_vhdl(line, index):
    line = line.strip().upper()
    parts = line.split(None)

    if len(parts) != 1:
        raise ValueError("HLT instruction takes no operands")
    
    opcode = keywords.get("HLT")

    vhdl_line = f'        {index} => {opcode} & x"00" & x"00" & x"00",\n'

    return vhdl_line


with open("program.txt", "r") as f:


    i = 0
    j = 0
    for line in f:
        j += 1
        line = remove_comments(line).strip().upper()
        if not line:
            continue  # skip empty lines
        elif line.startswith('*'):
            continue  # skip variable definitions
        
        elif line.startswith('-'):
            line = line.replace("-", "").strip()
            jump = line.split()
            if len(jump) > 1:
                print(f"Error: Invalid jump label format \n line {j}: {line}")
                exit(0)
            jumpers[jump[0].lower()] = i 
            continue # Since the jump clarification isnt a command the index i must not be inremented

        i += 1


with open("program.txt", "r") as f, open("py_rom.vhdl", "w") as vhdl:
    vhdl.write(VHDL_FILE_START)
    i = 0
    j = 0
    try:
        for line in f:
            j += 1
            line = remove_comments(line).strip().upper()
            if not line:
                continue  # skip empty lines

            # ---- Variable definition ----
            if line.startswith('*'):
                line = line.replace(" ", "")
                var_name, value = line.split(':')
                value = value.strip().lower()
                if has_letters_except(value, ('x','b')) and value[0] not in ('x','b'):
                    raise ValueError(f"Invalid variable address format: {value}")
                if value.startswith('x'):
                    value = get_hex_or_bits(value)
                elif value.startswith('b'):
                    value = get_hex_or_bits(value)
                else:
                    value = int(value)
                ram_vars[var_name.strip().lower()] = value
                continue  # do NOT increment i

            # ---- MOV instruction ----
            if line.startswith("MOV"):
                vhdl_line = assemble_mov_vhdl(line, i)
                vhdl.write(vhdl_line)

            # ---- Arithmetic instruction ----
            elif any(line.startswith(op) for op in arithmetic_ops):
                vhdl_line = assemble_arith_vhdl(line, i)
                vhdl.write(vhdl_line)

            # ---- Shift instruction ----
            elif any(line.startswith(op) for op in shift_ops):
                vhdl_line = assemble_shift_vhdl(line, i)
                vhdl.write(vhdl_line)
            
            # ---- Compare instruction ----
            elif line.startswith("CMP"):
                vhdl_line = assemble_cmp_vhdl(line, i)
                vhdl.write(vhdl_line)

            #---- Jump labels ----
            elif line.startswith('-'):
                continue  # jump label, already processed

            # ---- Jump instruction ----
            elif any(line.startswith(op) for op in jump_format):
                vhdl_line = assemble_jump_vhdl(line, i)
                vhdl.write(vhdl_line)

            # ---- Input instruction ----
            elif line.startswith("IN"):
                vhdl_line = assemble_input_vhdl(line, i)
                vhdl.write(vhdl_line)

            # ---- Print instruction ----
            elif line.startswith("PRT"):
                vhdl_line = assemble_print_vhdl(line, i)
                vhdl.write(vhdl_line)
            
            # ---- Clear instruction ----
            elif line.startswith("CLR"):
                vhdl_line = assemble_clear_vhdl(line, i)
                vhdl.write(vhdl_line)
            
            # ---- Halt instruction ----
            elif line.startswith("HLT"):
                vhdl_line = assemble_halt_vhdl(line, i)
                vhdl.write(vhdl_line)
            else:
                raise ValueError(f"Unknown instruction: {line}")

            # Increment index only for actual instructions
            i += 1

        vhdl.write(END_VHDL_FILE)
    except Exception as e:
        print(f"{e} \n line {j}: {line}")
        exit(0)



print(ram_vars)
print(jumpers)


print("Assembly completed successfully. Output written to py_rom.vhdl")

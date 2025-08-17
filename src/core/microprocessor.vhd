library ieee;
use ieee.std_logic_1164.all;

entity microprocessor is
    port (
        CLK        : in  std_logic;
        Reset      : in  std_logic;
        CPU_Output : out std_logic_vector(7 downto 0)
    );
end entity microprocessor;

architecture Structural of microprocessor is

    -- Component Declarations
    component alu_8bit is
        port (
            Operand1, Operand2 : in  std_logic_vector(7 downto 0); Opcode : in  std_logic_vector(3 downto 0); Result : out std_logic_vector(7 downto 0);
            Cout_flag, V_flag, Z_flag, N_flag : out std_logic
        );
    end component;
    component register_file is
        port (
            CLK:in std_logic; RegWrite:in std_logic; ReadAddr1:in std_logic_vector(2 downto 0); ReadAddr2:in std_logic_vector(2 downto 0); WriteAddr:in std_logic_vector(2 downto 0); WriteData:in std_logic_vector(7 downto 0);
            ReadData1:out std_logic_vector(7 downto 0); ReadData2:out std_logic_vector(7 downto 0); ReadAddr3:in std_logic_vector(2 downto 0); ReadData3:out std_logic_vector(7 downto 0)
        );
    end component;
    component instruction_rom is port (Address:in std_logic_vector(7 downto 0); Instruction:out std_logic_vector(15 downto 0)); end component;
    component program_counter is port (CLK:in std_logic; Reset:in std_logic; PC_Load:in std_logic; PC_Increment:in std_logic; Jump_Address_in:in std_logic_vector(7 downto 0); PC_Address_out:out std_logic_vector(7 downto 0)); end component;
    component status_register is port (CLK:in std_logic; Reset:in std_logic; Flags_WriteEnable:in std_logic; Flags_in:in std_logic_vector(3 downto 0); Flags_out:out std_logic_vector(3 downto 0)); end component;
    component control_unit is port (Instruction_in:in std_logic_vector(15 downto 0); ALU_Opcode:out std_logic_vector(3 downto 0); RegWrite:out std_logic; Flags_WriteEnable:out std_logic; PC_Increment:out std_logic); end component;

    -- Internal Signals (Buses)
    signal s_pc_address     : std_logic_vector(7 downto 0);
    signal s_instruction    : std_logic_vector(15 downto 0);
    signal s_rd_addr        : std_logic_vector(2 downto 0);
    signal s_rs1_addr       : std_logic_vector(2 downto 0);
    signal s_rs2_addr       : std_logic_vector(2 downto 0);
    signal s_reg_read_data1 : std_logic_vector(7 downto 0);
    signal s_reg_read_data2 : std_logic_vector(7 downto 0);
    signal s_alu_result     : std_logic_vector(7 downto 0);
    signal s_alu_flags      : std_logic_vector(3 downto 0);
    signal s_status_reg_out : std_logic_vector(3 downto 0);
    signal s_alu_opcode     : std_logic_vector(3 downto 0);
    signal s_reg_write      : std_logic;
    signal s_flags_write    : std_logic;
    signal s_pc_increment   : std_logic;
    signal s_forwarded_op1  : std_logic_vector(7 downto 0);
    signal s_forwarded_op2  : std_logic_vector(7 downto 0);

begin
    -- Decode register addresses from the instruction bus
    s_rd_addr  <= s_instruction(11 downto 9);
    s_rs1_addr <= s_instruction(8 downto 6);
    s_rs2_addr <= s_instruction(5 downto 3);

    -- Data Forwarding Logic to resolve Read-After-Write hazards
    s_forwarded_op1 <= s_alu_result when (s_reg_write = '1' and s_rd_addr = s_rs1_addr) else s_reg_read_data1;
    s_forwarded_op2 <= s_alu_result when (s_reg_write = '1' and s_rd_addr = s_rs2_addr) else s_reg_read_data2;

    -- Instantiate all CPU components
    PC_unit: program_counter
        port map (
            CLK             => CLK,
            Reset           => Reset,
            PC_Load         => '0',
            PC_Increment    => s_pc_increment,
            Jump_Address_in => (others => '0'),
            PC_Address_out  => s_pc_address
        );

    IROM_unit: instruction_rom
        port map (
            Address     => s_pc_address,
            Instruction => s_instruction
        );

    CU_unit: control_unit
        port map (
            Instruction_in    => s_instruction,
            ALU_Opcode        => s_alu_opcode,
            RegWrite          => s_reg_write,
            Flags_WriteEnable => s_flags_write,
            PC_Increment      => s_pc_increment
        );

    REG_unit: register_file
        port map (
            CLK        => CLK,
            RegWrite   => s_reg_write,
            ReadAddr1  => s_rs1_addr,
            ReadAddr2  => s_rs2_addr,
            WriteAddr  => s_rd_addr,
            WriteData  => s_alu_result,
            ReadData1  => s_reg_read_data1,
            ReadData2  => s_reg_read_data2,
            ReadAddr3  => "111", -- Permanently address Register 7
            ReadData3  => CPU_Output
        );

    ALU_unit: alu_8bit
        port map (
            Operand1  => s_forwarded_op1,
            Operand2  => s_forwarded_op2,
            Opcode    => s_alu_opcode,
            Result    => s_alu_result,
            Cout_flag => s_alu_flags(1), -- C
            V_flag    => s_alu_flags(0), -- V
            Z_flag    => s_alu_flags(2), -- Z
            N_flag    => s_alu_flags(3)  -- N
        );

    FLAG_unit: status_register
        port map (
            CLK               => CLK,
            Reset             => Reset,
            Flags_WriteEnable => s_flags_write,
            Flags_in          => s_alu_flags,
            Flags_out         => s_status_reg_out
        );

end architecture Structural;
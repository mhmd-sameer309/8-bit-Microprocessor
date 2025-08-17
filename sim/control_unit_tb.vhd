library ieee;
use ieee.std_logic_1164.all;

entity control_unit_tb is
end entity control_unit_tb;

architecture behavioral of control_unit_tb is

    component control_unit is
        port (
            Instruction_in    : in  std_logic_vector(15 downto 0);
            ALU_Opcode        : out std_logic_vector(3 downto 0);
            RegWrite          : out std_logic;
            Flags_WriteEnable : out std_logic;
            PC_Increment      : out std_logic
        );
    end component control_unit;

    -- Testbench signals initialized to '0'
    signal tb_Instruction_in    : std_logic_vector(15 downto 0) := (others => '0');
    signal tb_ALU_Opcode        : std_logic_vector(3 downto 0);
    signal tb_RegWrite          : std_logic;
    signal tb_Flags_WriteEnable : std_logic;
    signal tb_PC_Increment      : std_logic;
    
    constant stimulus_delay : time := 10 ns;

begin
    -- Instantiate the Device Under Test
    DUT: control_unit 
        port map (
            Instruction_in     => tb_Instruction_in,
            ALU_Opcode         => tb_ALU_Opcode,
            RegWrite           => tb_RegWrite,
            Flags_WriteEnable  => tb_Flags_WriteEnable,
            PC_Increment       => tb_PC_Increment
        );

    -- Stimulus process
    stimulus_proc: process
    begin
        -- Test ADD instruction (Opcode 0000)
        tb_Instruction_in <= x"0E90"; -- Represents ADD R3, R1, R2
        wait for stimulus_delay;

        -- Test GT instruction (Opcode 0011)
        tb_Instruction_in <= x"3000"; -- Represents GT R0, R0, R0
        wait for stimulus_delay;

        -- Test AND instruction (Opcode 0110)
        tb_Instruction_in <= x"6CE8"; -- Represents AND R5, R3, R4
        wait for stimulus_delay;

        -- Test NOT instruction (Opcode 1001)
        tb_Instruction_in <= x"9D40"; -- Represents NOT R6, R5
        wait for stimulus_delay;
        
        -- Test an invalid Opcode (should result in safe default values)
        tb_Instruction_in <= x"F000";
        wait for stimulus_delay;
        
        -- Halt simulation
        wait;
    end process stimulus_proc;
end architecture behavioral;
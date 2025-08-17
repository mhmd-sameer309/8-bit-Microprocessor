library ieee;
use ieee.std_logic_1164.all;

entity alu_tb is
end entity alu_tb;

architecture behavioral of alu_tb is

    -- Component declaration for the ALU (Device Under Test)
    component alu_8bit is
        port (
            Operand1  : in  std_logic_vector(7 downto 0);
            Operand2  : in  std_logic_vector(7 downto 0);
            Opcode    : in  std_logic_vector(3 downto 0);
            Result    : out std_logic_vector(7 downto 0);
            Cout_flag : out std_logic;
            V_flag    : out std_logic;
            Z_flag    : out std_logic;
            N_flag    : out std_logic
        );
    end component alu_8bit;

    -- Testbench signals to connect to the DUT
    signal tb_Operand1  : std_logic_vector(7 downto 0);
    signal tb_Operand2  : std_logic_vector(7 downto 0);
    signal tb_Opcode    : std_logic_vector(3 downto 0);
    signal tb_Result    : std_logic_vector(7 downto 0);
    signal tb_Cout_flag : std_logic;
    signal tb_V_flag    : std_logic;
    signal tb_Z_flag    : std_logic;
    signal tb_N_flag    : std_logic;

    constant stimulus_delay : time := 10 ns;

begin

    -- Instantiate the Device Under Test
    DUT: alu_8bit
        port map (
            Operand1  => tb_Operand1,
            Operand2  => tb_Operand2,
            Opcode    => tb_Opcode,
            Result    => tb_Result,
            Cout_flag => tb_Cout_flag,
            V_flag    => tb_V_flag,
            Z_flag    => tb_Z_flag,
            N_flag    => tb_N_flag
        );

    stimulus_proc: process
    begin
        -- Initial state
        tb_Opcode <= "0000"; tb_Operand1 <= x"00"; tb_Operand2 <= x"00";
        wait for stimulus_delay;

        -- ==== ADD Operations ====
        tb_Opcode <= "0000"; tb_Operand1 <= x"10"; tb_Operand2 <= x"20"; wait for stimulus_delay;
        tb_Opcode <= "0000"; tb_Operand1 <= x"F0"; tb_Operand2 <= x"20"; wait for stimulus_delay;
        tb_Opcode <= "0000"; tb_Operand1 <= x"70"; tb_Operand2 <= x"70"; wait for stimulus_delay;
        tb_Opcode <= "0000"; tb_Operand1 <= x"FF"; tb_Operand2 <= x"01"; wait for stimulus_delay;
        
        -- ==== SUB Operations ====
        tb_Opcode <= "0001"; tb_Operand1 <= x"30"; tb_Operand2 <= x"10"; wait for stimulus_delay;
        tb_Opcode <= "0001"; tb_Operand1 <= x"10"; tb_Operand2 <= x"20"; wait for stimulus_delay;
        tb_Opcode <= "0001"; tb_Operand1 <= x"80"; tb_Operand2 <= x"01"; wait for stimulus_delay;
        tb_Opcode <= "0001"; tb_Operand1 <= x"AA"; tb_Operand2 <= x"AA"; wait for stimulus_delay;

        -- ==== MUL Operations ====
        tb_Opcode <= "0010"; tb_Operand1 <= x"04"; tb_Operand2 <= x"05"; wait for stimulus_delay;
        tb_Opcode <= "0010"; tb_Operand1 <= x"20"; tb_Operand2 <= x"10"; wait for stimulus_delay;
        tb_Opcode <= "0010"; tb_Operand1 <= x"FF"; tb_Operand2 <= x"FF"; wait for stimulus_delay;

        -- ==== GT, LT, EQ Operations ====
        tb_Opcode <= "0011"; tb_Operand1 <= x"80"; tb_Operand2 <= x"7F"; wait for stimulus_delay;
        tb_Opcode <= "0011"; tb_Operand1 <= x"AA"; tb_Operand2 <= x"AA"; wait for stimulus_delay;
        tb_Opcode <= "0100"; tb_Operand1 <= x"7F"; tb_Operand2 <= x"80"; wait for stimulus_delay;
        tb_Opcode <= "0101"; tb_Operand1 <= x"AA"; tb_Operand2 <= x"AA"; wait for stimulus_delay;
        tb_Opcode <= "0101"; tb_Operand1 <= x"AB"; tb_Operand2 <= x"AA"; wait for stimulus_delay;

        -- ==== Logical Operations ====
        tb_Opcode <= "0110"; tb_Operand1 <= x"F0"; tb_Operand2 <= x"C3"; wait for stimulus_delay;
        tb_Opcode <= "0110"; tb_Operand1 <= x"AA"; tb_Operand2 <= x"55"; wait for stimulus_delay;
        tb_Opcode <= "0111"; tb_Operand1 <= x"F0"; tb_Operand2 <= x"0F"; wait for stimulus_delay;
        tb_Opcode <= "1000"; tb_Operand1 <= x"AA"; tb_Operand2 <= x"55"; wait for stimulus_delay;
        tb_Opcode <= "1000"; tb_Operand1 <= x"C3"; tb_Operand2 <= x"C3"; wait for stimulus_delay;
        tb_Opcode <= "1001"; tb_Operand1 <= x"FF"; tb_Operand2 <= x"00"; wait for stimulus_delay;
        tb_Opcode <= "1001"; tb_Operand1 <= x"AA"; tb_Operand2 <= x"00"; wait for stimulus_delay;
        
        -- ==== INC/DEC Operations ====
        tb_Opcode <= "1010"; tb_Operand1 <= x"7F"; tb_Operand2 <= x"00"; wait for stimulus_delay;
        tb_Opcode <= "1010"; tb_Operand1 <= x"FF"; tb_Operand2 <= x"00"; wait for stimulus_delay;
        tb_Opcode <= "1011"; tb_Operand1 <= x"80"; tb_Operand2 <= x"00"; wait for stimulus_delay;
        tb_Opcode <= "1011"; tb_Operand1 <= x"00"; tb_Operand2 <= x"00"; wait for stimulus_delay;

        -- ==== Shift/Rotate Operations ====
        tb_Opcode <= "1100"; tb_Operand1 <= x"85"; tb_Operand2 <= x"00"; wait for stimulus_delay;
        tb_Opcode <= "1100"; tb_Operand1 <= x"42"; tb_Operand2 <= x"00"; wait for stimulus_delay;
        tb_Opcode <= "1101"; tb_Operand1 <= x"85"; tb_Operand2 <= x"00"; wait for stimulus_delay;
        tb_Opcode <= "1101"; tb_Operand1 <= x"42"; tb_Operand2 <= x"00"; wait for stimulus_delay;
        tb_Opcode <= "1110"; tb_Operand1 <= x"85"; tb_Operand2 <= x"00"; wait for stimulus_delay;
        tb_Opcode <= "1110"; tb_Operand1 <= x"42"; tb_Operand2 <= x"00"; wait for stimulus_delay;
        tb_Opcode <= "1111"; tb_Operand1 <= x"85"; tb_Operand2 <= x"00"; wait for stimulus_delay;
        tb_Opcode <= "1111"; tb_Operand1 <= x"42"; tb_Operand2 <= x"00"; wait for stimulus_delay;

        -- Halt the simulation
        wait;
    end process stimulus_proc;

end architecture behavioral;
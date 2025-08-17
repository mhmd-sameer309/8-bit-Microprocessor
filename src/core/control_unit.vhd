
library ieee;
use ieee.std_logic_1164.all;

entity control_unit is
    port (
        -- Input from Instruction Memory
        Instruction_in    : in  std_logic_vector(15 downto 0);
        
        -- Outputs to control the entire datapath
        ALU_Opcode        : out std_logic_vector(3 downto 0);
        RegWrite          : out std_logic; -- Enable writing to the Register File
        Flags_WriteEnable : out std_logic; -- Enable writing to the Status Register
        PC_Increment      : out std_logic  -- Enable the PC to increment
    );
end entity control_unit;

architecture Behavioral of control_unit is
    signal s_opcode : std_logic_vector(3 downto 0);
begin
    -- Extract the 4-bit opcode from the full 16-bit instruction
    s_opcode <= Instruction_in(15 downto 12);

    process(s_opcode)
    begin
        -- By default, all control signals are inactive (a safe state)
        RegWrite          <= '0';
        Flags_WriteEnable <= '0';
        PC_Increment      <= '0';
        ALU_Opcode        <= "0000"; -- Default to ADD

        case s_opcode is
            -- Opcodes that write to registers and update flags
            when "0000" | "0001" | "0010" | "0110" | "0111" | "1000" | "1001" | "1010" | "1011" | "1100" | "1101" | "1110" | "1111" =>
                ALU_Opcode        <= s_opcode;
                RegWrite          <= '1';
                Flags_WriteEnable <= '1';
                PC_Increment      <= '1';
            
            -- Opcodes for comparators (GT, LT, EQ)
            when "0011" | "0100" | "0101" =>
                ALU_Opcode        <= s_opcode;
                RegWrite          <= '1';
                Flags_WriteEnable <= '0'; -- Comparators do not set NZCV flags
                PC_Increment      <= '1';

            -- Default case for unused/invalid opcodes
            when others =>
                RegWrite          <= '0';
                Flags_WriteEnable <= '0';
                PC_Increment      <= '0';
                ALU_Opcode        <= "0000"; -- NOP (can be defined as ADD R0, R0, R0)
        end case;
    end process;
    
end architecture Behavioral;
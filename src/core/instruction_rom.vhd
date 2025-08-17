library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity instruction_rom is
    port (
        Address     : in  std_logic_vector(7 downto 0);
        Instruction : out std_logic_vector(15 downto 0)
    );
end entity instruction_rom;

architecture Behavioral of instruction_rom is

    type T_ROM_ARRAY is array (0 to 255) of std_logic_vector(15 downto 0);

    constant C_INSTRUCTION_ROM : T_ROM_ARRAY := (
        -- 0: ADD R3, R1, R2   (Opcode=0000, Rd=3, Rs1=1, Rs2=2)
        0 => x"0650",
        -- 1: SUB R4, R3, R1   (Opcode=0001, Rd=4, Rs1=3, Rs2=1)
        1 => x"18C8",
        -- 2: AND R5, R3, R4   (Opcode=0110, Rd=5, Rs1=3, Rs2=4)
        2 => x"6AE0",
        -- 3: NOT R6, R5       (Opcode=1001, Rd=6, Rs1=5, Rs2=ignored)
        3 => x"9D40",

        -- Fill the rest of the memory with NOPs
        others => x"0000"
    );

begin
    Instruction <= C_INSTRUCTION_ROM(to_integer(unsigned(Address)));
end architecture Behavioral;
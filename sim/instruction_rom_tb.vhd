library ieee;
use ieee.std_logic_1164.all;

entity instruction_rom_tb is
end entity instruction_rom_tb;

architecture behavioral of instruction_rom_tb is

    component instruction_rom is
        port (
            Address     : in  std_logic_vector(7 downto 0);
            Instruction : out std_logic_vector(15 downto 0)
        );
    end component instruction_rom;

    -- Testbench signals
    signal tb_Address     : std_logic_vector(7 downto 0);
    signal tb_Instruction : std_logic_vector(15 downto 0);

    constant stimulus_delay : time := 10 ns;

begin
    -- Instantiate the Device Under Test
    DUT: instruction_rom port map (Address => tb_Address, Instruction => tb_Instruction);

    -- Stimulus process to read from the ROM
    stimulus_proc: process
    begin
        -- Read from Address 0x00
        tb_Address <= x"00";
        wait for stimulus_delay;

        -- Read from Address 0x01
        tb_Address <= x"01";
        wait for stimulus_delay;

        -- Read from Address 0x02
        tb_Address <= x"02";
        wait for stimulus_delay;

        -- Read from Address 0x03
        tb_Address <= x"03";
        wait for stimulus_delay;

        -- Read from an empty Address (should be 0000)
        tb_Address <= x"04";
        wait for stimulus_delay;
        
        -- Halt the simulation
        wait;
    end process stimulus_proc;
end architecture behavioral;
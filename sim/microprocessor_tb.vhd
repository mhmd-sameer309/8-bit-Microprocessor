library ieee;
use ieee.std_logic_1164.all;

entity microprocessor_tb is
end entity microprocessor_tb;

architecture behavioral of microprocessor_tb is

    component microprocessor is
        port (
            CLK   : in std_logic;
            Reset : in std_logic
        );
    end component microprocessor;

    -- Testbench signals
    signal tb_CLK   : std_logic := '0';
    signal tb_Reset : std_logic := '0';

    constant clk_period : time := 10 ns;
begin
    -- Instantiate the CPU
    CPU_DUT: microprocessor port map (CLK => tb_CLK, Reset => tb_Reset);

    -- Clock generation
    tb_CLK <= not tb_CLK after clk_period/2;

    -- Stimulus: Reset the CPU, then let it run
    stimulus_proc: process
    begin
        -- Assert Reset for one cycle to start the PC at 0
        tb_Reset <= '1';
        wait for clk_period;
        
        -- De-assert Reset and let the program execute
        tb_Reset <= '0';
        wait for clk_period * 10; -- Let it run for 10 cycles

        -- Halt the simulation
        wait;
    end process stimulus_proc;
end architecture behavioral;
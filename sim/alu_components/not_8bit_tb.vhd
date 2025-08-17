library ieee;
use ieee.std_logic_1164.all;

entity not_8bit_tb is
end entity not_8bit_tb;

architecture behavioral of not_8bit_tb is
    component not_8bit is
        port (
            A      : in  std_logic_vector(7 downto 0);
            Result : out std_logic_vector(7 downto 0)
        );
    end component not_8bit;

    signal tb_A      : std_logic_vector(7 downto 0);
    signal tb_Result : std_logic_vector(7 downto 0);
    constant stimulus_delay : time := 10 ns;
begin
    DUT: not_8bit port map (A => tb_A, Result => tb_Result);

    stimulus_proc: process
    begin
        tb_A <= x"FF"; wait for stimulus_delay;
        tb_A <= x"00"; wait for stimulus_delay;
        tb_A <= x"AA"; wait for stimulus_delay;
        tb_A <= x"F0"; wait for stimulus_delay;
        report "Simulation finished." severity failure;
        wait;
    end process stimulus_proc;
end architecture behavioral;
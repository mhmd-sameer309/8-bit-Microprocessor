library ieee;
use ieee.std_logic_1164.all;

entity equal_8bit_tb is
end entity equal_8bit_tb;

architecture behavioral of equal_8bit_tb is
    component equal_8bit is
        port (
            A      : in  std_logic_vector(7 downto 0);
            B      : in  std_logic_vector(7 downto 0);
            A_eq_B : out std_logic
        );
    end component equal_8bit;

    signal tb_A      : std_logic_vector(7 downto 0);
    signal tb_B      : std_logic_vector(7 downto 0);
    signal tb_A_eq_B : std_logic;
    constant stimulus_delay : time := 10 ns;
begin
    DUT: equal_8bit port map (A => tb_A, B => tb_B, A_eq_B => tb_A_eq_B);

    stimulus_proc: process
    begin
        tb_A <= x"5A"; tb_B <= x"5A"; wait for stimulus_delay;
        tb_A <= x"FF"; tb_B <= x"FF"; wait for stimulus_delay;
        tb_A <= x"00"; tb_B <= x"00"; wait for stimulus_delay;
        tb_A <= x"5A"; tb_B <= x"5B"; wait for stimulus_delay;
        tb_A <= x"FF"; tb_B <= x"FE"; wait for stimulus_delay;
        tb_A <= x"AA"; tb_B <= x"AB"; wait for stimulus_delay;
        report "Simulation finished." severity failure;
        wait;
    end process stimulus_proc;
end architecture behavioral;
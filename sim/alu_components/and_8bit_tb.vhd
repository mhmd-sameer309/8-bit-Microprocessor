library ieee;
use ieee.std_logic_1164.all;

entity and_8bit_tb is
end entity and_8bit_tb;

architecture behavioral of and_8bit_tb is
    component and_8bit is
        port (
            A      : in  std_logic_vector(7 downto 0);
            B      : in  std_logic_vector(7 downto 0);
            Result : out std_logic_vector(7 downto 0)
        );
    end component and_8bit;

    signal tb_A      : std_logic_vector(7 downto 0);
    signal tb_B      : std_logic_vector(7 downto 0);
    signal tb_Result : std_logic_vector(7 downto 0);
    constant stimulus_delay : time := 10 ns;
begin
    DUT: and_8bit port map (A => tb_A, B => tb_B, Result => tb_Result);

    stimulus_proc: process
    begin
        tb_A <= x"FF"; tb_B <= x"FF"; wait for stimulus_delay;
        tb_A <= x"FF"; tb_B <= x"00"; wait for stimulus_delay;
        tb_A <= x"F0"; tb_B <= x"0F"; wait for stimulus_delay;
        tb_A <= x"AA"; tb_B <= x"55"; wait for stimulus_delay;
        tb_A <= x"C3"; tb_B <= x"F0"; wait for stimulus_delay;
        report "Simulation finished." severity failure;
        wait;
    end process stimulus_proc;
end architecture behavioral;
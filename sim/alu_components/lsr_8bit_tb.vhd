library ieee;
use ieee.std_logic_1164.all;

entity lsr_8bit_tb is
end entity lsr_8bit_tb;

architecture behavioral of lsr_8bit_tb is
    component lsr_8bit is
        port (
            A      : in  std_logic_vector(7 downto 0);
            Result : out std_logic_vector(7 downto 0);
            Cout   : out std_logic
        );
    end component lsr_8bit;

    signal tb_A      : std_logic_vector(7 downto 0);
    signal tb_Result : std_logic_vector(7 downto 0);
    signal tb_Cout   : std_logic;
    constant stimulus_delay : time := 10 ns;
begin
    DUT: lsr_8bit port map (A => tb_A, Result => tb_Result, Cout => tb_Cout);

    stimulus_proc: process
    begin
        tb_A <= x"01"; wait for stimulus_delay;
        tb_A <= x"80"; wait for stimulus_delay;
        tb_A <= x"AA"; wait for stimulus_delay;
        tb_A <= x"55"; wait for stimulus_delay;
        tb_A <= x"FF"; wait for stimulus_delay;
        report "Simulation finished." severity failure;
        wait;
    end process stimulus_proc;
end architecture behavioral;
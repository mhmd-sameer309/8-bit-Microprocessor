--
-- Testbench for the 8-bit "Less Than" Comparator
--
library ieee;
use ieee.std_logic_1164.all;

entity less_than_tb is
end entity less_than_tb;

architecture behavioral of less_than_tb is

    -- Component declaration for the Device Under Test (DUT)
    component less_than_8bit is
        port (
            A      : in  std_logic_vector(7 downto 0);
            B      : in  std_logic_vector(7 downto 0);
            A_lt_B : out std_logic
        );
    end component less_than_8bit;

    -- Signals to connect to the DUT
    signal tb_A      : std_logic_vector(7 downto 0) := (others => '0');
    signal tb_B      : std_logic_vector(7 downto 0) := (others => '0');
    signal tb_A_lt_B : std_logic;
    
    constant stimulus_delay : time := 10 ns;

begin

    -- Instantiate the Device Under Test
    DUT : less_than_8bit
        port map (
            A      => tb_A,
            B      => tb_B,
            A_lt_B => tb_A_lt_B
        );

    -- Stimulus process to apply test vectors
    stimulus_proc : process
    begin
        wait for stimulus_delay;

        report "Test Case: 20 < 30 (True)";
        tb_A <= x"20"; tb_B <= x"30";
        wait for stimulus_delay;
        
        report "Test Case: 7F < 80 (True, MSB diff)";
        tb_A <= x"7F"; tb_B <= x"80";
        wait for stimulus_delay;
        
        report "Test Case: 02 < 03 (True, LSB diff)";
        tb_A <= x"02"; tb_B <= x"03";
        wait for stimulus_delay;

        report "Test Case: 10 < 05 (False)";
        tb_A <= x"10"; tb_B <= x"05";
        wait for stimulus_delay;
        
        report "Test Case: 5A = 5A (False)";
        tb_A <= x"5A"; tb_B <= x"5A";
        wait for stimulus_delay;

        report "Test Case: FF = FF (False)";
        tb_A <= x"FF"; tb_B <= x"FF";
        wait for stimulus_delay;
        
        report "Simulation finished." severity failure;
        wait;
    end process stimulus_proc;

end architecture behavioral;
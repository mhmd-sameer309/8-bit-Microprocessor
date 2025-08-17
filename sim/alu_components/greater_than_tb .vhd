--
-- Testbench for the 8-bit "Greater Than" Comparator
--
library ieee;
use ieee.std_logic_1164.all;

entity greater_than_tb is
end entity greater_than_tb;

architecture behavioral of greater_than_tb is

    -- Component declaration for the Device Under Test (DUT)
    component greater_than_8bit is
        port (
            A      : in  std_logic_vector(7 downto 0);
            B      : in  std_logic_vector(7 downto 0);
            A_gt_B : out std_logic
        );
    end component greater_than_8bit;

    -- Signals to connect to the DUT
    signal tb_A      : std_logic_vector(7 downto 0) := (others => '0');
    signal tb_B      : std_logic_vector(7 downto 0) := (others => '0');
    signal tb_A_gt_B : std_logic;
    
    constant stimulus_delay : time := 10 ns;

begin

    -- Instantiate the Device Under Test
    DUT : greater_than_8bit
        port map (
            A      => tb_A,
            B      => tb_B,
            A_gt_B => tb_A_gt_B
        );

    -- Stimulus process to apply test vectors
    stimulus_proc : process
    begin
        wait for stimulus_delay;

        report "Test Case: 10 > 05 (True)";
        tb_A <= x"10"; tb_B <= x"05";
        wait for stimulus_delay;
        
        report "Test Case: 80 > 7F (True, MSB diff)";
        tb_A <= x"80"; tb_B <= x"7F";
        wait for stimulus_delay;

        report "Test Case: FF > FE (True, LSB diff)";
        tb_A <= x"FF"; tb_B <= x"FE";
        wait for stimulus_delay;

        report "Test Case: 20 > 30 (False)";
        tb_A <= x"20"; tb_B <= x"30";
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
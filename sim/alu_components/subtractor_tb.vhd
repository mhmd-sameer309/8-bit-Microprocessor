--
-- Testbench for the 8-bit Subtractor
--
library ieee;
use ieee.std_logic_1164.all;

-- Testbench entity is empty
entity subtractor_tb is
end entity subtractor_tb;

architecture behavioral of subtractor_tb is

    -- Component declaration for the Device Under Test (DUT)
    component subtractor_8bit is
        port (
            A          : in  std_logic_vector(7 downto 0);
            B          : in  std_logic_vector(7 downto 0);
            Difference : out std_logic_vector(7 downto 0);
            Cout       : out std_logic;
            V_flag     : out std_logic
        );
    end component subtractor_8bit;

    -- Signals to connect to the DUT
    signal tb_A          : std_logic_vector(7 downto 0) := (others => '0');
    signal tb_B          : std_logic_vector(7 downto 0) := (others => '0');
    signal tb_Difference : std_logic_vector(7 downto 0);
    signal tb_Cout       : std_logic;
    signal tb_V_flag     : std_logic;
    
    -- Define a delay constant for readability
    constant stimulus_delay : time := 10 ns;

begin

    -- Instantiate the Device Under Test
    DUT : subtractor_8bit
        port map (
            A          => tb_A,
            B          => tb_B,
            Difference => tb_Difference,
            Cout       => tb_Cout,
            V_flag     => tb_V_flag
        );

    -- Stimulus process to apply test vectors
    stimulus_proc : process
    begin
        -- Wait for the simulation to stabilize at the start
        wait for stimulus_delay;

        -- ====== Test Group 1: Basic Subtraction (No Borrow) ======
        report "Test Case: 5A - 1A";
        tb_A <= x"5A";
        tb_B <= x"1A";
        wait for stimulus_delay;

        report "Test Case: C5 - C5 (Subtract to Zero)";
        tb_A <= x"C5";
        tb_B <= x"C5";
        wait for stimulus_delay;
        
        report "Test Case: 3B - 00 (Subtract Zero)";
        tb_A <= x"3B";
        tb_B <= x"00";
        wait for stimulus_delay;
        
        -- ====== Test Group 2: Borrow Cases ======
        report "Test Case: 40 - 50 (Simple Borrow)";
        tb_A <= x"40";
        tb_B <= x"50";
        wait for stimulus_delay;
        
        report "Test Case: 00 - 01 (Subtract from Zero)";
        tb_A <= x"00";
        tb_B <= x"01";
        wait for stimulus_delay;
        
        report "Test Case: 00 - FF (Max Unsigned Borrow)";
        tb_A <= x"00";
        tb_B <= x"FF";
        wait for stimulus_delay;
        
        -- ====== Test Group 3: Overflow (V_flag) Cases ======
        report "Test Case: 7F - 80 (Pos - Neg -> Overflow)";
        tb_A <= x"7F";
        tb_B <= x"80";
        wait for stimulus_delay;
        
        report "Test Case: 80 - 01 (Neg - Pos -> Overflow)";
        tb_A <= x"80";
        tb_B <= x"01";
        wait for stimulus_delay;
        
        report "Test Case: 80 - FF (Neg - Neg -> No Overflow)";
        tb_A <= x"80";
        tb_B <= x"FF";
        wait for stimulus_delay;

        -- End of simulation
        report "Simulation finished." severity failure;
        wait; -- Halt the process
    end process stimulus_proc;

end architecture behavioral;
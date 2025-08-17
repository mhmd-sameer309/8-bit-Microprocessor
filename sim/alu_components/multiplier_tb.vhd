--
-- Testbench for the 8-bit Multiplier with 8-bit output and flags
--
library ieee;
use ieee.std_logic_1164.all;

-- Testbench entity is empty
entity multiplier_tb is
end entity multiplier_tb;

architecture behavioral of multiplier_tb is

    -- Component declaration for the Device Under Test (DUT)
    component multiplier_8bit is
        port (
            A       : in  std_logic_vector(7 downto 0);
            B       : in  std_logic_vector(7 downto 0);
            Product : out std_logic_vector(7 downto 0);
            Cout    : out std_logic;
            V_flag  : out std_logic
        );
    end component multiplier_8bit;

    -- Signals to connect to the DUT
    signal tb_A       : std_logic_vector(7 downto 0) := (others => '0');
    signal tb_B       : std_logic_vector(7 downto 0) := (others => '0');
    signal tb_Product : std_logic_vector(7 downto 0);
    signal tb_Cout    : std_logic;
    signal tb_V_flag  : std_logic;
    
    -- Define a delay constant for readability
    constant stimulus_delay : time := 10 ns;

begin

    -- Instantiate the Device Under Test
    DUT : multiplier_8bit
        port map (
            A       => tb_A,
            B       => tb_B,
            Product => tb_Product,
            Cout    => tb_Cout,
            V_flag  => tb_V_flag
        );

    -- Stimulus process to apply test vectors
    stimulus_proc : process
    begin
        -- Wait for the simulation to stabilize at the start
        wait for stimulus_delay;

        -- ====== Test Case 1: No Overflow (10 * 12 = 120) ======
        report "Test Case: 0A * 0C";
        tb_A <= x"0A";
        tb_B <= x"0C";
        wait for stimulus_delay;

        -- ====== Test Case 2: No Overflow, Boundary (255 * 1 = 255) ======
        report "Test Case: FF * 01";
        tb_A <= x"FF";
        tb_B <= x"01";
        wait for stimulus_delay;
        
        -- ====== Test Case 3: Overflow, Boundary (16 * 16 = 256) ======
        report "Test Case: 10 * 10";
        tb_A <= x"10";
        tb_B <= x"10";
        wait for stimulus_delay;

        -- ====== Test Case 4: Overflow, General (200 * 2 = 400) ======
        report "Test Case: C8 * 02";
        tb_A <= x"C8";
        tb_B <= x"02";
        wait for stimulus_delay;
        
        -- ====== Test Case 5: Overflow, Max Value (255 * 255 = 65025) ======
        report "Test Case: FF * FF";
        tb_A <= x"FF";
        tb_B <= x"FF";
        wait for stimulus_delay;

        -- End of simulation
        report "Simulation finished." severity failure;
        wait; -- Halt the process
    end process stimulus_proc;

end architecture behavioral;
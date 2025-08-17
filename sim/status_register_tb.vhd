library ieee;
use ieee.std_logic_1164.all;

entity status_register_tb is
end entity status_register_tb;

architecture behavioral of status_register_tb is

    component status_register is
        port (
            CLK               : in  std_logic;
            Reset             : in  std_logic;
            Flags_WriteEnable : in  std_logic;
            Flags_in          : in  std_logic_vector(3 downto 0);
            Flags_out         : out std_logic_vector(3 downto 0)
        );
    end component status_register;

    -- Testbench signals initialized to '0'
    signal tb_CLK               : std_logic := '0';
    signal tb_Reset             : std_logic := '0';
    signal tb_Flags_WriteEnable : std_logic := '0';
    signal tb_Flags_in          : std_logic_vector(3 downto 0) := (others => '0');
    signal tb_Flags_out         : std_logic_vector(3 downto 0);

    constant clk_period : time := 10 ns;

begin
    -- Instantiate the Device Under Test
    DUT: status_register 
        port map (
            CLK               => tb_CLK, 
            Reset             => tb_Reset, 
            Flags_WriteEnable => tb_Flags_WriteEnable, 
            Flags_in          => tb_Flags_in, 
            Flags_out         => tb_Flags_out
        );

    -- Clock generation
    tb_CLK <= not tb_CLK after clk_period/2;

    -- Stimulus process
    stimulus_proc: process
    begin
        -- Assert Reset
        tb_Reset <= '1';
        wait for clk_period;
        tb_Reset <= '0';

        -- Hold state (WriteEnable is '0')
        tb_Flags_in <= x"A";
        wait for clk_period;

        -- Enable write to load x"A"
        tb_Flags_WriteEnable <= '1';
        wait for clk_period;

        -- Set up next value (x"5") while previous value (x"A") is being observed
        tb_Flags_in <= x"5";
        wait for clk_period;

        -- Disable write to hold the new value (x"5")
        tb_Flags_WriteEnable <= '0';
        tb_Flags_in <= x"C"; -- This input should be ignored
        wait for clk_period;
        
        -- Halt simulation
        wait;
    end process stimulus_proc;
end architecture behavioral;
library ieee;
use ieee.std_logic_1164.all;

entity program_counter_tb is
end entity program_counter_tb;

architecture behavioral of program_counter_tb is

    component program_counter is
        port (
            CLK             : in  std_logic;
            Reset           : in  std_logic;
            PC_Load         : in  std_logic;
            PC_Increment    : in  std_logic;
            Jump_Address_in : in  std_logic_vector(7 downto 0);
            PC_Address_out  : out std_logic_vector(7 downto 0)
        );
    end component program_counter;

    -- testbench signals
    signal tb_CLK             : std_logic := '0';
    signal tb_Reset           : std_logic := '0';
    signal tb_PC_Load         : std_logic := '0';
    signal tb_PC_Increment    : std_logic := '0';
    signal tb_Jump_Address_in : std_logic_vector(7 downto 0) := (others => '0');
    signal tb_PC_Address_out  : std_logic_vector(7 downto 0);
    
    constant clk_period : time := 10 ns;

begin
    -- Instantiate the Device Under Test
    DUT: program_counter port map (
        CLK => tb_CLK, Reset => tb_Reset,
        PC_Increment => tb_PC_Increment, PC_Load => tb_PC_Load,
        Jump_Address_in => tb_Jump_Address_in, PC_Address_out => tb_PC_Address_out
    );

    -- Clock generation
    tb_CLK <= not tb_CLK after clk_period/2;

    -- Stimulus process
    stimulus_proc: process
    begin
        -- Assert Reset
        tb_Reset <= '1';
        wait for clk_period;

        -- De-assert Reset and start incrementing
        tb_Reset <= '0';
        tb_PC_Load <= '0';
        tb_PC_Increment <= '1';
        wait for clk_period * 2; -- Increment twice (to 0x01, then 0x02)

        -- Hold the value
        tb_PC_Increment <= '0';
        wait for clk_period;

        -- Load a new address (Load should override Increment)
        tb_PC_Load <= '1';
        tb_PC_Increment <= '1';
        tb_Jump_Address_in <= x"50";
        wait for clk_period;

        -- Disable load and continue incrementing
        tb_PC_Load <= '0';
        tb_PC_Increment <= '1';
        wait for clk_period * 2; -- Increment twice (to 0x51, then 0x52)
        
        -- Halt simulation
        wait;
    end process stimulus_proc;
end architecture behavioral;
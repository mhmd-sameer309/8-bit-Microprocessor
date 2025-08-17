library ieee;
use ieee.std_logic_1164.all;

entity register_file_tb is
end entity register_file_tb;

architecture behavioral of register_file_tb is

    component register_file is
        port (
            CLK        : in  std_logic;
            RegWrite   : in  std_logic;
            ReadAddr1  : in  std_logic_vector(2 downto 0);
            ReadAddr2  : in  std_logic_vector(2 downto 0);
            WriteAddr  : in  std_logic_vector(2 downto 0);
            WriteData  : in  std_logic_vector(7 downto 0);
            ReadData1  : out std_logic_vector(7 downto 0);
            ReadData2  : out std_logic_vector(7 downto 0)
        );
    end component register_file;

    -- Testbench signals
    signal tb_CLK        : std_logic := '0';
    signal tb_RegWrite   : std_logic;
    signal tb_ReadAddr1  : std_logic_vector(2 downto 0);
    signal tb_ReadAddr2  : std_logic_vector(2 downto 0);
    signal tb_WriteAddr  : std_logic_vector(2 downto 0);
    signal tb_WriteData  : std_logic_vector(7 downto 0);
    signal tb_ReadData1  : std_logic_vector(7 downto 0);
    signal tb_ReadData2  : std_logic_vector(7 downto 0);
    
    constant clk_period : time := 10 ns;

begin
    -- Instantiate the Device Under Test
    DUT: register_file 
        port map (
            CLK        => tb_CLK,      RegWrite   => tb_RegWrite,   ReadAddr1  => tb_ReadAddr1,
            ReadAddr2  => tb_ReadAddr2, WriteAddr  => tb_WriteAddr, WriteData  => tb_WriteData,
            ReadData1  => tb_ReadData1, ReadData2  => tb_ReadData2
        );

    -- Clock generation process
    tb_CLK <= not tb_CLK after clk_period/2;

    -- Stimulus process with corrected timing
    stimulus_proc: process
    begin
        -- Step 1: Initial state, reading R1 and R2
        tb_RegWrite <= '0';
        tb_ReadAddr1 <= "001";
        tb_ReadAddr2 <= "010";
        wait until rising_edge(tb_CLK);

        -- Step 2: Set up to write x"AA" to R5
        tb_RegWrite <= '1';
        tb_WriteAddr <= "101";
        tb_WriteData <= x"AA";
        wait until rising_edge(tb_CLK); -- The write happens here

        -- Step 3: Verify the write. Disable write, set read address to R5.
        tb_RegWrite <= '0';
        tb_ReadAddr1 <= "101";
        tb_ReadAddr2 <= "010"; -- Keep reading R2
        wait until rising_edge(tb_CLK); -- ReadData1 now shows x"AA"

        -- Step 4: Set up to write x"BB" to R1
        tb_RegWrite <= '1';
        tb_WriteAddr <= "001";
        tb_WriteData <= x"BB";
        wait until rising_edge(tb_CLK); -- The write to R1 happens here

        -- Step 5: Set up to write x"CC" to R2
        tb_WriteAddr <= "010";
        tb_WriteData <= x"CC";
        wait until rising_edge(tb_CLK); -- The write to R2 happens here

        -- Step 6: Verify final state. Disable write, read R1 and R2.
        tb_RegWrite <= '0';
        tb_ReadAddr1 <= "001";
        tb_ReadAddr2 <= "010";
        wait for clk_period * 2; -- Wait a couple cycles to observe the final stable state
        
        -- Halt the simulation
        wait;
    end process stimulus_proc;
end architecture behavioral;
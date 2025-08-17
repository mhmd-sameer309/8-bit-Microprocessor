library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity register_file is
    port (
        CLK        : in  std_logic;
        RegWrite   : in  std_logic;
        ReadAddr1  : in  std_logic_vector(2 downto 0);
        ReadAddr2  : in  std_logic_vector(2 downto 0);
        WriteAddr  : in  std_logic_vector(2 downto 0);
        WriteData  : in  std_logic_vector(7 downto 0);
        ReadData1  : out std_logic_vector(7 downto 0);
        ReadData2  : out std_logic_vector(7 downto 0);
        ReadAddr3  : in  std_logic_vector(2 downto 0);
        ReadData3  : out std_logic_vector(7 downto 0)
    );
end entity register_file;

architecture Behavioral of register_file is

    type T_REG_ARRAY is array (0 to 7) of std_logic_vector(7 downto 0);
    -- Initial values are set for the test program
    signal s_registers : T_REG_ARRAY := (1 => x"0A", 2 => x"14", others => (others => '0'));

begin

    -- Asynchronous Read Logic for all three ports
    ReadData1 <= s_registers(to_integer(unsigned(ReadAddr1)));
    ReadData2 <= s_registers(to_integer(unsigned(ReadAddr2)));
    ReadData3 <= s_registers(to_integer(unsigned(ReadAddr3)));

    -- Synchronous Write Logic
    process (CLK)
    begin
        if rising_edge(CLK) then
            if RegWrite = '1' then
                s_registers(to_integer(unsigned(WriteAddr))) <= WriteData;
            end if;
        end if;
    end process;

end architecture Behavioral;
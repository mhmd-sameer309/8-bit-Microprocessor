library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity program_counter is
    port (
        CLK             : in  std_logic;
        Reset           : in  std_logic; -- Asynchronous reset to 0x00
        PC_Load         : in  std_logic; -- Enable to load a new address
        PC_Increment    : in  std_logic; -- Enable to increment the PC
        Jump_Address_in : in  std_logic_vector(7 downto 0);
        PC_Address_out  : out std_logic_vector(7 downto 0)
    );
end entity program_counter;

architecture Behavioral of program_counter is
    signal s_pc_internal : unsigned(7 downto 0) := (others => '0');
begin

    process (CLK, Reset)
    begin
        if Reset = '1' then
            s_pc_internal <= (others => '0');
        elsif rising_edge(CLK) then
            if PC_Load = '1' then
                s_pc_internal <= unsigned(Jump_Address_in);
            elsif PC_Increment = '1' then
                s_pc_internal <= s_pc_internal + 1;
            end if;
            -- If neither Load nor Increment is '1', the PC holds its value
        end if;
    end process;

    -- Continuously output the internal PC value
    PC_Address_out <= std_logic_vector(s_pc_internal);

end architecture Behavioral;
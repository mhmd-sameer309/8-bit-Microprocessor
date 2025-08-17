library ieee;
use ieee.std_logic_1164.all;

entity status_register is
    port (
        CLK               : in  std_logic;
        Reset             : in  std_logic; -- Asynchronous reset
        Flags_WriteEnable : in  std_logic; -- Enable signal from Control Unit
        Flags_in          : in  std_logic_vector(3 downto 0); -- (N,Z,C,V) from ALU
        Flags_out         : out std_logic_vector(3 downto 0)  -- (N,Z,C,V) to Control Unit
    );
end entity status_register;

architecture Behavioral of status_register is
    signal s_flags_internal : std_logic_vector(3 downto 0) := (others => '0');
begin

    process(CLK, Reset)
    begin
        if Reset = '1' then
            s_flags_internal <= (others => '0');
        elsif rising_edge(CLK) then
            if Flags_WriteEnable = '1' then
                s_flags_internal <= Flags_in;
            end if;
            -- If WriteEnable is '0', the register holds its value
        end if;
    end process;

    -- Continuously output the internal register's state
    Flags_out <= s_flags_internal;

end architecture Behavioral;
--
-- 8-bit Logical Shift Left (A << 1)
--
library ieee;
use ieee.std_logic_1164.all;

entity lsl_8bit is
    port (
        A      : in  std_logic_vector(7 downto 0);
        Result : out std_logic_vector(7 downto 0);
        Cout   : out std_logic
    );
end entity lsl_8bit;

architecture Behavioral of lsl_8bit is
begin
    Cout   <= A(7);
    Result <= A(6 downto 0) & '0';
end architecture Behavioral;
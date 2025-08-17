--
-- 8-bit Bitwise NOT operation (not A)
--
library ieee;
use ieee.std_logic_1164.all;

entity not_8bit is
    port (
        A      : in  std_logic_vector(7 downto 0);
        Result : out std_logic_vector(7 downto 0)
    );
end entity not_8bit;

architecture Behavioral of not_8bit is
begin
    Result <= not A;
end architecture Behavioral;
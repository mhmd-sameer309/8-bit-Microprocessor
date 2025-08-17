--
-- 8-bit Bitwise AND operation (A and B)
--
library ieee;
use ieee.std_logic_1164.all;

entity and_8bit is
    port (
        A      : in  std_logic_vector(7 downto 0);
        B      : in  std_logic_vector(7 downto 0);
        Result : out std_logic_vector(7 downto 0)
    );
end entity and_8bit;

architecture Behavioral of and_8bit is
begin
    Result <= A and B;
end architecture Behavioral;
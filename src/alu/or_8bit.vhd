--
-- 8-bit Bitwise OR operation (A or B)
--
library ieee;
use ieee.std_logic_1164.all;

entity or_8bit is
    port (
        A      : in  std_logic_vector(7 downto 0);
        B      : in  std_logic_vector(7 downto 0);
        Result : out std_logic_vector(7 downto 0)
    );
end entity or_8bit;

architecture Behavioral of or_8bit is
begin
    Result <= A or B;
end architecture Behavioral;
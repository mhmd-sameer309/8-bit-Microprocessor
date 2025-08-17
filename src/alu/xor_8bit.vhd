--
-- 8-bit Bitwise XOR operation (A xor B)
--
library ieee;
use ieee.std_logic_1164.all;

entity xor_8bit is
    port (
        A      : in  std_logic_vector(7 downto 0);
        B      : in  std_logic_vector(7 downto 0);
        Result : out std_logic_vector(7 downto 0)
    );
end entity xor_8bit;

architecture Behavioral of xor_8bit is
begin
    Result <= A xor B;
end architecture Behavioral;
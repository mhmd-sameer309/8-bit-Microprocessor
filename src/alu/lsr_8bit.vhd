--
-- 8-bit Logical Shift Right (A >> 1)
--
library ieee;
use ieee.std_logic_1164.all;

entity lsr_8bit is
    port (
        A      : in  std_logic_vector(7 downto 0);
        Result : out std_logic_vector(7 downto 0);
        Cout   : out std_logic
    );
end entity lsr_8bit;

architecture Behavioral of lsr_8bit is
begin
    Cout   <= A(0);
    Result <= '0' & A(7 downto 1);
end architecture Behavioral;
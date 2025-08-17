--
-- 8-bit Rotate Right
--
library ieee;
use ieee.std_logic_1164.all;

entity ror_8bit is
    port (
        A      : in  std_logic_vector(7 downto 0);
        Result : out std_logic_vector(7 downto 0);
        Cout   : out std_logic
    );
end entity ror_8bit;

architecture Behavioral of ror_8bit is
begin
    -- The bit shifted out of the LSB goes to the Carry flag
    Cout <= A(0);

    -- Shift right and wrap the LSB around to the MSB
    Result <= A(0) & A(7 downto 1);
end architecture Behavioral;
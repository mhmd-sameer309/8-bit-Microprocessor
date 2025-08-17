--
-- 8-bit Rotate Left
--
library ieee;
use ieee.std_logic_1164.all;

entity rol_8bit is
    port (
        A      : in  std_logic_vector(7 downto 0);
        Result : out std_logic_vector(7 downto 0);
        Cout   : out std_logic
    );
end entity rol_8bit;

architecture Behavioral of rol_8bit is
begin
    -- The bit shifted out of the MSB goes to the Carry flag
    Cout <= A(7);

    -- Shift left and wrap the MSB around to the LSB
    Result <= A(6 downto 0) & A(7);
end architecture Behavioral;
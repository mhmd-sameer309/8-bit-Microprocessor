--
-- 8-bit Decrement operation (A - 1) using a subtractor block
--
library ieee;
use ieee.std_logic_1164.all;

entity decrement_8bit is
    port (
        A      : in  std_logic_vector(7 downto 0);
        Result : out std_logic_vector(7 downto 0);
        Cout   : out std_logic;
        V_flag : out std_logic
    );
end entity decrement_8bit;

architecture Behavioral_reuse of decrement_8bit is
    component subtractor_8bit is
        port (
            A          : in  std_logic_vector(7 downto 0);
            B          : in  std_logic_vector(7 downto 0);
            Difference : out std_logic_vector(7 downto 0);
            Cout       : out std_logic;
            V_flag     : out std_logic
        );
    end component subtractor_8bit;

    constant ONE : std_logic_vector(7 downto 0) := x"01";
begin
    Subtractor_Unit: subtractor_8bit
        port map (
            A          => A,
            B          => ONE,
            Difference => Result,
            Cout       => Cout,
            V_flag     => V_flag
        );
end architecture Behavioral_reuse;
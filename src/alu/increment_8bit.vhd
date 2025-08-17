--
-- 8-bit Increment operation (A + 1) using an adder block
--
library ieee;
use ieee.std_logic_1164.all;

entity increment_8bit is
    port (
        A      : in  std_logic_vector(7 downto 0);
        Result : out std_logic_vector(7 downto 0);
        Cout   : out std_logic;
        V_flag : out std_logic
    );
end entity increment_8bit;

architecture Behavioral_reuse of increment_8bit is
    component adder_8bit is
        port (
            A      : in  std_logic_vector(7 downto 0);
            B      : in  std_logic_vector(7 downto 0);
            Cin    : in  std_logic;
            Sum    : out std_logic_vector(7 downto 0);
            Cout   : out std_logic;
            V_flag : out std_logic
        );
    end component adder_8bit;

    constant ONE : std_logic_vector(7 downto 0) := x"01";
begin
    Adder_Unit: adder_8bit
        port map (
            A      => A,
            B      => ONE,
            Cin    => '0',
            Sum    => Result,
            Cout   => Cout,
            V_flag => V_flag
        );
end architecture Behavioral_reuse;
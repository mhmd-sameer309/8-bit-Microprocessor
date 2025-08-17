--
-- 16-bit Adder made from two 8-bit Adders
--
library ieee;
use ieee.std_logic_1164.all;

entity adder_16bit is
    port (
        A   : in  std_logic_vector(15 downto 0);
        B   : in  std_logic_vector(15 downto 0);
        Sum : out std_logic_vector(15 downto 0)
    );
end entity adder_16bit;

architecture Structural of adder_16bit is

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

    signal carry_low_to_high : std_logic; -- Carry from low to high adder
    signal unused_vflag      : std_logic; -- Unused flag output
    signal unused_cout       : std_logic; -- Unused flag output

begin

    Adder_Low: adder_8bit
        port map (
            A      => A(7 downto 0),
            B      => B(7 downto 0),
            Cin    => '0', -- Initial carry is 0
            Sum    => Sum(7 downto 0),
            Cout   => carry_low_to_high,
            V_flag => unused_vflag
        );
        
    Adder_High: adder_8bit
        port map (
            A      => A(15 downto 8),
            B      => B(15 downto 8),
            Cin    => carry_low_to_high, -- Use carry from the lower adder
            Sum    => Sum(15 downto 8),
            Cout   => unused_cout,
            V_flag => unused_vflag
        );

end architecture Structural;
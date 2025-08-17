library ieee;
use ieee.std_logic_1164.all;

entity subtractor_8bit is
    port (
        A          : in  std_logic_vector(7 downto 0);
        B          : in  std_logic_vector(7 downto 0);
        Difference : out std_logic_vector(7 downto 0);
        Cout       : out std_logic;
        V_flag     : out std_logic
    );
end entity subtractor_8bit;

architecture Behavioral_reuse of subtractor_8bit is

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

    signal B_inv : std_logic_vector(7 downto 0);

begin

    B_inv <= not B;

    Subtractor_Unit : adder_8bit
        port map (
            A      => A,
            B      => B_inv,
            Cin    => '1',        -- Add 1 for two's complement
            Sum    => Difference,
            Cout   => Cout,
            V_flag => V_flag
        );

end architecture Behavioral_reuse;
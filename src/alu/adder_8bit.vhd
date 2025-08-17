library ieee;
use ieee.std_logic_1164.all;

entity adder_8bit is
    port (
        A      : in  std_logic_vector(7 downto 0); -- Operand A
        B      : in  std_logic_vector(7 downto 0); -- Operand B
        Cin    : in  std_logic;                    -- Carry-in
        Sum    : out std_logic_vector(7 downto 0); -- 8-bit Sum
        Cout   : out std_logic;                    -- Final Carry-out
        V_flag : out std_logic                     -- Overflow flag
    );
end entity adder_8bit;

architecture Structural of adder_8bit is

    component full_adder is
        port (
            A   : in  std_logic;
            B   : in  std_logic;
            Cin : in  std_logic;
            Sum : out std_logic;
            Cout: out std_logic
        );
    end component full_adder;

    -- Internal signal for the carry chain
    signal C : std_logic_vector(8 downto 0);

begin

    C(0) <= Cin;

    FA_GEN : for i in 0 to 7 generate
    begin
        FA_inst : full_adder
            port map (
                A    => A(i),
                B    => B(i),
                Cin  => C(i),
                Sum  => Sum(i),
                Cout => C(i+1)
            );
    end generate FA_GEN;

    Cout <= C(8);

    -- Overflow flag: set if carry-in and carry-out of the MSB differ.
    V_flag <= C(8) xor C(7);

end architecture Structural;
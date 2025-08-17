--
-- 8x8 Bit Structural Multiplier with 8-bit Output and Flags
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity multiplier_8bit is
    port (
        A       : in  std_logic_vector(7 downto 0);
        B       : in  std_logic_vector(7 downto 0);
        Product : out std_logic_vector(7 downto 0);
        Cout    : out std_logic;
        V_flag  : out std_logic
    );
end entity multiplier_8bit;

architecture Structural_8bit_out of multiplier_8bit is

    -- Component for the 8-bit adder block
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

    -- Internal signal types for the adder chain
    type T_PARTIAL_PRODUCTS is array (0 to 7) of std_logic_vector(15 downto 0);
    type T_SUMS is array (0 to 6) of std_logic_vector(15 downto 0);
    type T_CARRIES is array (0 to 6) of std_logic;
    
    -- Internal signals for calculation
    signal s_full_product       : std_logic_vector(15 downto 0);
    signal Partial_Products     : T_PARTIAL_PRODUCTS;
    signal Intermediate_Sums    : T_SUMS;
    signal Intermediate_Carries : T_CARRIES;
    signal unused_flags         : std_logic; -- Sink for unused outputs

begin

    -- Generate the 8 shifted partial products from multiplicand A and multiplier B
    GEN_PP: for i in 0 to 7 generate
        Partial_Products(i) <= std_logic_vector(resize(unsigned(A), 16) sll i) when B(i) = '1' else (others => '0');
    end generate GEN_PP;


    -- Adder Chain: Sum all partial products using pairs of 8-bit adders
    -- Stage 0: Add first two partial products
    ADD0_LOW: adder_8bit
        port map (
            A      => Partial_Products(0)(7 downto 0),
            B      => Partial_Products(1)(7 downto 0),
            Cin    => '0',
            Sum    => Intermediate_Sums(0)(7 downto 0),
            Cout   => Intermediate_Carries(0),
            V_flag => unused_flags
        );
        
    ADD0_HIGH: adder_8bit
        port map (
            A      => Partial_Products(0)(15 downto 8),
            B      => Partial_Products(1)(15 downto 8),
            Cin    => Intermediate_Carries(0),
            Sum    => Intermediate_Sums(0)(15 downto 8),
            Cout   => unused_flags,
            V_flag => unused_flags
        );

    -- Stages 1 through 6: Add the next partial product to the intermediate sum
    ADD_CHAIN: for i in 1 to 6 generate
    begin
        ADD_LOW_i: adder_8bit
            port map (
                A      => Intermediate_Sums(i-1)(7 downto 0),
                B      => Partial_Products(i+1)(7 downto 0),
                Cin    => '0',
                Sum    => Intermediate_Sums(i)(7 downto 0),
                Cout   => Intermediate_Carries(i),
                V_flag => unused_flags
            );

        ADD_HIGH_i: adder_8bit
            port map (
                A      => Intermediate_Sums(i-1)(15 downto 8),
                B      => Partial_Products(i+1)(15 downto 8),
                Cin    => Intermediate_Carries(i),
                Sum    => Intermediate_Sums(i)(15 downto 8),
                Cout   => unused_flags,
                V_flag => unused_flags
            );
    end generate ADD_CHAIN;


    -- Final Output Assignment
    s_full_product <= Intermediate_Sums(6);
    Product        <= s_full_product(7 downto 0);
    
    -- Set flags if the upper byte of the full product is not zero (result > 255)
    Cout   <= '1' when s_full_product(15 downto 8) /= "00000000" else '0';
    V_flag <= '1' when s_full_product(15 downto 8) /= "00000000" else '0';
    
end architecture Structural_8bit_out;
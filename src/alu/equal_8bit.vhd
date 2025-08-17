--
-- 8-bit "Equal To" Comparator (A = B)
--
library ieee;
use ieee.std_logic_1164.all;

entity equal_8bit is
    port (
        A      : in  std_logic_vector(7 downto 0);
        B      : in  std_logic_vector(7 downto 0);
        A_eq_B : out std_logic -- '1' if A = B
    );
end entity equal_8bit;

architecture Structural of equal_8bit is
    -- Component declaration from previous design
    component compare_1bit is
        port (
            A_bit  : in  std_logic;
            B_bit  : in  std_logic;
            gt_in  : in  std_logic;
            eq_in  : in  std_logic;
            lt_in  : in  std_logic;
            gt_out : out std_logic;
            eq_out : out std_logic;
            lt_out : out std_logic
        );
    end component compare_1bit;

    -- Internal signals to chain the comparators
    signal gt_chain : std_logic_vector(8 downto 0);
    signal eq_chain : std_logic_vector(8 downto 0);
    signal lt_chain : std_logic_vector(8 downto 0);
begin
    -- Initial conditions for the MSB stage
    gt_chain(8) <= '0';
    lt_chain(8) <= '0';
    eq_chain(8) <= '1'; -- Assume A = B to start
    
    -- Generate the cascade of 8 comparators from MSB to LSB
    Comp_Gen: for i in 7 downto 0 generate
    begin
        Comp_Slice: compare_1bit
            port map (
                A_bit  => A(i),
                B_bit  => B(i),
                gt_in  => gt_chain(i+1),
                eq_in  => eq_chain(i+1),
                lt_in  => lt_chain(i+1),
                gt_out => gt_chain(i),
                eq_out => eq_chain(i),
                lt_out => lt_chain(i)
            );
    end generate Comp_Gen;
    
    -- The final result is the "Equal" output from the LSB slice.
    A_eq_B <= eq_chain(0);
    
end architecture Structural;
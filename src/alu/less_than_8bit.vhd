--
-- 8-bit "Less Than" Comparator (A < B)
--
library ieee;
use ieee.std_logic_1164.all;

entity less_than_8bit is
    port (
        A      : in  std_logic_vector(7 downto 0);
        B      : in  std_logic_vector(7 downto 0);
        A_lt_B : out std_logic
    );
end entity less_than_8bit;

architecture Structural of less_than_8bit is
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

    signal gt_chain : std_logic_vector(8 downto 0);
    signal eq_chain : std_logic_vector(8 downto 0);
    signal lt_chain : std_logic_vector(8 downto 0);
begin
    gt_chain(8) <= '0';
    lt_chain(8) <= '0';
    eq_chain(8) <= '1';
    
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
    
    A_lt_B <= lt_chain(0);
    
end architecture Structural;
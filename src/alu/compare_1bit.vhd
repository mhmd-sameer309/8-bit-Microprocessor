--
-- 1-bit, 3-state slice for a cascading comparator (A > B, A < B, A = B)
--
library ieee;
use ieee.std_logic_1164.all;

entity compare_1bit is
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
end entity compare_1bit;

architecture Behavioral of compare_1bit is
    signal s_is_gt : std_logic;
    signal s_is_lt : std_logic;
    signal s_is_eq : std_logic;
begin
    s_is_gt <= A_bit and (not B_bit);
    s_is_lt <= (not A_bit) and B_bit;
    s_is_eq <= not (A_bit xor B_bit);

    gt_out <= gt_in or (eq_in and s_is_gt);
    lt_out <= lt_in or (eq_in and s_is_lt);
    eq_out <= eq_in and s_is_eq;

end architecture Behavioral;
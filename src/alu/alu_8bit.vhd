library ieee;
use ieee.std_logic_1164.all;

entity alu_8bit is
    port (
        Operand1  : in  std_logic_vector(7 downto 0);
        Operand2  : in  std_logic_vector(7 downto 0);
        Opcode    : in  std_logic_vector(3 downto 0);
        Result    : out std_logic_vector(7 downto 0);
        Cout_flag : out std_logic;
        V_flag    : out std_logic;
        Z_flag    : out std_logic;
        N_flag    : out std_logic
    );
end entity alu_8bit;

architecture Structural of alu_8bit is

    -- Component Declarations
    component adder_8bit is port (A:in std_logic_vector(7 downto 0); B:in std_logic_vector(7 downto 0); Cin:in std_logic; Sum:out std_logic_vector(7 downto 0); Cout:out std_logic; V_flag:out std_logic); end component;
    component subtractor_8bit is port (A:in std_logic_vector(7 downto 0); B:in std_logic_vector(7 downto 0); Difference:out std_logic_vector(7 downto 0); Cout:out std_logic; V_flag:out std_logic); end component;
    component multiplier_8bit is port (A:in std_logic_vector(7 downto 0); B:in std_logic_vector(7 downto 0); Product:out std_logic_vector(7 downto 0); Cout:out std_logic; V_flag:out std_logic); end component;
    component greater_than_8bit is port (A:in std_logic_vector(7 downto 0); B:in std_logic_vector(7 downto 0); A_gt_B:out std_logic); end component;
    component less_than_8bit is port (A:in std_logic_vector(7 downto 0); B:in std_logic_vector(7 downto 0); A_lt_B:out std_logic); end component;
    component equal_8bit is port (A:in std_logic_vector(7 downto 0); B:in std_logic_vector(7 downto 0); A_eq_B:out std_logic); end component;
    component and_8bit is port (A:in std_logic_vector(7 downto 0); B:in std_logic_vector(7 downto 0); Result:out std_logic_vector(7 downto 0)); end component;
    component or_8bit is port (A:in std_logic_vector(7 downto 0); B:in std_logic_vector(7 downto 0); Result:out std_logic_vector(7 downto 0)); end component;
    component xor_8bit is port (A:in std_logic_vector(7 downto 0); B:in std_logic_vector(7 downto 0); Result:out std_logic_vector(7 downto 0)); end component;
    component not_8bit is port (A:in std_logic_vector(7 downto 0); Result:out std_logic_vector(7 downto 0)); end component;
    component increment_8bit is port (A:in std_logic_vector(7 downto 0); Result:out std_logic_vector(7 downto 0); Cout:out std_logic; V_flag:out std_logic); end component;
    component decrement_8bit is port (A:in std_logic_vector(7 downto 0); Result:out std_logic_vector(7 downto 0); Cout:out std_logic; V_flag:out std_logic); end component;
    component lsl_8bit is port (A:in std_logic_vector(7 downto 0); Result:out std_logic_vector(7 downto 0); Cout:out std_logic); end component;
    component lsr_8bit is port (A:in std_logic_vector(7 downto 0); Result:out std_logic_vector(7 downto 0); Cout:out std_logic); end component;
    component rol_8bit is port (A:in std_logic_vector(7 downto 0); Result:out std_logic_vector(7 downto 0); Cout:out std_logic); end component;
    component ror_8bit is port (A:in std_logic_vector(7 downto 0); Result:out std_logic_vector(7 downto 0); Cout:out std_logic); end component;

    -- Internal signals to hold the outputs of each operation block
    signal s_add_res, s_sub_res, s_mul_res, s_and_res, s_or_res, s_xor_res, s_not_res : std_logic_vector(7 downto 0);
    signal s_inc_res, s_dec_res, s_lsl_res, s_lsr_res, s_rol_res, s_ror_res : std_logic_vector(7 downto 0);
    signal s_add_c, s_add_v, s_sub_c, s_sub_v, s_mul_c, s_mul_v : std_logic;
    signal s_gt_res, s_lt_res, s_eq_res : std_logic;
    signal s_inc_c, s_inc_v, s_dec_c, s_dec_v : std_logic;
    signal s_lsl_c, s_lsr_c, s_rol_c, s_ror_c : std_logic;

    -- Internal signal to hold the multiplexer result before assigning to the output port
    signal s_result_internal : std_logic_vector(7 downto 0);

begin

    -- Instantiate all 16 operation blocks
    ADD_unit: adder_8bit port map(A=>Operand1, B=>Operand2, Cin=>'0', Sum=>s_add_res, Cout=>s_add_c, V_flag=>s_add_v);
    SUB_unit: subtractor_8bit port map(A=>Operand1, B=>Operand2, Difference=>s_sub_res, Cout=>s_sub_c, V_flag=>s_sub_v);
    MUL_unit: multiplier_8bit port map(A=>Operand1, B=>Operand2, Product=>s_mul_res, Cout=>s_mul_c, V_flag=>s_mul_v);
    GT_unit: greater_than_8bit port map(A=>Operand1, B=>Operand2, A_gt_B=>s_gt_res);
    LT_unit: less_than_8bit port map(A=>Operand1, B=>Operand2, A_lt_B=>s_lt_res);
    EQ_unit: equal_8bit port map(A=>Operand1, B=>Operand2, A_eq_B=>s_eq_res);
    AND_unit: and_8bit port map(A=>Operand1, B=>Operand2, Result=>s_and_res);
    OR_unit: or_8bit port map(A=>Operand1, B=>Operand2, Result=>s_or_res);
    XOR_unit: xor_8bit port map(A=>Operand1, B=>Operand2, Result=>s_xor_res);
    NOT_unit: not_8bit port map(A=>Operand1, Result=>s_not_res);
    INC_unit: increment_8bit port map(A=>Operand1, Result=>s_inc_res, Cout=>s_inc_c, V_flag=>s_inc_v);
    DEC_unit: decrement_8bit port map(A=>Operand1, Result=>s_dec_res, Cout=>s_dec_c, V_flag=>s_dec_v);
    LSL_unit: lsl_8bit port map(A=>Operand1, Result=>s_lsl_res, Cout=>s_lsl_c);
    LSR_unit: lsr_8bit port map(A=>Operand1, Result=>s_lsr_res, Cout=>s_lsr_c);
    ROL_unit: rol_8bit port map(A=>Operand1, Result=>s_rol_res, Cout=>s_rol_c);
    ROR_unit: ror_8bit port map(A=>Operand1, Result=>s_ror_res, Cout=>s_ror_c);

    -- Main multiplexer to select the final result and flags based on the Opcode
    with Opcode select
        s_result_internal <= s_add_res when "0000", -- ADD
                             s_sub_res when "0001", -- SUB
                             s_mul_res when "0010", -- MUL
                             ("0000000" & s_gt_res) when "0011", -- GT
                             ("0000000" & s_lt_res) when "0100", -- LT
                             ("0000000" & s_eq_res) when "0101", -- EQ
                             s_and_res when "0110", -- AND
                             s_or_res  when "0111", -- OR
                             s_xor_res when "1000", -- XOR
                             s_not_res when "1001", -- NOT
                             s_inc_res when "1010", -- INC A
                             s_dec_res when "1011", -- DEC A
                             s_lsl_res when "1100", -- LSL A
                             s_lsr_res when "1101", -- LSR A
                             s_rol_res when "1110", -- ROL A
                             s_ror_res when "1111", -- ROR A
                             (others => 'X') when others;

    with Opcode select
        Cout_flag <= s_add_c when "0000",
                     s_sub_c when "0001",
                     s_mul_c when "0010",
                     '0'     when "0011", 
                     '0'     when "0100", 
                     '0'     when "0101",
                     '0'     when "0110", 
                     '0'     when "0111", 
                     '0'     when "1000", 
                     '0'     when "1001",
                     s_inc_c when "1010",
                     s_dec_c when "1011",
                     s_lsl_c when "1100",
                     s_lsr_c when "1101",
                     s_rol_c when "1110",
                     s_ror_c when "1111",
                     'X'     when others;

    with Opcode select
        V_flag    <= s_add_v when "0000",
                     s_sub_v when "0001",
                     s_mul_v when "0010",
                     '0'     when "0011",
                     '0'     when "0100",
                     '0'     when "0101",
                     '0'     when "0110",
                     '0'     when "0111",
                     '0'     when "1000",
                     '0'     when "1001",
                     s_inc_v when "1010",
                     s_dec_v when "1011",
                     '0'     when "1100",
                     '0'     when "1101",
                     '0'     when "1110",
                     '0'     when "1111",
                     'X'     when others;

    -- Assign internal signal to final output port
    Result <= s_result_internal;

    -- Generate Zero and Negative flags based on the internal result signal
    Z_flag <= '1' when s_result_internal = x"00" else '0';
    N_flag <= s_result_internal(7);

end architecture Structural;
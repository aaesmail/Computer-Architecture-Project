LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY Control_Clock IS
    PORT (
        f9                                      : IN STD_LOGIC;
        f11                                     : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        memory_read_enable, memory_write_enable : IN STD_LOGIC;
        clk, mfc                                : IN STD_LOGIC;
        control_clk                             : OUT STD_LOGIC
    );
END Control_Clock;

ARCHITECTURE arch_Control_Clock OF Control_Clock IS

    COMPONENT D_FLIP_FLOP IS
        PORT (
            enable      : IN STD_LOGIC;
            d, clk, rst : IN STD_LOGIC;
            q           : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT Decoder_4x16 IS

        PORT (
            data_in  : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
            data_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            enable   : IN STD_LOGIC
        );

    END COMPONENT;

    SIGNAL hlt           : STD_LOGIC;
    SIGNAL memory_enable : STD_LOGIC;
    SIGNAL not_mfc       : STD_LOGIC;
    SIGNAL f9_out        : STD_LOGIC;
    SIGNAL nand_output   : STD_LOGIC;
    SIGNAL f11_decoded   : STD_LOGIC_VECTOR(15 DOWNTO 0);

BEGIN

    flip_flop : D_FLIP_FLOP PORT MAP('1', f9, clk, '0', f9_out);
    decoder   : Decoder_4x16 PORT MAP(f11, f11_decoded, '1');

    hlt           <= (NOT f11_decoded(9));
    memory_enable <= (memory_read_enable OR memory_write_enable);
    not_mfc       <= (NOT mfc);
    nand_output   <= (f9_out NAND memory_enable) NAND not_mfc;

    control_clk   <= (clk AND hlt) AND nand_output;

END ARCHITECTURE;

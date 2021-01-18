LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY Control_Clock IS
    PORT (
				f9                                      : IN STD_LOGIC;
        start_signal                            : IN STD_LOGIC;
        hlt                                     : IN STD_LOGIC;
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


    SIGNAL memory_enable : STD_LOGIC;
    SIGNAL not_mfc       : STD_LOGIC;
    SIGNAL f9_out        : STD_LOGIC;
		SIGNAL nand_output   : STD_LOGIC;
    SIGNAL hlt_out   		 : STD_LOGIC;
		

BEGIN

		flip_flop : D_FLIP_FLOP PORT MAP('1', f9, clk, start_signal, f9_out);
    hlt_bit : D_FLIP_FLOP PORT MAP('1', hlt, clk, start_signal, hlt_out);
		

    memory_enable <= (memory_read_enable OR memory_write_enable);
    not_mfc       <= (NOT mfc);
    nand_output   <= (f9_out NAND memory_enable) NAND not_mfc;

    control_clk   <= (clk AND NOT hlt_out) AND nand_output;

END ARCHITECTURE;

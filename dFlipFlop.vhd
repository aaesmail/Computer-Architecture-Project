LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY D_FLIP_FLOP IS
    PORT (
        enable      : IN STD_LOGIC;
        d, clk, rst : IN STD_LOGIC;
        q           : OUT STD_LOGIC
    );
END D_FLIP_FLOP;

ARCHITECTURE arch_D_FLIP_FLOP OF D_FLIP_FLOP IS

BEGIN

    q <= '0' WHEN rst = '1' ELSE
        d WHEN enable = '1' AND rst = '0' AND falling_edge(clk);

END ARCHITECTURE;

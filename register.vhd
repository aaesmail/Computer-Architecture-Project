LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY n_register IS
	PORT(
		clk, rst, enable : IN std_logic;
		d : IN std_logic_vector(15 DOWNTO 0);
		q : OUT std_logic_vector(15 DOWNTO 0)
	);
END n_register;

ARCHITECTURE a_register OF n_register IS
BEGIN
	PROCESS(clk, rst)
	BEGIN
		IF rst = '1' THEN
			q <= (OTHERS => '0');
		ELSIF rising_edge(clk) AND enable = '1' THEN
			q <= d;
		END IF;
	END PROCESS;
END a_register;

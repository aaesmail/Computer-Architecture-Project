LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY n_tristate IS
	PORT(
		enable : IN std_logic;
		d : IN std_logic_vector(15 DOWNTO 0);
		q : OUT std_logic_vector(15 DOWNTO 0)
	);
END n_tristate;

ARCHITECTURE a_tristate OF n_tristate IS
BEGIN
	q <= d WHEN enable = '1'
	else (OTHERS => 'Z');
END a_tristate;

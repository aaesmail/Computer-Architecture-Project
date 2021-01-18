LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;

ENTITY n_ram IS
	PORT(
		clk: IN std_logic;
		we: IN std_logic;
		address: IN std_logic_vector(15 DOWNTO 0);
		datain: IN std_logic_vector(15 DOWNTO 0);
		dataout: OUT std_logic_vector(15 DOWNTO 0)
	);
END n_ram;

ARCHITECTURE a_ram OF n_ram IS

	TYPE ram_type IS ARRAY(0 TO 2047) OF std_logic_vector(15 DOWNTO 0);
	SIGNAL ram: ram_type;
BEGIN

	PROCESS(clk) IS
	BEGIN

		IF falling_edge(clk) THEN
			IF we = '1' THEN
				ram(to_integer(unsigned(address(10 DOWNTO 0)))) <= datain;
			END IF;
		END IF;



	END PROCESS;

	dataout <= ram(to_integer(unsigned(address(10 DOWNTO 0))));

END a_ram;

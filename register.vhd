LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY n_register IS
	PORT (
		clk, rst, enable : IN STD_LOGIC;
		d : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		q : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END n_register;

ARCHITECTURE a_register OF n_register IS
BEGIN
	PROCESS (clk, rst)
	BEGIN
		IF rst = '1' THEN
			q <= (OTHERS => '0');
		ELSIF falling_edge(clk) AND enable = '1' THEN
			q <= d;
		END IF;
	END PROCESS;
END a_register;


--------------------------------------------------------------
-- n-register rising edge

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY n_register_rising IS
	PORT (
		clk, rst, enable : IN STD_LOGIC;
		d : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		q : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END n_register_rising;

ARCHITECTURE a_register_rising OF n_register_rising IS
BEGIN
	PROCESS (clk, rst)
	BEGIN
		IF rst = '1' THEN
			q <= (OTHERS => '0');
		ELSIF rising_edge(clk) AND enable = '1' THEN
			q <= d;
		END IF;
	END PROCESS;
END a_register_rising;


-------------------------------------------
-- n-register reset to 1

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY n_register_reset_1 IS
	PORT (
		clk, rst, enable : IN STD_LOGIC;
		d : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		q : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END n_register_reset_1;

ARCHITECTURE a_n_register_reset_1 OF n_register_reset_1 IS
BEGIN
	PROCESS (clk, rst)
	BEGIN
		IF rst = '1' THEN
			q <= ( 15 DOWNTO 1 => '0', (0)=> '1');
		ELSIF rising_edge(clk) AND enable = '1' THEN
			q <= d;
		END IF;
	END PROCESS;
END a_n_register_reset_1;
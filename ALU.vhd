LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

ENTITY n_alu IS
	PORT(
		CF, Clear_Carry, Set_Carry, clk: IN std_logic;
		F5: IN std_logic_vector(3 DOWNTO 0);
		Y, MAIN_BUS: IN std_logic_vector(15 DOWNTO 0);
		OUTPUT: OUT std_logic_vector(15 DOWNTO 0);
		Carry_Flag, Zero_Flag, Negative_Flag: OUT std_logic
	);
END n_alu;

ARCHITECTURE a_alu OF n_alu IS

signal carry_in: std_logic_vector(15 DOWNTO 0);
signal intermediate: std_logic_vector(15 DOWNTO 0);
signal result: std_logic_vector(16 DOWNTO 0);


BEGIN
	
	carry_in(15 DOWNTO 1) <= (OTHERS => '0');
	carry_in(0) <= (CF AND (NOT Clear_Carry) AND (NOT Set_Carry)) OR (Set_Carry);

	
	-- PROCESS(clk, MAIN_BUS, Y, F5, intermediate)
	-- VARIABLE temp: INTEGER;
	-- BEGIN
	-- IF clk = '1' THEN -- Changed from rising edge to level '1'
	-- 	IF F5 = "0001" THEN
	-- 		intermediate <= MAIN_BUS;
	-- 	ELSIF F5 = "0010" THEN
	-- 		result <= std_logic_vector(resize(signed(MAIN_BUS), 17) + resize(signed(Y), 17) + resize(signed(carry_in), 17));
	-- 	ELSIF F5 = "0011" THEN
	-- 		result <= std_logic_vector(resize(signed(MAIN_BUS), 17) - resize(signed(Y), 17) - resize(signed(carry_in), 17));
	-- 	ELSIF F5 = "0100" THEN
	-- 		intermediate <= (Y AND MAIN_BUS);
	-- 	ELSIF F5 = "0101" THEN
	-- 		intermediate <= (Y OR MAIN_BUS);
	-- 	ELSIF F5 = "0110" THEN
	-- 		intermediate <= (Y XOR MAIN_BUS);
	-- 	ELSIF F5 = "0111" THEN
	-- 		intermediate <= std_logic_vector(unsigned(Y) - 1);
	-- 	ELSIF F5 = "1000" THEN
	-- 		intermediate <= (OTHERS => '0');
	-- 	ELSIF F5 = "1001" THEN
	-- 		intermediate <= (NOT Y);
	-- 	ELSIF F5 = "1010" THEN
	-- 		intermediate <= std_logic_vector(shift_right(unsigned(Y), 1));
	-- 	ELSIF F5 = "1011" THEN
	-- 		intermediate <= std_logic_vector(rotate_right(unsigned(Y), 1));
	-- 	ELSIF F5 = "1100" THEN
	-- 		intermediate <= std_logic_vector(shift_right(signed(Y), 1));
	-- 	ELSIF F5 = "1101" THEN
	-- 		intermediate <= std_logic_vector(shift_left(unsigned(Y), 1));
	-- 	ELSIF F5 = "1110" THEN
	-- 		intermediate <= std_logic_vector(rotate_left(unsigned(Y), 1));
	-- 	END IF;

	-- END IF;
	-- END PROCESS;

	-- OUTPUT <= result(15 DOWNTO 0) WHEN ((F5 = "0010") OR (F5 = "0011"))
	-- ELSE intermediate;

	-- ----------------------CHANGED-----------------------
	result <= std_logic_vector(resize(signed(MAIN_BUS), 17) + resize(signed(Y), 17) + resize(signed(carry_in), 17)) WHEN F5 = "0010" ELSE
						std_logic_vector(resize(signed(MAIN_BUS), 17) - resize(signed(Y), 17) - resize(signed(carry_in), 17)) WHEN F5 = "0011" ELSE
						(OTHERS => 'Z');
						
	intermediate <= MAIN_BUS WHEN F5 = "0001" ELSE
									(Y AND MAIN_BUS) WHEN F5 = "0100" ELSE
									(Y OR MAIN_BUS) WHEN F5 = "0101" ELSE
									(Y XOR MAIN_BUS) WHEN F5 = "0110" ELSE
									std_logic_vector(unsigned(Y) - 1) WHEN F5 = "0111" ELSE
									(OTHERS => '0') WHEN F5 = "1000" ELSE
									(NOT Y) WHEN F5 = "1001" ELSE
									std_logic_vector(shift_right(unsigned(Y), 1)) WHEN F5 = "1010" ELSE
									std_logic_vector(rotate_right(unsigned(Y), 1)) WHEN F5 = "1011" ELSE
									std_logic_vector(shift_right(signed(Y), 1)) WHEN F5 = "1100" ELSE
									std_logic_vector(shift_left(unsigned(Y), 1)) WHEN F5 = "1101" ELSE
									std_logic_vector(rotate_left(unsigned(Y), 1)) WHEN F5 = "1110" ELSE
									(OTHERS => 'Z');

	OUTPUT <= result(15 DOWNTO 0) WHEN F5 = "0010" OR F5 = "0011" ELSE
						intermediate;
	--------------------------------------------------



	Zero_Flag <= '1' WHEN ((unsigned(result) = 0) AND ((F5 = "0010") OR (F5 = "0011")))
	ELSE '1' WHEN (unsigned(intermediate) = 0)
	ELSE '0';

	Carry_Flag <= result(16) WHEN ((F5 = "0010") OR (F5 = "0011"))
	ELSE '0';
	
	Negative_Flag <= result(15) WHEN ((F5 = "0010") OR (F5 = "0011"))
	ELSE intermediate(15);

END a_alu;

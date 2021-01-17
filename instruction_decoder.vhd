-- 4x9 decoder for branches
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
ENTITY branch_decoder IS
	PORT(
		F11: IN std_logic_vector(3 DOWNTO 0);
		BRANCHES: OUT std_logic_vector(7 DOWNTO 0);
		HALT: OUT std_logic
	);
END ENTITY branch_decoder;

ARCHITECTURE a_branch_decoder OF branch_decoder IS
BEGIN
	BRANCHES <= x"01" WHEN F11 = x"1" ELSE
						  x"02" WHEN F11 = x"2" ELSE 
							x"04" WHEN F11 = x"3" ELSE 
							x"08" WHEN F11 = x"4" ELSE 
							x"10" WHEN F11 = x"5" ELSE 
							x"20" WHEN F11 = x"6" ELSE 
							x"40" WHEN F11 = x"7" ELSE
	 						x"80" WHEN F11 = x"8" ELSE			 
							x"00";
	HALT <= '1' WHEN F11 = x"9" ELSE '0';
END a_branch_decoder;

-------------------------------------------------------------------------------------------------
-- Register 9-bit

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY n_9_register IS
	PORT (
		clk, rst, enable : IN STD_LOGIC;
		d : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
		q : OUT STD_LOGIC_VECTOR(8 DOWNTO 0)
	);
END n_9_register;

ARCHITECTURE a_9_register OF n_9_register IS
BEGIN
	PROCESS (clk, rst)
	BEGIN
		IF rst = '1' THEN
			q <= (OTHERS => '0');
		ELSIF rising_edge(clk) AND enable = '1' THEN
			q <= d;
		END IF;
	END PROCESS;
END a_9_register;
-------------------------------------------------------------------------------------------------
-- Instruction Decoder

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
ENTITY instruction_decoder IS
	PORT(
		start_signal: IN std_logic;
		CLOCK: IN std_logic;
		interrupt_bit: IN std_logic;
		CF: IN std_logic;
		ZF: IN std_logic;
		IR: IN std_logic_vector(15 DOWNTO 0);

		F1: OUT std_logic_vector(3 DOWNTO 0);
		F2: OUT std_logic_vector(2 DOWNTO 0);
		F3: OUT std_logic_vector(1 DOWNTO 0);
		F4: OUT std_logic_vector(1 DOWNTO 0);
		F5: OUT std_logic_vector(3 DOWNTO 0);
		F6: OUT std_logic_vector(1 DOWNTO 0);
		F7: OUT std_logic;
		F8: OUT std_logic_vector(1 DOWNTO 0);
		F9: OUT std_logic;
		F10: OUT std_logic_vector(1 DOWNTO 0);
		HALT: OUT std_logic
	);
END ENTITY instruction_decoder;

ARCHITECTURE a_instruction_decoder OF instruction_decoder IS

	COMPONENT n_9_register IS
		PORT (
			clk, rst, enable : IN STD_LOGIC;
			d : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
			q : OUT STD_LOGIC_VECTOR(8 DOWNTO 0)
		);
	END COMPONENT;
	COMPONENT branch_decoder IS
		PORT(
			F11: IN std_logic_vector(3 DOWNTO 0);
			BRANCHES: OUT std_logic_vector(7 DOWNTO 0);
			HALT: OUT std_logic
		);
	END COMPONENT;
	COMPONENT code_store_rom IS
		GENERIC(
				address_length: natural := 9;
				data_length: natural := 36
		);
		PORT(
				start_signal: IN std_logic;
				clock: IN std_logic;
				address: IN std_logic_vector((address_length - 1) DOWNTO 0);
				data_output: OUT std_logic_vector ((data_length - 1) DOWNTO 0)
		);
	END COMPONENT;
	COMPONENT pla IS
		PORT(
			interrupt_bit: IN std_logic;
			CF: IN std_logic;
			ZF: IN std_logic;
			IR: IN std_logic_vector(15 DOWNTO 0);
			in_next_address: IN std_logic_vector(8 DOWNTO 0);
			branches: IN std_logic_vector(7 DOWNTO 0);

			out_next_address: OUT std_logic_vector(8 DOWNTO 0)
		);
	END COMPONENT;

	SIGNAL uAR, next_address, current_address_for_test: std_logic_vector(8 DOWNTO 0);
	SIGNAL code_word: std_logic_vector(35 DOWNTO 0);
	SIGNAL F11: std_logic_vector(3 DOWNTO 0);
	SIGNAL branches: std_logic_vector(7 DOWNTO 0);

BEGIN
	
	branches_decoder: branch_decoder PORT MAP(F11, branches, HALT);
	code_store: code_store_rom PORT MAP(start_signal, CLOCK, uAR, code_word);
	p_l_a: pla PORT MAP(interrupt_bit, CF, ZF, IR, next_address, branches, uAR);
	current_address: n_9_register PORT MAP(CLOCK, start_signal, '1', uAR, current_address_for_test);


	next_address <= code_word(35 DOWNTO 27);
	F1 <= code_word(26 DOWNTO 23);
	F2 <= code_word(22 DOWNTO 20);
	F3 <= code_word(19 DOWNTO 18);
	F4 <= code_word(17 DOWNTO 16);
	F5 <= code_word(15 DOWNTO 12);
	F6 <= code_word(11 DOWNTO 10);
	F7 <= code_word(9);
	F8 <= code_word(8 DOWNTO 7);
	F9 <= code_word(6);
	F10 <= code_word(5 DOWNTO 4);
	F11 <= code_word(3 DOWNTO 0);


END a_instruction_decoder;
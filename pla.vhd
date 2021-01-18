-- PLA
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
ENTITY pla IS
	PORT(
		interrupt_bit: IN std_logic;
		CF: IN std_logic;
		ZF: IN std_logic;
		IR: IN std_logic_vector(15 DOWNTO 0);
		in_next_address: IN std_logic_vector(8 DOWNTO 0);
		branches: IN std_logic_vector(7 DOWNTO 0);

		out_next_address: OUT std_logic_vector(8 DOWNTO 0)
	);
END ENTITY pla;

ARCHITECTURE a_pla OF pla IS
	SIGNAL branch_enable: std_logic;
BEGIN

											-- B0 check if interrupt signal is set
	out_next_address <= o"700" WHEN branches(0) = '1' AND interrupt_bit = '1' ELSE
											-- B1 decode instruction (fetch src)
											o"100"  WHEN branches(1) = '1' AND (IR(15) = '0' OR IR(15 DOWNTO 12) = "1000") AND IR(11 DOWNTO 9) = "000" ELSE 	-- reg direct
											o"110"  WHEN branches(1) = '1' AND (IR(15) = '0' OR IR(15 DOWNTO 12) = "1000") AND IR(11 DOWNTO 9) = "001" ELSE 	-- reg indirect
											o"140"  WHEN branches(1) = '1' AND (IR(15) = '0' OR IR(15 DOWNTO 12) = "1000") AND IR(11 DOWNTO 10) = "10" ELSE	-- auto dec
											o"120"  WHEN branches(1) = '1' AND (IR(15) = '0' OR IR(15 DOWNTO 12) = "1000") AND IR(11 DOWNTO 10) = "01" ELSE	-- auto inc
											o"160"  WHEN branches(1) = '1' AND (IR(15) = '0' OR IR(15 DOWNTO 12) = "1000") AND IR(11 DOWNTO 10) = "11" ELSE	-- index
											-- B1 decode instruction (fetch dest)
											o"200"  WHEN branches(1) = '1' AND IR(15 DOWNTO 12) = "1001" AND IR(5 DOWNTO 3) = "000" ELSE		-- reg direct
											o"210"  WHEN branches(1) = '1' AND IR(15 DOWNTO 12) = "1001" AND IR(5 DOWNTO 3) = "001" ELSE		-- reg indirect
											o"240"  WHEN branches(1) = '1' AND IR(15 DOWNTO 12) = "1001" AND IR(5 DOWNTO 4) = "10" ELSE		-- auto dec
											o"220"  WHEN branches(1) = '1' AND IR(15 DOWNTO 12) = "1001" AND IR(5 DOWNTO 4) = "01" ELSE		-- auto inc
											o"260"  WHEN branches(1) = '1' AND IR(15 DOWNTO 12) = "1001" AND IR(5 DOWNTO 4) = "11" ELSE		-- index
											-- B1 decode instruction (others)
											o"400"  WHEN branches(1) = '1' AND IR(15 DOWNTO 12) = "1010"  ELSE																				-- branches
											o"500"  WHEN branches(1) = '1' AND IR(15 DOWNTO 12) = "1011" AND IR(11 DOWNTO 0) = "000000000000" ELSE		-- HLT
											o"510"  WHEN branches(1) = '1' AND IR(15 DOWNTO 12) = "1011" AND IR(11 DOWNTO 0) = "100000000000" ELSE		-- NOP
											o"600"  WHEN branches(1) = '1' AND IR(15 DOWNTO 12) = "1100" ELSE																					-- JSR
											o"610"  WHEN branches(1) = '1' AND IR(15 DOWNTO 12) = "1101" ELSE																					-- RTS
											o"620"  WHEN branches(1) = '1' AND IR(15 DOWNTO 12) = "1110" ELSE																					-- INT
											o"630"  WHEN branches(1) = '1' AND IR(15 DOWNTO 12) = "1111" ELSE																					-- IRET
											-- B2 check if source addressing mode is indirect
											in_next_address(8 DOWNTO 1) & NOT IR(9) WHEN branches(2) = '1'  ELSE
											-- B3 check which addressing mode for destination to be executed
											o"200"  WHEN branches(3) = '1' AND IR(5 DOWNTO 3) = "000" ELSE		-- reg direct
											o"210"  WHEN branches(3) = '1' AND IR(5 DOWNTO 3) = "001" ELSE		-- reg indirect
											o"240"  WHEN branches(3) = '1' AND IR(5 DOWNTO 4) = "10"  ELSE		-- auto dec
											o"220"  WHEN branches(3) = '1' AND IR(5 DOWNTO 4) = "01"  ELSE		-- auto inc
											o"260"  WHEN branches(3) = '1' AND IR(5 DOWNTO 4) = "11"  ELSE		-- index
											-- B4 check if destination addressing mode is indirect
											in_next_address(8 DOWNTO 1) & NOT IR(3) WHEN branches(4) = '1'  ELSE
											-- B5 check which ALU operation to do(2 operand operations)
											o"300"  WHEN branches(5) = '1' AND IR(15 DOWNTO 12) = "0000" ELSE		-- ADD
											o"301"  WHEN branches(5) = '1' AND IR(15 DOWNTO 12) = "0001" ELSE		-- ADC
											o"302"  WHEN branches(5) = '1' AND IR(15 DOWNTO 12) = "0010" ELSE		-- SUB
											o"303"  WHEN branches(5) = '1' AND IR(15 DOWNTO 12) = "0011" ELSE		-- SBC
											o"304"  WHEN branches(5) = '1' AND IR(15 DOWNTO 12) = "0100" ELSE		-- AND
											o"305"  WHEN branches(5) = '1' AND IR(15 DOWNTO 12) = "0101" ELSE		-- OR
											o"306"  WHEN branches(5) = '1' AND IR(15 DOWNTO 12) = "0110" ELSE		-- XOR
											o"307"  WHEN branches(5) = '1' AND IR(15 DOWNTO 12) = "0111" ELSE		-- CMP
											o"310"  WHEN branches(5) = '1' AND IR(15 DOWNTO 12) = "1000" ELSE		-- MOV
											-- B5 check which ALU operation to do(1 operand operations)
											o"320"  WHEN branches(5) = '1' AND IR(15 DOWNTO 12) = "1001" AND IR(11 DOWNTO 8) = "0000" ELSE		-- INC
											o"321"  WHEN branches(5) = '1' AND IR(15 DOWNTO 12) = "1001" AND IR(11 DOWNTO 8) = "0001" ELSE		-- DEC
											o"322"  WHEN branches(5) = '1' AND IR(15 DOWNTO 12) = "1001" AND IR(11 DOWNTO 8) = "0010" ELSE		-- INV
											o"323"  WHEN branches(5) = '1' AND IR(15 DOWNTO 12) = "1001" AND IR(11 DOWNTO 8) = "0011" ELSE		-- LSR
											o"324"  WHEN branches(5) = '1' AND IR(15 DOWNTO 12) = "1001" AND IR(11 DOWNTO 8) = "0100" ELSE		-- ROR
											o"325"  WHEN branches(5) = '1' AND IR(15 DOWNTO 12) = "1001" AND IR(11 DOWNTO 8) = "0101" ELSE		-- ASR
											o"326"  WHEN branches(5) = '1' AND IR(15 DOWNTO 12) = "1001" AND IR(11 DOWNTO 8) = "0110" ELSE		-- LSL
											o"327"  WHEN branches(5) = '1' AND IR(15 DOWNTO 12) = "1001" AND IR(11 DOWNTO 8) = "0111" ELSE		-- ROL
											o"330"  WHEN branches(5) = '1' AND IR(15 DOWNTO 12) = "1001" AND IR(11 DOWNTO 8) = "1000" ELSE		-- CLR
											-- B6 check if destination is register direct
											in_next_address(8 DOWNTO 1) & NOT (NOT IR(5) AND NOT IR(4) AND NOT IR(3)) WHEN branches(6) = '1'  ELSE
											-- B7 check whether to branch or not base on the opcode and the flags
											in_next_address(8 DOWNTO 5) & branch_enable & in_next_address(3 DOWNTO 0) WHEN branches(7) = '1' ELSE
											-- If no microbranch signal is specified
											in_next_address;

	branch_enable <= '1' WHEN (IR(11 DOWNTO 9) = "000") OR															-- BR
														(IR(11 DOWNTO 9) = "001" AND ZF = '1') OR 								-- BEQ
														(IR(11 DOWNTO 9) = "010" AND ZF = '0') OR 								-- BNEQ
														(IR(11 DOWNTO 9) = "011" AND CF = '1')	OR								-- BLO
														(IR(11 DOWNTO 9) = "011" AND (CF = '1' OR ZF = '1')) OR		-- BLS
														(IR(11 DOWNTO 9) = "011" AND (CF = '0' AND ZF = '0')) OR	-- BHI
														(IR(11 DOWNTO 9) = "011" AND CF = '0') ELSE								-- BHS
														'0';
END a_pla;
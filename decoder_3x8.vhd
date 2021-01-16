LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY Decoder_3x8 IS

	PORT (
		data_in : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
		data_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		enable : IN STD_LOGIC
	);

END Decoder_3x8;

ARCHITECTURE myModel OF Decoder_3x8 IS
BEGIN

	data_out <= "00000001" WHEN data_in & enable = "0001"
		ELSE
		"00000010" WHEN data_in & enable = "0011"
		ELSE
		"00000100" WHEN data_in & enable = "0101"
		ELSE
		"00001000" WHEN data_in & enable = "0111"

		ELSE
		"00010000" WHEN data_in & enable = "1001"

		ELSE
		"00100000" WHEN data_in & enable = "1011"

		ELSE
		"01000000" WHEN data_in & enable = "1101"

		ELSE
		"10000000" WHEN data_in & enable = "1111"
		ELSE
		"00000000";
END myModel;
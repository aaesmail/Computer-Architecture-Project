LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY Decoder_4x16 IS

	PORT (
		data_in : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
		data_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		enable : IN STD_LOGIC
	);

END Decoder_4x16;

ARCHITECTURE myModel OF Decoder_4x16 IS
BEGIN

	data_out <= "0000000000000001" WHEN data_in & enable = "00001"
		ELSE
		"0000000000000010" WHEN data_in & enable = "00011"
		ELSE
		"0000000000000100" WHEN data_in & enable = "00101"
		ELSE
		"0000000000001000" WHEN data_in & enable = "00111"
		ELSE
		"0000000000010000" WHEN data_in & enable = "01001"
		ELSE
		"0000000000100000" WHEN data_in & enable = "01011"
		ELSE
		"0000000001000000" WHEN data_in & enable = "01101"
		ELSE
		"0000000010000000" WHEN data_in & enable = "01111"
		ELSE
		"0000000100000000" WHEN data_in & enable = "10001"
		ELSE
		"0000001000000000" WHEN data_in & enable = "10011"
		ELSE
		"0000010000000000" WHEN data_in & enable = "10101"
		ELSE
		"0000100000000000" WHEN data_in & enable = "10111"
		ELSE
		"0001000000000000" WHEN data_in & enable = "11001"
		ELSE
		"0010000000000000" WHEN data_in & enable = "11011"
		ELSE
		"0100000000000000" WHEN data_in & enable = "11101"
		ELSE
		"1000000000000000" WHEN data_in & enable = "11111"
		ELSE
		"0000000000000000";
END myModel;
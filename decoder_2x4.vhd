LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY Decoder_2x4 IS

	PORT (
		data_in : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
		data_out : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		enable : IN STD_LOGIC
	);

END Decoder_2x4;

ARCHITECTURE myModel OF Decoder_2x4 IS
BEGIN

	data_out <= "0001" WHEN data_in & enable = "001"
		ELSE
		"0010" WHEN data_in & enable = "011"
		ELSE
		"0100" WHEN data_in & enable = "101"
		ELSE
		"1000" WHEN data_in & enable = "111"
		ELSE
		"0000";
END myModel;
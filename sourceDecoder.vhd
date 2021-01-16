LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY source_decoder IS
    PORT (
        ir0, ir1, ir2, ir6, ir7, ir8 : IN STD_LOGIC;
        f1 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        register_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        offset_out, address_out, mdr_out, z_out, src_out, dest_out, flag_out, sp_out, pc_out : OUT STD_LOGIC
    );
END source_decoder;

ARCHITECTURE a_source_decoder OF source_decoder IS

    COMPONENT Decoder_4x16 IS
        PORT (
            data_in : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
            data_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            enable : IN STD_LOGIC
        );
    END COMPONENT;

    COMPONENT Decoder_3x8 IS
        PORT (
            data_in : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
            data_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            enable : IN STD_LOGIC
        );
    END COMPONENT;

    SIGNAL f1_decoded : STD_LOGIC_VECTOR (15 DOWNTO 0);
    SIGNAL dest_decoded, src_decoded : STD_LOGIC_VECTOR (7 DOWNTO 0);
    SIGNAL dest_encoded, src_encoded : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL Rsrc_out, Rdest_out : STD_LOGIC_VECTOR (7 DOWNTO 0);

BEGIN

    dest_encoded <= ir2 & ir1 & ir0;
    src_encoded <= ir8 & ir7 & ir6;
    D_0 : Decoder_3x8 PORT MAP(dest_encoded, dest_decoded, '1');
    D_1 : Decoder_3x8 PORT MAP(src_encoded, src_decoded, '1');
    D_2 : Decoder_4x16 PORT MAP(f1, f1_decoded, '1');

    Rsrc_out <= (OTHERS => f1_decoded(4));
    Rdest_out <= (OTHERS => f1_decoded(5));

    register_out <= (dest_decoded AND Rdest_out) OR (src_decoded AND Rsrc_out);

    pc_out <= f1_decoded(1);
    mdr_out <= f1_decoded(2);
    z_out <= f1_decoded(3);
    src_out <= f1_decoded(8);
    dest_out <= f1_decoded(9);

    offset_out <= f1_decoded(10);
    address_out <= f1_decoded(11);
    flag_out <= f1_decoded(12);
    sp_out <= f1_decoded(13);

END a_source_decoder;
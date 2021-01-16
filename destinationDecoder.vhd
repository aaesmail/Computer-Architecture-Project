LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY destination_decoder IS
    PORT (
        ir0, ir1, ir2, ir6, ir7, ir8 : IN STD_LOGIC;
        f2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        f3, f4, f10 : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        register_in : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        pc_in, ir_in, sp_in : OUT STD_LOGIC;
        edit_flagRegister, flagRegister_in, mar_in, mdr_in, src_in, dest_in, set_ack, clr_ack, y_in : OUT STD_LOGIC
    );
END destination_decoder;

ARCHITECTURE a_destination_decoder OF destination_decoder IS
    COMPONENT Decoder_3x8 IS
        PORT (
            data_in : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
            data_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            enable : IN STD_LOGIC
        );
    END COMPONENT;

    COMPONENT Decoder_2x4 IS
        PORT (
            data_in : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
            data_out : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
            enable : IN STD_LOGIC
        );
    END COMPONENT;

    SIGNAL dest_decoded, src_decoded, f2_decoded : STD_LOGIC_VECTOR (7 DOWNTO 0);
    SIGNAL dest_encoded, src_encoded : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL Rsrc_in, Rdest_in : STD_LOGIC_VECTOR (7 DOWNTO 0);
    SIGNAL f10_decoded : STD_LOGIC_VECTOR (3 DOWNTO 0);
BEGIN

    dest_encoded <= ir2 & ir1 & ir0;
    src_encoded <= ir8 & ir7 & ir6;

    D_0 : Decoder_3x8 PORT MAP(dest_encoded, dest_decoded, '1');
    D_1 : Decoder_3x8 PORT MAP(src_encoded, src_decoded, '1');
    D_2 : Decoder_3x8 PORT MAP(f2, f2_decoded, '1');

    Rsrc_in <= (OTHERS => f2_decoded(4));
    Rdest_in <= (OTHERS => f2_decoded(5));

    register_in <= (dest_decoded AND Rdest_in) OR (src_decoded AND Rsrc_in);

    pc_in <= f2_decoded(1);
    ir_in <= f2_decoded(2);
    edit_flagRegister <= f2_decoded(3);
    flagRegister_in <= f2_decoded(6);
    sp_in <= f2_decoded(7);

    mar_in <= f3(0);
    mdr_in <= f3(1);
    src_in <= f4(0);
    dest_in <= f4(1);

    D_3 : Decoder_2x4 PORT MAP(f10, f10_decoded, '1');

    set_ack <= f10_decoded(1);
    clr_ack <= f10_decoded(2);
    y_in <= f10_decoded(3);
END a_destination_decoder;
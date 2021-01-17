LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY right_side IS
    PORT (
        data_bus : INOUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        ir : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        f1 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        f2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        f3, f4, f10 : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        clk, reset_registers : IN STD_LOGIC;
        ir_in, edit_flagRegister, flagRegister_in, mar_in, mdr_in, src_in, dest_in, set_ack, clr_ack, y_in : OUT STD_LOGIC;
        offset_out, address_out, mdr_out, z_out, src_out, dest_out, flag_out : OUT STD_LOGIC
    );
END right_side;

ARCHITECTURE a_right_side OF right_side IS
    COMPONENT source_decoder IS
        PORT (
            ir0, ir1, ir2, ir6, ir7, ir8 : IN STD_LOGIC;
            f1 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            register_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            offset_out, address_out, mdr_out, z_out, src_out, dest_out, flag_out, sp_out, pc_out : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT destination_decoder IS
        PORT (
            ir0, ir1, ir2, ir6, ir7, ir8 : IN STD_LOGIC;
            f2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            f3, f4, f10 : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            register_in : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            pc_in, ir_in, sp_in : OUT STD_LOGIC;
            edit_flagRegister, flagRegister_in, mar_in, mdr_in, src_in, dest_in, set_ack, clr_ack, y_in : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT general_registers IS
        PORT (
            data_bus : INOUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            register_out : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            register_in : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            clk, reset : IN STD_LOGIC;
            sp_in, pc_in, sp_out, pc_out : IN STD_LOGIC
        );
    END COMPONENT;

    SIGNAL register_out, register_in : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL sp_out, pc_out, pc_in, sp_in : STD_LOGIC;
BEGIN

    S_0 : source_decoder PORT MAP(ir(0), ir(1), ir(2), ir(6), ir(7), ir(8), f1, register_out, offset_out, address_out, mdr_out, z_out, src_out, dest_out, flag_out, sp_out, pc_out);
    D_0 : destination_decoder PORT MAP(ir(0), ir(1), ir(2), ir(6), ir(7), ir(8), f2, f3, f4, f10, register_in, pc_in, ir_in, sp_in, edit_flagRegister, flagRegister_in, mar_in, mdr_in, src_in, dest_in, set_ack, clr_ack, y_in);
    R_0 : general_registers PORT MAP(data_bus, register_out, register_in, clk, reset_registers, sp_in, pc_in, sp_out, pc_out);
END a_right_side;
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY general_registers IS
    PORT (
        data_bus : INOUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        register_out : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        register_in : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        clk : IN STD_LOGIC;
        sp_in, pc_in : IN STD_LOGIC;
        sp_out, pc_out : IN STD_LOGIC
    );
END general_registers;

ARCHITECTURE a_general_registers OF general_registers IS
    COMPONENT n_register IS
        PORT (
            clk, rst, enable : IN STD_LOGIC;
            d : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            q : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT n_tristate IS
        PORT (
            enable : IN STD_LOGIC;
            d : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            q : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
    END COMPONENT;

    TYPE register_array IS ARRAY(0 TO 7) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL register_outputs : register_array;
    SIGNAL sp_pc_in, sp_pc_out : STD_LOGIC_VECTOR(1 DOWNTO 0);

BEGIN

    loop1 : FOR i IN 0 TO 5 GENERATE
        R_x : n_register PORT MAP(clk, '0', register_in(i), data_bus, register_outputs(i));
        T_x : n_tristate PORT MAP(register_out(i), register_outputs(i), data_bus);
    END GENERATE;

    sp_pc_in(0) <= register_in(6) OR sp_in;
    sp_pc_in(1) <= register_in(7) OR pc_in;
    sp_pc_out(0) <= register_out(6) OR sp_out;
    sp_pc_out(1) <= register_out(7) OR pc_out;

    loop2 : FOR i IN 0 TO 1 GENERATE
        R_y : n_register PORT MAP(clk, '0', sp_pc_in(i), data_bus, register_outputs(i + 6));
        T_y : n_tristate PORT MAP(sp_pc_out(i), register_outputs(i + 6), data_bus);
    END GENERATE;
END a_general_registers;
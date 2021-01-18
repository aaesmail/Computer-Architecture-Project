LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;

ENTITY special_register_file IS
	PORT(
		-- General
		CLK: IN std_logic;
		RESET: IN std_logic;
		MAIN_BUS: IN std_logic_vector(15 DOWNTO 0);
		MAIN_BUS_OUT: OUT std_logic_vector(15 DOWNTO 0);
		-- IR
		IRin: IN std_logic;
		IR_OUT: OUT std_logic_vector(15 DOWNTO 0);
		OFFSETout, ADDRESSout: IN std_logic;
		-- Source
		SRCin: IN std_logic;
		SRCout: IN std_logic;
		-- Destination
		DSTin: IN std_logic;
		DSTout: IN std_logic;
		-- Z
		Zout: IN std_logic;
		ALU: IN std_logic_vector(15 DOWNTO 0);
		-- Y
		Yin: IN std_logic;
		CLR_Y: IN std_logic;
		Y_OUT: OUT std_logic_vector(15 DOWNTO 0);
		-- MAR
		MARin: IN std_logic;
		MAR_OUT: OUT std_logic_vector(15 DOWNTO 0);
		-- MDR
		MDRin, MDRout: IN std_logic;
		Memory_Data: IN std_logic_vector(15 DOWNTO 0);
		Memory_Read_Enable: IN std_logic;
		MDR_OUT: OUT std_logic_vector(15 DOWNTO 0);
		-- Flag
		ALU_CF, ALU_NF, ALU_ZF: IN std_logic;
		Edit_Flag, FLAGin, FLAGout: IN std_logic;
		CF, NF, ZF: OUT std_logic;
		F5: IN std_logic_vector(3 DOWNTO 0)


	);
END special_register_file;

ARCHITECTURE a_special_register_file OF special_register_file IS

COMPONENT n_register IS
	PORT(
		clk, rst, enable : IN std_logic;
		d : IN std_logic_vector(15 DOWNTO 0);
		q : OUT std_logic_vector(15 DOWNTO 0)
	);
END COMPONENT;

COMPONENT n_register_rising IS
	PORT (
		clk, rst, enable : IN STD_LOGIC;
		d : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		q : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END COMPONENT;

COMPONENT n_tristate IS
	PORT(
		enable : IN std_logic;
		d : IN std_logic_vector(15 DOWNTO 0);
		q : OUT std_logic_vector(15 DOWNTO 0)
	);
END COMPONENT;


SIGNAL temp_IR_out: std_logic_vector(15 DOWNTO 0);
SIGNAL BRANCH_OFFSET: std_logic_vector(15 DOWNTO 0);
SIGNAL JSR_ADDRESS: std_logic_vector(15 DOWNTO 0);
SIGNAL temp_Source_out: std_logic_vector(15 DOWNTO 0);
SIGNAL temp_Dest_out: std_logic_vector(15 DOWNTO 0);
SIGNAL temp_Z_out: std_logic_vector(15 DOWNTO 0);
SIGNAL mdr_in: std_logic_vector(15 DOWNTO 0);
SIGNAL temp_mdr_out: std_logic_vector(15 DOWNTO 0);
SIGNAL flag_in: std_logic_vector(15 DOWNTO 0);
SIGNAL ALU_ADJUST: std_logic_vector(15 DOWNTO 0);
SIGNAL temp_flag_out: std_logic_vector(15 DOWNTO 0);
SIGNAL MDR_ENABLE: std_logic;
SIGNAL FLAG_ENABLE: std_logic;
SIGNAL temp_y_reset: std_logic;
SIGNAL temp_z_in: std_logic;

BEGIN

	-- IR Register
	u1: n_register PORT MAP (CLK, RESET, IRin, MAIN_BUS, temp_IR_out);
	IR_OUT <= temp_IR_out;
	BRANCH_OFFSET(8 DOWNTO 0) <= temp_IR_out(8 DOWNTO 0);
	BRANCH_OFFSET(15 DOWNTO 9) <= (OTHERS => '0');
	JSR_ADDRESS(11 DOWNTO 0) <= temp_IR_out(11 DOWNTO 0);
	JSR_ADDRESS(15 DOWNTO 12) <= (OTHERS => '0');

	u13: n_tristate PORT MAP (OFFSETout, BRANCH_OFFSET, MAIN_BUS_OUT);
	u14: n_tristate PORT MAP (ADDRESSout, JSR_ADDRESS, MAIN_BUS_OUT);

	-- SOURCE Register
	u2: n_register PORT MAP (CLK, RESET, SRCin, MAIN_BUS, temp_Source_out);
	u3: n_tristate PORT MAP (SRCout, temp_Source_out, MAIN_BUS_OUT);
	
	-- Destination Register
	u4: n_register PORT MAP (CLK, RESET, DSTin, MAIN_BUS, temp_Dest_out);
	u5: n_tristate PORT MAP (DSTout, temp_Dest_out, MAIN_BUS_OUT);

	-- Z Register
	temp_z_in <= F5(0) OR F5(1) OR F5(2) OR F5(3);
	u6: n_register PORT MAP (CLK, RESET, temp_z_in, ALU, temp_Z_out);
	u7: n_tristate PORT MAP (Zout, temp_Z_out, MAIN_BUS_OUT);
	
	-- Y Register
	temp_y_reset <= (CLR_Y OR RESET);
	u8: n_register PORT MAP (CLK, temp_y_reset, Yin, MAIN_BUS, Y_OUT);

	-- MAR Register
	u9: n_register PORT MAP (CLK, RESET, MARin, MAIN_BUS, MAR_OUT);

	-- MDR Register
	mdr_in <= MAIN_BUS WHEN MDRin = '1'
	ELSE Memory_Data WHEN Memory_Read_Enable = '1';

	MDR_ENABLE <= MDRin OR Memory_Read_Enable;
	u10: n_register_rising PORT MAP (CLK, RESET, MDR_ENABLE, mdr_in, temp_mdr_out);
	MDR_OUT <= temp_mdr_out;
	u15: n_tristate PORT MAP (MDRout, temp_mdr_out, MAIN_BUS_OUT);

	-- Flag Register
	ALU_ADJUST(0) <= ALU_ZF;
	ALU_ADJUST(1) <= ALU_NF;
	ALU_ADJUST(2) <= ALU_CF;
	ALU_ADJUST(15 DOWNTO 3) <= (OTHERS => '0');

	flag_in <= MAIN_BUS WHEN FLAGin = '1'
	ELSE ALU_ADJUST WHEN Edit_Flag = '1';

	FLAG_ENABLE <= FLAGin OR Edit_Flag;
	u11: n_register PORT MAP (CLK, RESET, FLAG_ENABLE, flag_in, temp_flag_out);
	u12: n_tristate PORT MAP (FLAGout, temp_flag_out, MAIN_BUS_OUT);

	CF <= temp_flag_out(2);
	NF <= temp_flag_out(1);
	ZF <= temp_flag_out(0);

END a_special_register_file;

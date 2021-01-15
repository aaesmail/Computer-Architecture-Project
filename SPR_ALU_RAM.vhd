LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY SPR_ALU_RAM IS
	PORT(
		-- General
		CLK: IN std_logic;
		RESET: IN std_logic;
		MAIN_BUS: INOUT std_logic_vector(15 DOWNTO 0);
		-- Control Signals
		MDRin, MDRout, MemoryReadEnable, MemoryWriteEnable, MARin, Yin, CLRY, Zout, Edit_Flag, FLAGin, FLAGout, IRin, SRCin, DSTin, SRCout, DSTout, OFFSETout, ADDRESSout: IN std_logic;
		F5: IN std_logic_vector(3 DOWNTO 0);
		CLEAR_CARRY_SIGNAL, SET_CARRY_SIGNAL: IN std_logic;

		-- OUTPUTS
		IR_OUT: OUT std_logic_vector(15 DOWNTO 0);
		CF, NF, ZF: OUT std_logic
	);
END SPR_ALU_RAM;

ARCHITECTURE a_SPR_ALU_RAM OF SPR_ALU_RAM IS

COMPONENT special_register_file IS
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
		CF, NF, ZF: OUT std_logic

	);
END COMPONENT;

COMPONENT n_alu IS
	PORT(
		CF, Clear_Carry, Set_Carry, clk: IN std_logic;
		F5: IN std_logic_vector(3 DOWNTO 0);
		Y, MAIN_BUS: IN std_logic_vector(15 DOWNTO 0);
		OUTPUT: OUT std_logic_vector(15 DOWNTO 0);
		Carry_Flag, Zero_Flag, Negative_Flag: OUT std_logic
	);
END COMPONENT;

COMPONENT n_ram IS
	PORT(
		clk: IN std_logic;
		we: IN std_logic;
		address: IN std_logic_vector(15 DOWNTO 0);
		datain: IN std_logic_vector(15 DOWNTO 0);
		dataout: OUT std_logic_vector(15 DOWNTO 0)
	);
END COMPONENT;

COMPONENT n_tristate IS
	PORT(
		enable : IN std_logic;
		d : IN std_logic_vector(15 DOWNTO 0);
		q : OUT std_logic_vector(15 DOWNTO 0)
	);
END COMPONENT;

SIGNAL temp_ram_out: std_logic_vector(15 DOWNTO 0);
SIGNAL temp_mar_out: std_logic_vector(15 DOWNTO 0);
SIGNAL temp_mdr_out: std_logic_vector(15 DOWNTO 0);
SIGNAL temp_carry_flag: std_logic;
SIGNAL temp_y_out: std_logic_vector(15 DOWNTO 0);
SIGNAL temp_alu_out: std_logic_vector(15 DOWNTO 0);
SIGNAL temp_alu_carry, temp_alu_negative, temp_alu_zero: std_logic;

BEGIN

	u1: n_ram PORT MAP (CLK, MemoryWriteEnable, temp_mar_out, temp_mdr_out, temp_ram_out);

	u2: n_alu PORT MAP (temp_carry_flag, CLEAR_CARRY_SIGNAL, SET_CARRY_SIGNAL, CLK, F5, temp_y_out, MAIN_BUS, temp_alu_out, temp_alu_carry, temp_alu_zero, temp_alu_negative);

	u3: special_register_file PORT MAP (CLK, RESET, MAIN_BUS, MAIN_BUS, IRin, IR_OUT, OFFSETout, ADDRESSout, SRCin, SRCout, DSTin, DSTout, Zout, temp_alu_out, Yin, CLRY, temp_y_out, MARin, temp_mar_out, MDRin, MDRout, temp_ram_out, MemoryReadEnable, temp_mdr_out, temp_alu_carry, temp_alu_negative, temp_alu_zero, Edit_Flag, FLAGin, FLAGout, temp_carry_flag, NF, ZF);

	CF <= temp_carry_flag;

END a_SPR_ALU_RAM;

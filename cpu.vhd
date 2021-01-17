LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY one_bit_register IS
	PORT (
		clk, rst, enable : IN STD_LOGIC;
		d : IN STD_LOGIC;
		q : OUT STD_LOGIC
	);
END one_bit_register;

ARCHITECTURE a_one_bit_register OF one_bit_register IS
BEGIN
	PROCESS (clk, rst)
	BEGIN
		IF rst = '1' THEN
			q <= (OTHERS => '0');
		ELSIF rising_edge(clk) AND enable = '1' THEN
			q <= d;
		END IF;
	END PROCESS;
END a_one_bit_register;

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
ENTITY cpu IS
	PORT(
		start_signal: IN std_logic;
		CLOCK: IN std_logic;
		interrupt_bit: IN std_logic
	);
END ENTITY cpu;

ARCHITECTURE a_cpu OF cpu IS

	COMPONENT SPR_ALU_RAM IS
		PORT (
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
	END COMPONENT;
	COMPONENT right_side IS
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
	END COMPONENT;
	COMPONENT instruction_decoder IS
		PORT (
			-- INPUTS
			start_signal: IN std_logic;
			CLOCK: IN std_logic;
			interrupt_bit: IN std_logic;
			CF: IN std_logic;
			ZF: IN std_logic;
			IR: IN std_logic_vector(15 DOWNTO 0);
			--OUTPUTS
			F1: OUT std_logic_vector(3 DOWNTO 0);
			F2: OUT std_logic_vector(2 DOWNTO 0);
			F3: OUT std_logic_vector(1 DOWNTO 0);
			F4: OUT std_logic_vector(1 DOWNTO 0);
			F5: OUT std_logic_vector(3 DOWNTO 0);
			F6: OUT std_logic_vector(1 DOWNTO 0);
			F7: OUT std_logic;
			F8: OUT std_logic_vector(1 DOWNTO 0);
			F9: OUT std_logic;
			F10: OUT std_logic_vector(1 DOWNTO 0);
			HALT: OUT std_logic
		);
	END COMPONENT;

	SIGNAL CF, ZF, NF, HALT: std_logic;
	SIGNAL IR: std_logic_vector(15 DOWNTO 0);
	SIGNAL F1, F5: std_logic_vector(3 DOWNTO 0);
	SIGNAL F2: std_logic_vector(2 DOWNTO 0);
	SIGNAL F3, F4, F6, F8, F10: std_logic_vector(1 DOWNTO 0);
	SIGNAL F9: std_logic;
	SIGNAL DATA_BUS: std_logic_vector(15 DOWNTO 0);
	SIGNAL MDRin, MDRout, MemoryReadEnable, MemoryWriteEnable, MARin, Yin, CLRY, Zout, Edit_Flag, FLAGin, FLAGout, IRin, SRCin, DSTin, SRCout, DSTout, OFFSETout, ADDRESSout: std_logic;
	SIGNAL setACK, clearACK, CLEAR_CARRY_SIGNAL, SET_CARRY_SIGNAL, WMFC, interrupt_signal: std_logic;
	
BEGIN

instruction_decoder_module: instruction_decoder PORT MAP(start_signal, CLOCK, interrupt_signal, CF, ZF, IR, F1, F2, F3, F4, F5, F6, F7, F8, F9, F10, HALT);
right_side_modules: instruction_decoder PORT MAP(DATA_BUS, IR, F1, F2, F3, F4, F10, CLOCK, start_signal, IRin, Edit_Flag, FLAGin, MARin, MDRin, SRCin, DSTin, setACK, clearACK, Yin, OFFSETout, ADDRESSout, MDRout, Zout, SRCout, DSTout, FLAGout);
spr_alu_ram_modules: SPR_ALU_RAM PORT MAP(CLOCK, start_signal, DATA_BUS, MDRin, MDRout, MemoryReadEnable, MemoryWriteEnable, MARin, Yin, CLRY, Zout, Edit_Flag, FLAGin, FLAGout, IRin, SRCin, DSTin, SRCout, DSTout, OFFSETout, ADDRESSout, CLEAR_CARRY_SIGNAL, SET_CARRY_SIGNAL, IR, CF, NF, ZF)
interrupt_sig: one_bit_register PORT MAP(CLOCK, start_signal, '1', interrupt_bit, interrupt_signal);
CLEAR_CARRY_SIGNAL <= F8(1);
SET_CARRY_SIGNAL <= F8(0);
WMFC <= F9;

END a_cpu;
vsim -gui work.cpu
onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /cpu/start_signal
add wave -noupdate /cpu/interrupt_bit
add wave -noupdate /cpu/interrupt_signal
add wave -noupdate /cpu/CLOCK
add wave -noupdate /cpu/CONTROL_CLOCK_SIG
add wave -noupdate /cpu/DATA_BUS
add wave -noupdate /cpu/CF
add wave -noupdate /cpu/NF
add wave -noupdate /cpu/ZF
add wave -noupdate -expand /cpu/right_side_modules/R_0/register_outputs
add wave -noupdate -color Red -radix octal /cpu/instruction_decoder_module/current_address_for_test
add wave -noupdate -color Red -radix octal /cpu/instruction_decoder_module/uAR
add wave -noupdate -color Cyan /cpu/IR
add wave -noupdate /cpu/spr_alu_ram_modules/IR_OUT
add wave -noupdate -color White /cpu/spr_alu_ram_modules/u3/MDR_OUT
add wave -noupdate -color White /cpu/spr_alu_ram_modules/u3/MAR_OUT
add wave -noupdate -color White /cpu/spr_alu_ram_modules/u3/ALU
add wave -noupdate -color White /cpu/spr_alu_ram_modules/u3/temp_Z_out
add wave -noupdate -color White /cpu/spr_alu_ram_modules/u3/CLR_Y
add wave -noupdate -color White /cpu/spr_alu_ram_modules/u3/Y_OUT
add wave -noupdate /cpu//right_side_modules/S_0/pc_out
add wave -noupdate /cpu/right_side_modules/S_0/register_out
add wave -noupdate /cpu/F1
add wave -noupdate /cpu/F2
add wave -noupdate /cpu/F3
add wave -noupdate /cpu/F4
add wave -noupdate /cpu/F5
add wave -noupdate /cpu/F6
add wave -noupdate /cpu/F7
add wave -noupdate /cpu/F8
add wave -noupdate /cpu/F9
add wave -noupdate /cpu/F10
add wave -noupdate -color Red -radix octal /cpu/instruction_decoder_module/F11
add wave -noupdate /cpu/HALT
add wave -noupdate /cpu/MARin
add wave -noupdate /cpu/MDRin
add wave -noupdate /cpu/MDRout
add wave -noupdate /cpu/MFC
add wave -noupdate /cpu/MemoryReadEnable
add wave -noupdate /cpu/MemoryWriteEnable
add wave -noupdate /cpu/WMFC
add wave -noupdate /cpu/Yin
add wave -noupdate /cpu/Zout
add wave -noupdate /cpu/clearACK
add wave -noupdate /cpu/interrupt_ack
add wave -noupdate /cpu/setACK
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {196 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 304
configure wave -valuecolwidth 363
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {353 ps}
mem load -i {D:/CollegeSyllabus/4ThirdYearSyllabus/First-semester/Computer Architecture/Project/integration/Computer-Architecture-Project/test.mem} /cpu/spr_alu_ram_modules/u1/ram
force -freeze sim:/cpu/start_signal 1 0
force -freeze sim:/cpu/interrupt_bit 0 0
force -freeze sim:/cpu/CLOCK 0 0, 1 {50 ps} -r 100
run
force -freeze sim:/cpu/start_signal 0 0
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
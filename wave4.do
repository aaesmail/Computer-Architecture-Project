vsim -gui work.cpu
onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /cpu/start_signal
add wave -noupdate /cpu/interrupt_bit
add wave -noupdate /cpu/interrupt_signal
add wave -noupdate /cpu/CLOCK
add wave -noupdate /cpu/CONTROL_CLOCK_SIG
add wave -noupdate -radix decimal /cpu/DATA_BUS
add wave -noupdate /cpu/CF
add wave -noupdate /cpu/NF
add wave -noupdate /cpu/ZF
add wave -noupdate -label {General Purpose Registers} -radix decimal -childformat {{/cpu/right_side_modules/R_0/register_outputs(0) -radix decimal} {/cpu/right_side_modules/R_0/register_outputs(1) -radix decimal} {/cpu/right_side_modules/R_0/register_outputs(2) -radix decimal} {/cpu/right_side_modules/R_0/register_outputs(3) -radix decimal} {/cpu/right_side_modules/R_0/register_outputs(4) -radix decimal} {/cpu/right_side_modules/R_0/register_outputs(5) -radix decimal} {/cpu/right_side_modules/R_0/register_outputs(6) -radix decimal} {/cpu/right_side_modules/R_0/register_outputs(7) -radix decimal}} -expand -subitemconfig {/cpu/right_side_modules/R_0/register_outputs(0) {-radix decimal} /cpu/right_side_modules/R_0/register_outputs(1) {-radix decimal} /cpu/right_side_modules/R_0/register_outputs(2) {-radix decimal} /cpu/right_side_modules/R_0/register_outputs(3) {-radix decimal} /cpu/right_side_modules/R_0/register_outputs(4) {-radix decimal} /cpu/right_side_modules/R_0/register_outputs(5) {-radix decimal} /cpu/right_side_modules/R_0/register_outputs(6) {-radix decimal} /cpu/right_side_modules/R_0/register_outputs(7) {-radix decimal}} /cpu/right_side_modules/R_0/register_outputs
add wave -noupdate -color Red -radix octal /cpu/instruction_decoder_module/current_address_for_test
add wave -noupdate -color Red -radix octal /cpu/instruction_decoder_module/uAR
add wave -noupdate -color Cyan /cpu/IR
add wave -noupdate /cpu/HALT
add wave -noupdate /cpu/interrupt_ack
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {7332 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 304
configure wave -valuecolwidth 185
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
WaveRestoreZoom {6545 ps} {7971 ps}
mem load -i {D:/CollegeSyllabus/4ThirdYearSyllabus/First-semester/Computer Architecture/Project/integration/Computer-Architecture-Project/test-cases/our-assembler-output/c4.mem} /cpu/spr_alu_ram_modules/u1/ram
force -freeze sim:/cpu/start_signal 1 0
force -freeze sim:/cpu/interrupt_bit 0 0
force -freeze sim:/cpu/CLOCK 0 0, 1 {50 ps} -r 100
run
force -freeze sim:/cpu/start_signal 0 0
run 10000
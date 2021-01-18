vsim -gui work.cpu work.general_registers work.instruction_decoder
onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -color Green /cpu/start_signal
add wave -noupdate /cpu/CLOCK
add wave -noupdate /cpu/interrupt_bit
add wave -noupdate /cpu/CONTROL_CLOCK_SIG
add wave -noupdate -expand -subitemconfig {/general_registers/register_outputs(0) {-color Blue} /general_registers/register_outputs(1) {-color Blue} /general_registers/register_outputs(2) {-color Blue} /general_registers/register_outputs(3) {-color Blue} /general_registers/register_outputs(4) {-color Blue} /general_registers/register_outputs(5) {-color Blue} /general_registers/register_outputs(6) {-color Blue} /general_registers/register_outputs(7) {-color Blue}} /general_registers/register_outputs
add wave -noupdate /cpu/DATA_BUS
add wave -noupdate -color Red /cpu/CF
add wave -noupdate -color Red /cpu/NF
add wave -noupdate -color Red /cpu/ZF
add wave -noupdate -color Yellow /cpu/HALT
add wave -noupdate /cpu/IR
add wave -noupdate /cpu/MARin
add wave -noupdate /cpu/MFC
add wave -noupdate /cpu/WMFC
add wave -noupdate /cpu/interrupt_signal
add wave -noupdate /cpu/setACK
add wave -noupdate /cpu/MDRin
add wave -noupdate /cpu/MemoryReadEnable
add wave -noupdate /cpu/MemoryWriteEnable
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 188
configure wave -valuecolwidth 219
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
WaveRestoreZoom {0 ps} {4542 ps}

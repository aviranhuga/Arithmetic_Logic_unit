onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -color Cyan -subitemconfig {/alu_tb/A(7) {-color Cyan} /alu_tb/A(6) {-color Cyan} /alu_tb/A(5) {-color Cyan} /alu_tb/A(4) {-color Cyan} /alu_tb/A(3) {-color Cyan} /alu_tb/A(2) {-color Cyan} /alu_tb/A(1) {-color Cyan} /alu_tb/A(0) {-color Cyan}} /alu_tb/A
add wave -noupdate -color Cyan /alu_tb/B
add wave -noupdate -color Violet -subitemconfig {/alu_tb/Opcode(3) {-color Violet} /alu_tb/Opcode(2) {-color Violet} /alu_tb/Opcode(1) {-color Violet} /alu_tb/Opcode(0) {-color Violet}} /alu_tb/Opcode
add wave -noupdate /alu_tb/clock
add wave -noupdate -color Red /alu_tb/OUT_HI
add wave -noupdate -color Red /alu_tb/OUT_LO
add wave -noupdate -color Orange /alu_tb/innerStatus
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {671 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 137
configure wave -valuecolwidth 58
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
WaveRestoreZoom {640 ps} {813 ps}

onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /spi_tranceiver_test/clock
add wave -noupdate /spi_tranceiver_test/reset
add wave -noupdate /spi_tranceiver_test/en2x
add wave -noupdate /spi_tranceiver_test/sendFrame
add wave -noupdate -divider BUS
add wave -noupdate /spi_tranceiver_test/sClk
add wave -noupdate /spi_tranceiver_test/slaveSel
add wave -noupdate /spi_tranceiver_test/MISO
add wave -noupdate /spi_tranceiver_test/MOSI
add wave -noupdate -divider OUT
add wave -noupdate /spi_tranceiver_test/dataOut
add wave -noupdate /spi_tranceiver_test/dataWr
add wave -noupdate -divider IN
add wave -noupdate /spi_tranceiver_test/dataIn
add wave -noupdate /spi_tranceiver_test/dataValid
add wave -noupdate /spi_tranceiver_test/busy
add wave -noupdate -divider Command
add wave -noupdate /spi_tranceiver_test/U_1/commandData
add wave -noupdate /spi_tranceiver_test/U_1/data
add wave -noupdate /spi_tranceiver_test/U_1/sendCommand
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {8700480 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 273
configure wave -valuecolwidth 121
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1000
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {6870540 ps} {12120540 ps}

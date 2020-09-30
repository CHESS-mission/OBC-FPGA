onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /spi_test/clock
add wave -noupdate /spi_test/reset
add wave -noupdate -divider {Master out}
add wave -noupdate /spi_test/masterData
add wave -noupdate /spi_test/masterFull
add wave -noupdate /spi_test/masterWr
add wave -noupdate -divider {Master In}
add wave -noupdate /spi_test/slaveData
add wave -noupdate /spi_test/slaveEmpty
add wave -noupdate /spi_test/slaveRd
add wave -noupdate -divider {Slave In}
add wave -noupdate /spi_test/rx_data
add wave -noupdate /spi_test/rx_data_wr
add wave -noupdate -divider {Slave Out}
add wave -noupdate /spi_test/tx_data
add wave -noupdate /spi_test/tx_data_rd
add wave -noupdate /spi_test/tx_data_valid
add wave -noupdate -divider Bus
add wave -noupdate /spi_test/sClk
add wave -noupdate /spi_test/MOSI
add wave -noupdate /spi_test/MISO
add wave -noupdate /spi_test/SS_n
add wave -noupdate -divider SM
add wave -noupdate /spi_test/U_2/shiftreg0/SCK_fe
add wave -noupdate /spi_test/U_2/shiftreg0/SCK_re
add wave -noupdate /spi_test/U_2/shiftreg0/current_state
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {8295000 ps} 0}
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
WaveRestoreZoom {3827486 ps} {18022554 ps}

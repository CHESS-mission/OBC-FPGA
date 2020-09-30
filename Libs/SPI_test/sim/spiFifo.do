onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /spififo_tb/reset
add wave -noupdate /spififo_tb/clock
add wave -noupdate /spififo_tb/spififo_inst/en2x
add wave -noupdate /spififo_tb/spififo_inst/spitimer_inst/clockperiodcounter
add wave -noupdate -divider {Storage board}
add wave -noupdate -radix ascii /spififo_tb/spistorage_inst/spicharin
add wave -noupdate -radix ascii /spififo_tb/spistorage_inst/spidatain
add wave -noupdate -radix ascii /spififo_tb/spistorage_inst/spidataout
add wave -noupdate -radix ascii /spififo_tb/spistorage_inst/spicharout
add wave -noupdate -divider {Command interface}
add wave -noupdate -radix ascii /spififo_tb/masterdata
add wave -noupdate /spififo_tb/masterwr
add wave -noupdate /spififo_tb/masterfull
add wave -noupdate -radix ascii /spififo_tb/slavedata
add wave -noupdate /spififo_tb/slaveempty
add wave -noupdate /spififo_tb/slaverd
add wave -noupdate /spififo_tb/spififo_tester_inst/spicharinreadback
add wave -noupdate -divider Sender
add wave -noupdate /spififo_tb/spififo_tester_inst/spidataout
add wave -noupdate /spififo_tb/spififo_tester_inst/spisenddata
add wave -noupdate /spififo_tb/spififo_tester_inst/spisenddatadone
add wave -noupdate -radix ascii /spififo_tb/spififo_inst/dataout
add wave -noupdate /spififo_tb/spififo_inst/dataoutrd
add wave -noupdate /spififo_tb/spififo_inst/dataoutempty
add wave -noupdate -radix hexadecimal /spififo_tb/spififo_inst/dataoutenabled
add wave -noupdate /spififo_tb/spififo_inst/spitransceiver_inst/dataoutshift
add wave -noupdate -divider Receiver
add wave -noupdate /spififo_tb/spififo_inst/spitransceiver_inst/datainshift
add wave -noupdate -radix hexadecimal /spififo_tb/spififo_inst/spitransceiver_inst/datainshiftreg
add wave -noupdate -radix ascii /spififo_tb/spififo_inst/datain
add wave -noupdate -divider Timer
add wave -noupdate /spififo_tb/spififo_inst/sendframe
add wave -noupdate -divider Transceiver
add wave -noupdate -format Analog-Step -max 32.0 -radix unsigned /spififo_tb/spififo_inst/spitransceiver_inst/sequencecounter
add wave -noupdate /spififo_tb/spififo_inst/spitransceiver_inst/sequencecounterend
add wave -noupdate -divider SPI
add wave -noupdate /spififo_tb/ss_n
add wave -noupdate /spififo_tb/sclk
add wave -noupdate /spififo_tb/mosi
add wave -noupdate /spififo_tb/miso
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {79395000 ps} 0}
configure wave -namecolwidth 228
configure wave -valuecolwidth 65
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
WaveRestoreZoom {0 ps} {1050 us}

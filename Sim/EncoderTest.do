onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /encodertest/sysClk
add wave -noupdate /encodertest/dclk
add wave -noupdate /encodertest/din
add wave -noupdate /encodertest/uut/spi_int/dsel
add wave -noupdate -radix unsigned /encodertest/parmIdx
add wave -noupdate -radix unsigned /encodertest/parmVal
add wave -noupdate /encodertest/uut/spi_int/header
add wave -noupdate /encodertest/uut/spi_int/clkena
add wave -noupdate -radix unsigned /encodertest/uut/spi_int/op
add wave -noupdate /encodertest/uut/cmpCycleSel
add wave -noupdate /encodertest/uut/intCycleSel
add wave -noupdate -radix unsigned /encodertest/uut/cmp_tmr/encCycle
add wave -noupdate -radix unsigned /encodertest/uut/int_tmr/intCycle
add wave -noupdate /encodertest/uut/int_tmr/cycleLenShift
add wave -noupdate /encodertest/uut/cmp_tmr/init
add wave -noupdate /encodertest/uut/cmp_tmr/initClear
add wave -noupdate /encodertest/uut/cmp_tmr/ena
add wave -noupdate /encodertest/uut/cmp_tmr/enaState
add wave -noupdate /encodertest/uut/cmp_tmr/state
add wave -noupdate -color Orange /encodertest/uut/cmp_tmr/encClk
add wave -noupdate /encodertest/uut/cmp_tmr/cycCalcUpd
add wave -noupdate -radix unsigned /encodertest/uut/cmp_tmr/encCount
add wave -noupdate -radix unsigned /encodertest/uut/cmp_tmr/clockCounter
add wave -noupdate -radix unsigned /encodertest/uut/cmp_tmr/clockTotal
add wave -noupdate -color Tan /encodertest/uut/cmp_tmr/cycleDone
add wave -noupdate /encodertest/uut/int_tmr/initClear
add wave -noupdate /encodertest/uut/int_tmr/intCtrLoad
add wave -noupdate -radix unsigned /encodertest/uut/int_tmr/intClkUpd
add wave -noupdate -radix unsigned /encodertest/uut/int_tmr/intCount
add wave -noupdate /encodertest/uut/int_tmr/cycleDone
add wave -noupdate -radix unsigned /encodertest/uut/int_tmr/cycleClkCtr
add wave -noupdate -radix unsigned /encodertest/uut/int_tmr/cycleClkRem
add wave -noupdate -expand -label {Contributors: intClk} -group {Contributors: sim:/encodertest/uut/int_tmr/intClk} /encodertest/uut/int_tmr/clk
add wave -noupdate -expand -label {Contributors: intClk} -group {Contributors: sim:/encodertest/uut/int_tmr/intClk} -color Magenta /encodertest/uut/int_tmr/cycleDone
add wave -noupdate -expand -label {Contributors: intClk} -group {Contributors: sim:/encodertest/uut/int_tmr/intClk} /encodertest/uut/int_tmr/init
add wave -noupdate -expand -label {Contributors: intClk} -group {Contributors: sim:/encodertest/uut/int_tmr/intClk} /encodertest/uut/int_tmr/intClkUpd
add wave -noupdate -expand -label {Contributors: intClk} -group {Contributors: sim:/encodertest/uut/int_tmr/intClk} -color Yellow /encodertest/uut/int_tmr/intClk
add wave -noupdate -expand -label {Contributors: intClkUpd} -group {Contributors: sim:/encodertest/uut/int_tmr/intClkUpd} -radix unsigned /encodertest/uut/int_tmr/cmpLE/a
add wave -noupdate -expand -label {Contributors: intClkUpd} -group {Contributors: sim:/encodertest/uut/int_tmr/intClkUpd} -radix unsigned /encodertest/uut/int_tmr/cmpLE/b
add wave -noupdate /encodertest/uut/cmp_tmr/cycleClocksOut/shift
add wave -noupdate -radix unsigned /encodertest/uut/cmp_tmr/cycleClocksOut/shiftReg
add wave -noupdate /encodertest/uut/spi_int/state
add wave -noupdate -radix unsigned /encodertest/uut/spi_int/op
add wave -noupdate -radix unsigned /encodertest/readCycleClocks
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {48865385 ps} 0} {{Cursor 2} {12806422 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 290
configure wave -valuecolwidth 65
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
WaveRestoreZoom {31802881 ps} {65927889 ps}

onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /cmptmrtest/uut/clk
add wave -noupdate /cmptmrtest/din
add wave -noupdate /cmptmrtest/dshift
add wave -noupdate /cmptmrtest/init
add wave -noupdate /cmptmrtest/ena
add wave -noupdate /cmptmrtest/uut/enaState
add wave -noupdate /cmptmrtest/uut/clkCtrEna
add wave -noupdate /cmptmrtest/uut/cycleSel
add wave -noupdate /cmptmrtest/uut/state
add wave -noupdate /cmptmrtest/encClk
add wave -noupdate -divider cycleLenReg
add wave -noupdate -radix unsigned /cmptmrtest/uut/encCycle
add wave -noupdate -divider DownCounter
add wave -noupdate /cmptmrtest/uut/cycCalcUpd
add wave -noupdate /cmptmrtest/uut/initClear
add wave -noupdate /cmptmrtest/uut/cycDoneUpd
add wave -noupdate /cmptmrtest/uut/loadCycCtr
add wave -noupdate -radix unsigned /cmptmrtest/uut/encCount
add wave -noupdate /cmptmrtest/uut/cycleDone
add wave -noupdate -divider {encClkCtr A Input}
add wave -noupdate /cmptmrtest/uut/clkCtrEna
add wave -noupdate /cmptmrtest/uut/clkCtrClr
add wave -noupdate -radix unsigned /cmptmrtest/uut/clockCounter
add wave -noupdate -divider Multiplier
add wave -noupdate -radix unsigned /cmptmrtest/uut/clockMult/dataa
add wave -noupdate /cmptmrtest/uut/cycCalcUpd
add wave -noupdate -radix unsigned /cmptmrtest/uut/clockMult/datab
add wave -noupdate -radix unsigned /cmptmrtest/uut/encCntCLks
add wave -noupdate -radix unsigned /cmptmrtest/uut/encoderClocks
add wave -noupdate -divider AccumAdder
add wave -noupdate /cmptmrtest/uut/cycCalcUpd
add wave -noupdate /cmptmrtest/uut/clrClockTotal
add wave -noupdate -radix unsigned /cmptmrtest/uut/clockTotal
add wave -noupdate -divider CycleClockAdder
add wave -noupdate /cmptmrtest/uut/cycChkUpd
add wave -noupdate -radix unsigned /cmptmrtest/uut/encCntCLks
add wave -noupdate -radix unsigned /cmptmrtest/uut/clockTotal
add wave -noupdate -radix unsigned /cmptmrtest/uut/cycleClocks
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {322243 ps} 0} {{Cursor 2} {5345000 ps} 0}
quietly wave cursor active 2
configure wave -namecolwidth 206
configure wave -valuecolwidth 53
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
WaveRestoreZoom {0 ps} {6300 ns}

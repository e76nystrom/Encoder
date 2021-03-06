onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /inttmrtest/uut/clk
add wave -noupdate /inttmrtest/uut/din
add wave -noupdate /inttmrtest/uut/dshift
add wave -noupdate /inttmrtest/uut/intClk
add wave -noupdate -radix unsigned /inttmrtest/cycleClocks
add wave -noupdate -divider Control
add wave -noupdate /inttmrtest/uut/init
add wave -noupdate -divider intCycle
add wave -noupdate -radix unsigned /inttmrtest/uut/intCycle
add wave -noupdate -divider intCounter
add wave -noupdate /inttmrtest/uut/initClear
add wave -noupdate /inttmrtest/uut/intClkUpd
add wave -noupdate /inttmrtest/uut/intRun
add wave -noupdate /inttmrtest/uut/cycleDone
add wave -noupdate /inttmrtest/uut/intCtrLoad
add wave -noupdate -radix unsigned /inttmrtest/uut/intCount
add wave -noupdate -divider clkCtr
add wave -noupdate /inttmrtest/uut/cycleClkClr
add wave -noupdate -radix unsigned /inttmrtest/uut/cycleClkCtr
add wave -noupdate -divider Subtractor
add wave -noupdate /inttmrtest/uut/subASel
add wave -noupdate /inttmrtest/uut/subBSel
add wave -noupdate /inttmrtest/uut/subLoad
add wave -noupdate -radix unsigned /inttmrtest/uut/subA
add wave -noupdate -radix unsigned /inttmrtest/uut/subB
add wave -noupdate /inttmrtest/uut/cmpLE/cmp
add wave -noupdate -expand -group {int_processs
} /inttmrtest/uut/init
add wave -noupdate -expand -group {int_processs
} /inttmrtest/uut/initClear
add wave -noupdate -expand -group {int_processs
} /inttmrtest/uut/intClkUpd
add wave -noupdate -expand -group {int_processs
} /inttmrtest/uut/intClk
add wave -noupdate /inttmrtest/uut/intState
add wave -noupdate -expand -label {Contributors: intState} -group {Contributors: sim:/inttmrtest/uut/intState} /inttmrtest/uut/clk
add wave -noupdate -expand -label {Contributors: intState} -group {Contributors: sim:/inttmrtest/uut/intState} -color Red /inttmrtest/uut/encCycleDone
add wave -noupdate -expand -label {Contributors: intState} -group {Contributors: sim:/inttmrtest/uut/intState} -color Gold /inttmrtest/uut/cycleDone
add wave -noupdate -expand -label {Contributors: intState} -group {Contributors: sim:/inttmrtest/uut/intState} /inttmrtest/uut/init
add wave -noupdate -expand -label {Contributors: intState} -group {Contributors: sim:/inttmrtest/uut/intState} /inttmrtest/uut/intClkUpd
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {495000 ps} 0} {{Cursor 2} {594792 ps} 0}
quietly wave cursor active 2
configure wave -namecolwidth 196
configure wave -valuecolwidth 100
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
WaveRestoreZoom {453453 ps} {847203 ps}

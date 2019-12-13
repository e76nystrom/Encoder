onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /freqgenctrtest/uut/clk
add wave -noupdate /freqgenctrtest/uut/din
add wave -noupdate /freqgenctrtest/uut/dshift
add wave -noupdate /freqgenctrtest/uut/freqShift
add wave -noupdate -radix unsigned -childformat {{/freqgenctrtest/uut/freqVal(3) -radix unsigned} {/freqgenctrtest/uut/freqVal(2) -radix unsigned} {/freqgenctrtest/uut/freqVal(1) -radix unsigned} {/freqgenctrtest/uut/freqVal(0) -radix unsigned}} -subitemconfig {/freqgenctrtest/uut/freqVal(3) {-height 15 -radix unsigned} /freqgenctrtest/uut/freqVal(2) {-height 15 -radix unsigned} /freqgenctrtest/uut/freqVal(1) {-height 15 -radix unsigned} /freqgenctrtest/uut/freqVal(0) {-height 15 -radix unsigned}} /freqgenctrtest/uut/freqVal
add wave -noupdate /freqgenctrtest/uut/countShift
add wave -noupdate -radix unsigned -childformat {{/freqgenctrtest/uut/countVal(4) -radix unsigned} {/freqgenctrtest/uut/countVal(3) -radix unsigned} {/freqgenctrtest/uut/countVal(2) -radix unsigned} {/freqgenctrtest/uut/countVal(1) -radix unsigned} {/freqgenctrtest/uut/countVal(0) -radix unsigned}} -subitemconfig {/freqgenctrtest/uut/countVal(4) {-height 15 -radix unsigned} /freqgenctrtest/uut/countVal(3) {-height 15 -radix unsigned} /freqgenctrtest/uut/countVal(2) {-height 15 -radix unsigned} /freqgenctrtest/uut/countVal(1) {-height 15 -radix unsigned} /freqgenctrtest/uut/countVal(0) {-height 15 -radix unsigned}} /freqgenctrtest/uut/countVal
add wave -noupdate /freqgenctrtest/uut/countSel
add wave -noupdate /freqgenctrtest/uut/load
add wave -noupdate -radix unsigned /freqgenctrtest/uut/freqCounter
add wave -noupdate -radix unsigned /freqgenctrtest/uut/outputCounter
add wave -noupdate /freqgenctrtest/uut/state
add wave -noupdate /freqgenctrtest/uut/pulseOut
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {480942 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 215
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
WaveRestoreZoom {0 ps} {5250 ns}

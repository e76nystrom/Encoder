onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /dbgclktest/a
add wave -noupdate /dbgclktest/b
add wave -noupdate /dbgclktest/a_out
add wave -noupdate /dbgclktest/b_out
add wave -noupdate -radix unsigned /dbgclktest/op
add wave -noupdate /dbgclktest/dshift
add wave -noupdate /dbgclktest/din
add wave -noupdate -radix unsigned /dbgclktest/uut/clock/counter
add wave -noupdate -expand -label {Contributors: dCtlReg} -group {Contributors: sim:/fpgaencbits/dCtlReg} /dbgclktest/din
add wave -noupdate -expand -label {Contributors: dCtlReg} -group {Contributors: sim:/fpgaencbits/dCtlReg} /dbgclktest/dshift
add wave -noupdate -expand -label {Contributors: dCtlReg} -group {Contributors: sim:/fpgaencbits/dCtlReg} /dbgclktest/uut/dbgctl/clk
add wave -noupdate -expand -label {Contributors: dCtlReg} -group {Contributors: sim:/fpgaencbits/dCtlReg} /dbgclktest/uut/dbgctl/ctl_load
add wave -noupdate -expand -label {Contributors: dCtlReg} -group {Contributors: sim:/fpgaencbits/dCtlReg} /dbgclktest/uut/dbgctl/ctl_shift
add wave -noupdate -expand -label {Contributors: dCtlReg} -group {Contributors: sim:/fpgaencbits/dCtlReg} /dbgclktest/uut/dbgctl/din
add wave -noupdate -expand -label {Contributors: dCtlReg} -group {Contributors: sim:/fpgaencbits/dCtlReg} -radix unsigned -childformat {{/dbgclktest/uut/dbgctl/sreg(3) -radix unsigned} {/dbgclktest/uut/dbgctl/sreg(2) -radix unsigned} {/dbgclktest/uut/dbgctl/sreg(1) -radix unsigned} {/dbgclktest/uut/dbgctl/sreg(0) -radix unsigned}} -subitemconfig {/dbgclktest/uut/dbgctl/sreg(3) {-height 15 -radix unsigned} /dbgclktest/uut/dbgctl/sreg(2) {-height 15 -radix unsigned} /dbgclktest/uut/dbgctl/sreg(1) {-height 15 -radix unsigned} /dbgclktest/uut/dbgctl/sreg(0) {-height 15 -radix unsigned}} /dbgclktest/uut/dbgctl/sreg
add wave -noupdate /dbgclktest/uut/dbgctl/din
add wave -noupdate /dbgclktest/uut/dshift
add wave -noupdate /dbgclktest/uut/clk
add wave -noupdate -radix unsigned -childformat {{/dbgclktest/uut/dbgctl/sreg(3) -radix unsigned} {/dbgclktest/uut/dbgctl/sreg(2) -radix unsigned} {/dbgclktest/uut/dbgctl/sreg(1) -radix unsigned} {/dbgclktest/uut/dbgctl/sreg(0) -radix unsigned}} -subitemconfig {/dbgclktest/uut/dbgctl/sreg(3) {-height 15 -radix unsigned} /dbgclktest/uut/dbgctl/sreg(2) {-height 15 -radix unsigned} /dbgclktest/uut/dbgctl/sreg(1) {-height 15 -radix unsigned} /dbgclktest/uut/dbgctl/sreg(0) {-height 15 -radix unsigned}} /dbgclktest/uut/dbgctl/sreg
add wave -noupdate -radix unsigned /dbgclktest/uut/clock/freq_val
add wave -noupdate -radix unsigned /dbgclktest/uut/count
add wave -noupdate /dbgclktest/uut/state
add wave -noupdate -radix unsigned /dbgclktest/uut/sq
add wave -noupdate /dbgclktest/uut/dbgPulse
add wave -noupdate /dbgclktest/uut/freqEna
add wave -noupdate -radix unsigned /fpgaencbits/dCtlReg
add wave -noupdate -radix unsigned /dbgclktest/uut/counter
add wave -noupdate /dbgclktest/uut/countZero
add wave -noupdate /dbgclktest/uut/countDown
add wave -noupdate /dbgclktest/load
add wave -noupdate /dbgclktest/uut/pulseOut
add wave -noupdate /dbgclktest/uut/countShift
add wave -noupdate /dbgclktest/uut/freqShift
add wave -noupdate /dbgclktest/uut/countLoad
add wave -noupdate /dbgclktest/uut/countZero
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2743770 ps} 0} {{Cursor 2} {1680000 ps} 0}
quietly wave cursor active 2
configure wave -namecolwidth 251
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

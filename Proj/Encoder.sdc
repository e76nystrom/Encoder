## Generated SDC file "Encoder.sdc"

## Copyright (C) 1991-2013 Altera Corporation
## Your use of Altera Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Altera Program License 
## Subscription Agreement, Altera MegaCore Function License 
## Agreement, or other applicable license agreement, including, 
## without limitation, that your use is for the sole purpose of 
## programming logic devices manufactured by Altera and sold by 
## Altera or its authorized distributors.  Please refer to the 
## applicable agreement for further details.


## VENDOR  "Altera"
## PROGRAM "Quartus II"
## VERSION "Version 13.0.1 Build 232 06/12/2013 Service Pack 1 SJ Web Edition"

## DATE    "Thu Dec 05 14:06:08 2019"

##
## DEVICE  "EP4CE22F17C6"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {sysClk} -period 20.000 -waveform { 0.000 10.000 } [get_ports {sysClk}]


#**************************************************************
# Create Generated Clock
#**************************************************************

create_generated_clock -name {sys_Clk|altpll_component|auto_generated|pll1|clk[0]} -source [get_pins {sys_Clk|altpll_component|auto_generated|pll1|inclk[0]}] -duty_cycle 50.000 -multiply_by 1 -master_clock {sysClk} [get_pins {sys_Clk|altpll_component|auto_generated|pll1|clk[0]}] 


#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************

set_clock_uncertainty -rise_from [get_clocks {sys_Clk|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {sys_Clk|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {sys_Clk|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {sys_Clk|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {sys_Clk|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {sys_Clk|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {sys_Clk|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {sys_Clk|altpll_component|auto_generated|pll1|clk[0]}]  0.020  


#**************************************************************
# Set Input Delay
#**************************************************************

set_input_delay -add_delay -max -clock [get_clocks {sys_Clk|altpll_component|auto_generated|pll1|clk[0]}]  3.000 [get_ports {dclk}]
set_input_delay -add_delay -min -clock [get_clocks {sys_Clk|altpll_component|auto_generated|pll1|clk[0]}]  2.000 [get_ports {dclk}]
set_input_delay -add_delay -max -clock [get_clocks {sys_Clk|altpll_component|auto_generated|pll1|clk[0]}]  3.000 [get_ports {din}]
set_input_delay -add_delay -min -clock [get_clocks {sys_Clk|altpll_component|auto_generated|pll1|clk[0]}]  2.000 [get_ports {din}]
set_input_delay -add_delay -max -clock [get_clocks {sys_Clk|altpll_component|auto_generated|pll1|clk[0]}]  3.000 [get_ports {dsel}]
set_input_delay -add_delay -min -clock [get_clocks {sys_Clk|altpll_component|auto_generated|pll1|clk[0]}]  2.000 [get_ports {dsel}]
set_input_delay -add_delay -max -clock [get_clocks {sys_Clk|altpll_component|auto_generated|pll1|clk[0]}]  3.000 [get_ports {encClk}]
set_input_delay -add_delay -min -clock [get_clocks {sys_Clk|altpll_component|auto_generated|pll1|clk[0]}]  2.000 [get_ports {encClk}]
set_input_delay -add_delay -max -clock [get_clocks {sys_Clk|altpll_component|auto_generated|pll1|clk[0]}]  3.000 [get_ports {initialReset}]
set_input_delay -add_delay -min -clock [get_clocks {sys_Clk|altpll_component|auto_generated|pll1|clk[0]}]  2.000 [get_ports {initialReset}]
set_input_delay -add_delay -max -clock [get_clocks {sys_Clk|altpll_component|auto_generated|pll1|clk[0]}]  3.000 [get_ports {start}]
set_input_delay -add_delay -min -clock [get_clocks {sys_Clk|altpll_component|auto_generated|pll1|clk[0]}]  2.000 [get_ports {start}]
set_input_delay -add_delay -max -clock [get_clocks {sys_Clk|altpll_component|auto_generated|pll1|clk[0]}]  3.000 [get_ports {sysClk}]
set_input_delay -add_delay -min -clock [get_clocks {sys_Clk|altpll_component|auto_generated|pll1|clk[0]}]  2.000 [get_ports {sysClk}]


#**************************************************************
# Set Output Delay
#**************************************************************

set_output_delay -add_delay -max -clock [get_clocks {sys_Clk|altpll_component|auto_generated|pll1|clk[0]}]  3.000 [get_ports {dbg0}]
set_output_delay -add_delay -min -clock [get_clocks {sys_Clk|altpll_component|auto_generated|pll1|clk[0]}]  2.000 [get_ports {dbg0}]
set_output_delay -add_delay -max -clock [get_clocks {sys_Clk|altpll_component|auto_generated|pll1|clk[0]}]  3.000 [get_ports {dbg1}]
set_output_delay -add_delay -min -clock [get_clocks {sys_Clk|altpll_component|auto_generated|pll1|clk[0]}]  2.000 [get_ports {dbg1}]
set_output_delay -add_delay -max -clock [get_clocks {sys_Clk|altpll_component|auto_generated|pll1|clk[0]}]  3.000 [get_ports {dbg2}]
set_output_delay -add_delay -min -clock [get_clocks {sys_Clk|altpll_component|auto_generated|pll1|clk[0]}]  2.000 [get_ports {dbg2}]
set_output_delay -add_delay -max -clock [get_clocks {sys_Clk|altpll_component|auto_generated|pll1|clk[0]}]  3.000 [get_ports {dbg3}]
set_output_delay -add_delay -min -clock [get_clocks {sys_Clk|altpll_component|auto_generated|pll1|clk[0]}]  2.000 [get_ports {dbg3}]
set_output_delay -add_delay -max -clock [get_clocks {sys_Clk|altpll_component|auto_generated|pll1|clk[0]}]  3.000 [get_ports {dout}]
set_output_delay -add_delay -min -clock [get_clocks {sys_Clk|altpll_component|auto_generated|pll1|clk[0]}]  2.000 [get_ports {dout}]
set_output_delay -add_delay -max -clock [get_clocks {sys_Clk|altpll_component|auto_generated|pll1|clk[0]}]  3.000 [get_ports {intClk}]
set_output_delay -add_delay -min -clock [get_clocks {sys_Clk|altpll_component|auto_generated|pll1|clk[0]}]  2.000 [get_ports {intClk}]
set_output_delay -add_delay -max -clock [get_clocks {sys_Clk|altpll_component|auto_generated|pll1|clk[0]}]  3.000 [get_ports {led[0]}]
set_output_delay -add_delay -min -clock [get_clocks {sys_Clk|altpll_component|auto_generated|pll1|clk[0]}]  2.000 [get_ports {led[0]}]
set_output_delay -add_delay -max -clock [get_clocks {sys_Clk|altpll_component|auto_generated|pll1|clk[0]}]  3.000 [get_ports {led[1]}]
set_output_delay -add_delay -min -clock [get_clocks {sys_Clk|altpll_component|auto_generated|pll1|clk[0]}]  2.000 [get_ports {led[1]}]
set_output_delay -add_delay -max -clock [get_clocks {sys_Clk|altpll_component|auto_generated|pll1|clk[0]}]  3.000 [get_ports {led[2]}]
set_output_delay -add_delay -min -clock [get_clocks {sys_Clk|altpll_component|auto_generated|pll1|clk[0]}]  2.000 [get_ports {led[2]}]
set_output_delay -add_delay -max -clock [get_clocks {sys_Clk|altpll_component|auto_generated|pll1|clk[0]}]  3.000 [get_ports {led[3]}]
set_output_delay -add_delay -min -clock [get_clocks {sys_Clk|altpll_component|auto_generated|pll1|clk[0]}]  2.000 [get_ports {led[3]}]
set_output_delay -add_delay -max -clock [get_clocks {sys_Clk|altpll_component|auto_generated|pll1|clk[0]}]  3.000 [get_ports {led[4]}]
set_output_delay -add_delay -min -clock [get_clocks {sys_Clk|altpll_component|auto_generated|pll1|clk[0]}]  2.000 [get_ports {led[4]}]
set_output_delay -add_delay -max -clock [get_clocks {sys_Clk|altpll_component|auto_generated|pll1|clk[0]}]  3.000 [get_ports {led[5]}]
set_output_delay -add_delay -min -clock [get_clocks {sys_Clk|altpll_component|auto_generated|pll1|clk[0]}]  2.000 [get_ports {led[5]}]
set_output_delay -add_delay -max -clock [get_clocks {sys_Clk|altpll_component|auto_generated|pll1|clk[0]}]  3.000 [get_ports {led[6]}]
set_output_delay -add_delay -min -clock [get_clocks {sys_Clk|altpll_component|auto_generated|pll1|clk[0]}]  2.000 [get_ports {led[6]}]
set_output_delay -add_delay -max -clock [get_clocks {sys_Clk|altpll_component|auto_generated|pll1|clk[0]}]  3.000 [get_ports {led[7]}]
set_output_delay -add_delay -min -clock [get_clocks {sys_Clk|altpll_component|auto_generated|pll1|clk[0]}]  2.000 [get_ports {led[7]}]
set_output_delay -add_delay -max -clock [get_clocks {sys_Clk|altpll_component|auto_generated|pll1|clk[0]}]  3.000 [get_ports {ready}]
set_output_delay -add_delay -min -clock [get_clocks {sys_Clk|altpll_component|auto_generated|pll1|clk[0]}]  2.000 [get_ports {ready}]


#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************



#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************


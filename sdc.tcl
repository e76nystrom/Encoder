create_timing_netlist -model slow
update_timing_netlist
create_clock -name sysClk -period 20.000 [get_ports {sysClk}]
derive_pll_clocks -create_base_clocks
derive_clock_uncertainty
update_timing_netlist
write_sdc -expand "Encoder.sdc"
set_input_delay -clock { sysClk } -min 2 all_inputs
set_input_delay -clock { sys_Clk|altpll_component|auto_generated|pll1|clk[0] } -min 2 [all_inputs]
set_input_delay -clock { sys_Clk|altpll_component|auto_generated|pll1|clk[0] } -max 3 [all_inputs]
set_output_delay -clock { sys_Clk|altpll_component|auto_generated|pll1|clk[0] } -min 2 [all_outputs]
set_output_delay -clock { sys_Clk|altpll_component|auto_generated|pll1|clk[0] } -max 3 [all_outputs]
update_timing_netlist
report_ucp -panel_name "Unconstrained Paths"
write_sdc -expand "Encoder.sdc"

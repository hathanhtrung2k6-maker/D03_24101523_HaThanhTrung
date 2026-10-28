set lib_file "/home/hathannhtrunh/.volare/volare/sky130/versions/0fe599b2afb6708d281543108caf8310912f54af/sky130A/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib"
read_liberty $lib_file
read_verilog 06_GDSII/synthesis/netlist.v
link_design d03_core
read_sdc 04_IMPLEMENTATION/constraints/design.sdc
report_checks -path_delay max  -format full_clock_expanded -fields {slew cap input_pin net fanout}
report_checks -path_delay min 
report_checks -path_delay max  -format summary
report_wns
report_tns
report_power
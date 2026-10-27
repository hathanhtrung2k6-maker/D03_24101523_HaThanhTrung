###############################################################################
# Created by write_sdc
###############################################################################
current_design d03_core
###############################################################################
# Timing Constraints
###############################################################################
create_clock -name clk -period 10.0000 [get_ports {clk}]
set_input_delay 1.0000 -clock [get_clocks {clk}] -add_delay [get_ports {load_n}]
set_input_delay 1.0000 -clock [get_clocks {clk}] -add_delay [get_ports {n_in[0]}]
set_input_delay 1.0000 -clock [get_clocks {clk}] -add_delay [get_ports {n_in[1]}]
set_input_delay 1.0000 -clock [get_clocks {clk}] -add_delay [get_ports {n_in[2]}]
set_input_delay 1.0000 -clock [get_clocks {clk}] -add_delay [get_ports {n_in[3]}]
set_input_delay 1.0000 -clock [get_clocks {clk}] -add_delay [get_ports {n_in[4]}]
set_input_delay 1.0000 -clock [get_clocks {clk}] -add_delay [get_ports {n_in[5]}]
set_input_delay 1.0000 -clock [get_clocks {clk}] -add_delay [get_ports {n_in[6]}]
set_input_delay 1.0000 -clock [get_clocks {clk}] -add_delay [get_ports {n_in[7]}]
set_input_delay 1.0000 -clock [get_clocks {clk}] -add_delay [get_ports {rst_n}]
set_output_delay 1.0000 -clock [get_clocks {clk}] -add_delay [get_ports {count[0]}]
set_output_delay 1.0000 -clock [get_clocks {clk}] -add_delay [get_ports {count[1]}]
set_output_delay 1.0000 -clock [get_clocks {clk}] -add_delay [get_ports {count[2]}]
set_output_delay 1.0000 -clock [get_clocks {clk}] -add_delay [get_ports {count[3]}]
set_output_delay 1.0000 -clock [get_clocks {clk}] -add_delay [get_ports {count[4]}]
set_output_delay 1.0000 -clock [get_clocks {clk}] -add_delay [get_ports {count[5]}]
set_output_delay 1.0000 -clock [get_clocks {clk}] -add_delay [get_ports {count[6]}]
set_output_delay 1.0000 -clock [get_clocks {clk}] -add_delay [get_ports {out}]
###############################################################################
# Environment
###############################################################################
###############################################################################
# Design Rules
###############################################################################

# =========================================================
# SET PATHS
# =========================================================

set base_path /home/M24_2/cadence_edt/HMK_VDA/mokesh_project_test_arbiter/dft_insertion_for_scan_chain/
set input_path  $base_path/dft_input
set output_path $base_path/dft_output

file mkdir $output_path
file mkdir $output_path/reports

# =========================================================
# LIBRARY SETUP
# =========================================================

set_db init_lib_search_path $input_path
set_db init_hdl_search_path $input_path

set_db lef_library $input_path/gsclib045.fixed.lef
read_libs $input_path/slow.lib

# =========================================================
# READ DESIGN
# =========================================================

# Updated file name
read_hdl $input_path/rr_arbiter.v

# IMPORTANT: specify top module
elaborate rr_arbiter

# =========================================================
# READ CONSTRAINTS
# =========================================================

read_sdc $input_path/constraints_top.sdc

# =========================================================
# DFT SETUP
# =========================================================

set_db dft_scan_style muxed_scan
set_db dft_prefix dft_

# Create scan enable
define_shift_enable -name SE -active high -create_port SE

# (Optional but good practice)
#set_db dft_connect_shift_enable_during_mapping true

check_dft_rules

# =========================================================
# SYNTHESIS
# =========================================================

set_db syn_generic_effort medium
syn_generic

set_db syn_map_effort medium
syn_map

set_db syn_opt_effort medium
syn_opt

# =========================================================
# SCAN INSERTION
# =========================================================

check_dft_rules

# FIXED: correct top module name
set_db design:rr_arbiter .dft_min_number_of_scan_chains 1

define_scan_chain -name top_chain \
    -sdi scan_in \
    -sdo scan_out \
    -create_ports

# Auto connect scan chains
connect_scan_chains -auto_create_chains

# Incremental optimization after scan
syn_opt -incr

# =========================================================
# REPORTS
# =========================================================

report_scan_chains > $output_path/reports/scan_chain.rpt
report_area > $output_path/reports/area.rpt
report_timing > $output_path/reports/timing.rpt

# =========================================================
# OUTPUT FILES
# =========================================================

write_hdl > $output_path/rr_arbiter_netlist_dft.v
write_sdc > $output_path/rr_arbiter_sdc_dft.sdc

write_sdf -nonegchecks -edges check_edge \
    -timescale ns -recrem split -setuphold split \
    > $output_path/dft_delays.sdf

write_scandef > $output_path/rr_arbiter_scanDEF.scandef

# =========================================================
# ATPG MODEL
# =========================================================

write_dft_atpg -library $input_path/slow.lib
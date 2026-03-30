# =========================================================
# SET PATHS
# =========================================================

set base_path /home/M24_2/cadence_edt/HMK_VDA/mokesh_project_test_arbiter/synthesis/
set input_path  $base_path/arbiter_input
set output_path $base_path/arbiter_output

# Create output directories
file mkdir $output_path
file mkdir $output_path/reports

# =========================================================
# LIBRARY SETUP
# =========================================================

set_db init_lib_search_path $input_path
set_db lef_library $input_path/gsclib045.fixed.lef
set_db library $input_path/slow.lib

# =========================================================
# READ DESIGN
# =========================================================

read_hdl $input_path/rr_arbiter.v
elaborate

# =========================================================
# READ CONSTRAINTS
# =========================================================

read_sdc $input_path/constraints_top.sdc

# =========================================================
# SYNTHESIS FLOW
# =========================================================

syn_generic
syn_map
syn_opt

# =========================================================
# WRITE OUTPUT FILES
# =========================================================

write_hdl > $output_path/arbiter_netlist.v
write_sdc > $output_path/arbiter_tool.sdc

# =========================================================
# REPORTS
# =========================================================

report timing > $output_path/reports/arbiter_timing.rpt
report power  > $output_path/reports/arbiter_power.rpt
report area   > $output_path/reports/arbiter_area.rpt
report gates  > $output_path/reports/arbiter_gates.rpt

# =========================================================
# GUI
# =========================================================

gui_show
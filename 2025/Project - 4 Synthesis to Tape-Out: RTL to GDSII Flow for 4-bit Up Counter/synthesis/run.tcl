read_libs /home/M24_2/cadence_edt/mokesh_new/genus/trial_1/files/slow.lib
read_hdl up_counter.v
elaborate
read_sdc input_constraints.sdc

syn_generic
syn_map
syn_opt

write_hdl > up_counter_netlist.v
write_sdc  > output_constraints.sdc

gui_show

report timing > up_counter_timing.rpt
report power > up_counter_power.rpt
report area > up_counter_cell.rpt
report gates > up_counter_gates.rpt
   

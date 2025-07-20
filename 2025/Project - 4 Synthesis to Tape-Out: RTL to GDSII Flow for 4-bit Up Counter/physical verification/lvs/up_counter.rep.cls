##############################################################################################################
#####  
#####                                         PVS LVS COMPARISON
#####  
#####  Version                       :   22.20-p031
#####  NVN Run Start                 :   Sun Jul 20 02:44:28 2025
#####  ERC Summary File              :   up_counter.sum
#####  Extraction Report File        :   up_counter.rep
#####  Comparison Report File        :   up_counter.rep.cls
#####  
#####                                :      @     @     
#####                                :       @   @      
#####                                :        @ @       
#####  Run Result                    :     LVS ABORT
#####                                :        @ @       
#####                                :       @   @      
#####                                :      @     @     
#####  
#####  Run Summary                   :   [ERROR] Comparison Aborted
#####                                :   [INFO]  ERC Results: Empty
#####                                :   [INFO]  Extraction Clean
#####  
#####  Layout Design                 :   /home/M24_2/cadence_edt/mokesh_new/physical_design_90/trial_new/lvs_1/up_counter.gds.gz (gdsii)
#####  Layout File                   :   /home/M24_2/cadence_edt/mokesh_new/physical_design_90/trial_new/lvs_1/up_counter.spi (cdl)
#####  Schematic File                :   /home/M24_2/cadence_edt/mokesh_new/physical_design_90/trial_new/lvs_1/up_counter.v (verilog)
#####  Rules File                    :   /home/M24_2/cadence_edt/mokesh_new/physical_design_90/trial_new/lvs_1/.technology.rul
#####  Pin Swap File                 :   up_counter.rep.cps
#####  
#####  Extraction CPU Time           :   0h 0m 0s - (0s)
#####  Extraction Exec Time          :   0h 0m 3s - (3s)
#####  Extraction Peak Memory Usage  :   23.00MB
#####  NVN CPU Time                  :   0h 0m 0s - (0s)                 
#####  NVN Exec Time                 :   0h 0m 1s - (1s)                 
#####  NVN Peak Memory Usage         :   296.83MB
#####  LVS Total CPU Time            :   0h 0m 0s - (0s)                 
#####  LVS Total Exec Time           :   0h 0m 4s - (4s)                 
#####  LVS Total Peak Memory Usage   :   296.83MB
#####  
##############################################################################################################


##############################################################################################################
#
#                                                  LVS RULES                                                  
#
##############################################################################################################

Command Line LVS Rule Values
----------------------------

    layout_primary                          up_counter {-top_cell up_counter}

LVS Rules Given in the Rules File
---------------------------------

    lvs_abort                               -softchk                               no  
    lvs_abort                               -supply_error                          no  
    lvs_abort                               -check_device_for_property_rule        no  
    layout_path                             /home/M24_2/cadence_edt/mokesh_new/physical_design_90/trial_new/lvs_1/up_counter.gds.gz
    layout_format                           gdsii
    schematic_path                          /home/M24_2/cadence_edt/mokesh_new/physical_design_90/trial_new/lvs_1/up_counter.v
                                            verilog
    schematic_primary                       up_counter
                                             
    lvs_cname                               yes -cell
    lvs_cname                               yes -pin
    lvs_cname                               yes -net
    lvs_cname                               yes -instance
    lvs_power_name                          VDD AVDD VDD! vdd! VDD vdd 
    lvs_ground_name                         VSS AVSS GND! gnd! VSS! GND gnd vss 
    lvs_ignore_ports                        no  
    lvs_find_shorts                         no  
    lvs_break_ambig_max                     32
    lvs_filter_option                       AG RC RE RG -source_layout
    lvs_expand_cell_on_error                no  
    lvs_check_property                      MN ( nmos1v ) l l -tolerance 0
    lvs_check_property                      MN ( nmos1v ) w w -tolerance 0
    lvs_check_property                      MN ( nmos1v_hvt ) l l -tolerance 0
    lvs_check_property                      MN ( nmos1v_hvt ) w w -tolerance 0
    lvs_check_property                      MN ( nmos1v_iso ) l l -tolerance 0
    lvs_check_property                      MN ( nmos1v_iso ) w w -tolerance 0
    lvs_check_property                      MN ( nmos1v_nat ) l l -tolerance 0
    lvs_check_property                      MN ( nmos1v_nat ) w w -tolerance 0
    lvs_check_property                      MN ( nmos2v ) l l -tolerance 0
    lvs_check_property                      MN ( nmos2v ) w w -tolerance 0
    lvs_check_property                      MN ( nmos2v_nat ) l l -tolerance 0
    lvs_check_property                      MN ( nmos2v_nat ) w w -tolerance 0
    lvs_check_property                      MP ( pmos1v ) l l -tolerance 0
    lvs_check_property                      MP ( pmos1v ) w w -tolerance 0
    lvs_check_property                      MP ( pmos1v_hvt ) l l -tolerance 0
    lvs_check_property                      MP ( pmos1v_hvt ) w w -tolerance 0
    lvs_check_property                      MP ( pmos2v ) l l -tolerance 0
    lvs_check_property                      MP ( pmos2v ) w w -tolerance 0
    lvs_check_property                      MP ( pmoscap1v ) l l -tolerance 0
    lvs_check_property                      MP ( pmoscap1v ) w w -tolerance 0
    lvs_check_property                      MP ( pmoscap2v ) l l -tolerance 0
    lvs_check_property                      MP ( pmoscap2v ) w w -tolerance 0
    lvs_check_property                      MP ( pmoscap1v3 ) l l -tolerance 0
    lvs_check_property                      MP ( pmoscap1v3 ) w w -tolerance 0
    lvs_check_property                      MP ( pmoscap2v3 ) l l -tolerance 0
    lvs_check_property                      MP ( pmoscap2v3 ) w w -tolerance 0
    lvs_check_property                      MN ( nmoscap1v ) l l -tolerance 0
    lvs_check_property                      MN ( nmoscap1v ) w w -tolerance 0
    lvs_check_property                      MN ( nmoscap2v ) l l -tolerance 0
    lvs_check_property                      MN ( nmoscap2v ) w w -tolerance 0
    lvs_check_property                      MN ( nmoscap1v3 ) l l -tolerance 0
    lvs_check_property                      MN ( nmoscap1v3 ) w w -tolerance 0
    lvs_check_property                      MN ( nmoscap2v3 ) l l -tolerance 0
    lvs_check_property                      MN ( nmoscap2v3 ) w w -tolerance 0
    lvs_check_property                      R ( ressndiff ) l l -tolerance 0
    lvs_check_property                      R ( ressndiff ) w w -tolerance 0
    lvs_check_property                      R ( resnsndiff ) l l -tolerance 0
    lvs_check_property                      R ( resnsndiff ) w w -tolerance 0
    lvs_check_property                      R ( ressnpoly ) l l -tolerance 0
    lvs_check_property                      R ( ressnpoly ) w w -tolerance 0
    lvs_check_property                      R ( resnsnpoly ) l l -tolerance 0
    lvs_check_property                      R ( resnsnpoly ) w w -tolerance 0
    lvs_check_property                      R ( resspdiff ) l l -tolerance 0
    lvs_check_property                      R ( resspdiff ) w w -tolerance 0
    lvs_check_property                      R ( resnspdiff ) l l -tolerance 0
    lvs_check_property                      R ( resnspdiff ) w w -tolerance 0
    lvs_check_property                      R ( ressppoly ) l l -tolerance 0
    lvs_check_property                      R ( ressppoly ) w w -tolerance 0
    lvs_check_property                      R ( resnsppoly ) l l -tolerance 0
    lvs_check_property                      R ( resnsppoly ) w w -tolerance 0
    lvs_check_property                      R ( resnwsti ) l l -tolerance 0
    lvs_check_property                      R ( resnwsti ) w w -tolerance 0
    lvs_check_property                      R ( resnwoxide ) l l -tolerance 0
    lvs_check_property                      R ( resnwoxide ) w w -tolerance 0
    lvs_check_property                      R ( resm1 ) l l -tolerance 0
    lvs_check_property                      R ( resm1 ) w w -tolerance 0
    lvs_check_property                      R ( resm2 ) l l -tolerance 0
    lvs_check_property                      R ( resm2 ) w w -tolerance 0
    lvs_check_property                      R ( resm3 ) l l -tolerance 0
    lvs_check_property                      R ( resm3 ) w w -tolerance 0
    lvs_check_property                      R ( resm4 ) l l -tolerance 0
    lvs_check_property                      R ( resm4 ) w w -tolerance 0
    lvs_check_property                      R ( resm5 ) l l -tolerance 0
    lvs_check_property                      R ( resm5 ) w w -tolerance 0
    lvs_check_property                      R ( resm6 ) l l -tolerance 0
    lvs_check_property                      R ( resm6 ) w w -tolerance 0
    lvs_check_property                      R ( resm7 ) l l -tolerance 0
    lvs_check_property                      R ( resm7 ) w w -tolerance 0
    lvs_check_property                      R ( resm8 ) l l -tolerance 0
    lvs_check_property                      R ( resm8 ) w w -tolerance 0
    lvs_check_property                      R ( resm9 ) l l -tolerance 0
    lvs_check_property                      R ( resm9 ) w w -tolerance 0
    lvs_check_property                      D ( ndio ) A A -tolerance 0
    lvs_check_property                      D ( pdio ) A A -tolerance 0
    lvs_check_property                      Q ( vpnp2 ) A A -tolerance 0
    lvs_check_property                      Q ( vpnp5 ) A A -tolerance 0
    lvs_check_property                      Q ( vpnp10 ) A A -tolerance 0
    lvs_check_property                      Q ( pnp ) A A -tolerance 0
    lvs_check_property                      Q ( npn ) A A -tolerance 0
    lvs_report_file                         up_counter.rep
    lvs_report_max                          50 -mismatched_net_limit 100 
    unit                                    -length u
    input_scale                             2000
    virtual_connect                         no  -colon
    virtual_connect                         yes -semicolon_as_colon
    virtual_connect                         no  -report
    virtual_connect                         -depth primary
    text_depth                              -primary
    text_depth                              2

Default LVS Rule Values
-----------------------

    lvs_abort                               -missing_hcell no
    lvs_abort                               -erc_error yes
    lvs_abort                               -inconsistent_reduction yes
    layout_case_sensitive                   no
    // layout_cpf_file                       
    // schematic_cpf_file                    
    schematic_case_sensitive                no
    schematic_format                        cdl
    // hcell_file                            
    // hcell                                 
    // lvs_exclude_hcell                     
    // lvs_delete_cell                       
    lvs_push_devices                        yes
    lvs_push_devices_properties             no
    lvs_netlist                             yes -substrate_comment
    lvs_netlist                             yes -box_contents
    lvs_netlist                             yes -unnamed_box_pins
    lvs_netlist                             no -allow_inconsistent_model
    lvs_netlist                             yes -properties_comment
    // lvs_write_netlist                     
    // lvs_write_netlist_reduced             
    // lvs_delete_cell_pin                   
    // lvs_black_box                         
    // lvs_interposer                        
    lvs_spice                               yes -allow_floating_pins
    lvs_spice                               yes -allow_duplicate_subcircuit_names
    lvs_spice                               no  -conditional_ldd
    lvs_spice                               no  -prefer_pins
    lvs_spice                               no  -override_globals
    lvs_spice                               no  -redefine_param
    lvs_spice                               no  -replicate_devices
    lvs_spice                               no  -replicate_devices_enhanced
    lvs_spice                               yes -slash_is_space
    lvs_spice                               yes -keep_back_slash
    lvs_spice                               no  -allow_unquoted_strings
    lvs_spice                               no  -allow_inline_parameters
    lvs_spice                               no  -calculate_mos_area
    lvs_spice                               no  -strict_wl
    lvs_spice                               no  -cull_primitive_subcircuits
    lvs_spice                               no  -ignore_option_scale
    lvs_spice                               no  -show_neg_param_warning
    lvs_spice                               no  -scale_x_parameters
    lvs_spice                               yes -strict_subckts_order
    // lvs_spice_option                      
    lvs_reverse_wl                          no
    // lvs_spice_multiplier_name             
                                             
    lvs_compare_case                        no
    lvs_non_user_name                       -port "^[0-9]+$"
    lvs_non_user_name                       -net  "^[0-9]+$"
    // lvs_non_user_name                    -instance 
    lvs_out_of_range_exclude_zero           no
    // lvs_group_models                      
    lvs_strict_subtypes                     no
    lvs_exact_subtypes                      no
    lvs_preserve_box_ports                  no
    // lvs_cpoint                            
    // lvs_cell_list                         
    // lvs_device_type                       
    lvs_auto_pin_swap                       yes -swap_threshold 4000000
    lvs_swap_non_cpoint_pins                yes
    // lvs_swap_pins                         
    lvs_all_cap_pins_swappable              no
    lvs_builtin_device_pin_swap             yes
    // lvs_join_nets                         
    lvs_compare_port_names                  no
    lvs_global_sigs_are_ports               yes
    lvs_discard_pins                        no
    lvs_filter                              no  -bipolar
    lvs_filter                              no  -capacitors
    lvs_filter                              no  -diodes
    lvs_filter                              no  -mos
    lvs_filter                              no  -resistors
    // lvs_filter_device                     
    lvs_reduction_priority                  -parallel
    lvs_reduce_split_gates                  yes
    lvs_derive_logic                        yes -sram
    lvs_derive_logic                        no  -dram
    lvs_derive_logic                        no  -rom
    lvs_recognize_gates                     -all  
    // lvs_recognize_gates_tolerance         
    lvs_reduce                              yes -parallel_bipolar
    lvs_reduce                              yes -parallel_caps
    lvs_reduce                              yes -series_caps
    lvs_reduce                              yes -parallel_diodes
    lvs_reduce                              no  -series_diodes
    lvs_reduce                              yes -parallel_mos
    lvs_reduce                              no  -series_mos
    lvs_reduce                              yes -parallel_resistors
    lvs_reduce                              yes -series_resistors
    // lvs_reduce_device                     
    // lvs_reduce_do_not_merge               
    lvs_expand_on_device_climbing           no
    lvs_expand_unbalanced_cells             yes
    // lvs_check_all_properties_by_name      
    // lvs_property_map                      
    // lvs_transfer_property                 
    lvs_warn_max                            50
    lvs_inconsistent_reduction_threshold    1000000
    // lvs_report_opt                        
    lvs_report_units                        yes
    lvs_keep_data                           no
    lvs_keep_source_cells                   no
    lvs_create_match_db                     no
    // lvs_map_device                        
    unit                                    -resistance ohm
    unit                                    -capacitance pf
    lvs_verilog_bus_map_by_position         no
    lvs_verilog_keep_backslash              no
    lvs_verilog_detect_buses                no
    lvs_do_not_normalize                    no
    // lvs_generic_device                    
    virtual_connect                         no  -colon
    virtual_connect                         yes -semicolon_as_colon
    // virtual_connect                      -name 
    virtual_connect                         no -report
    virtual_connect                         no -incremental
    lvs_preserve_parameterized_cells        no
    lvs_check_color                         no
    // lvs_schematic_color_path              
    // lvs_assign_conflict_layer             
    // lvs_conflict_layer_check             
    lvs_check_color_label                   no
    // lvs_preserve_cells                    
    port                                    -depth -primary

Effective LVS Rule Values
-------------------------

    lvs_filter_option                       AG RC RE RG -source
    lvs_filter_option                       AG RC RE RG -layout
    virtual_connect                         no  -report
    text_depth                              -primary


##############################################################################################################
#
#                                                END OF REPORT                                                
#
##############################################################################################################


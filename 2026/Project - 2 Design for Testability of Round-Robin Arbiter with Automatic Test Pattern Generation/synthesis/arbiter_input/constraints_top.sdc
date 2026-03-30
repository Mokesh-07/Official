# =========================================================
# Define Clock
# =========================================================

create_clock -name clk -period 10 [get_ports clk]

# =========================================================
# Clock Transition (slew)
# =========================================================

set_clock_transition -rise 0.2 [get_clocks clk]
set_clock_transition -fall 0.2 [get_clocks clk]

# =========================================================
# Clock Uncertainty
# =========================================================

set_clock_uncertainty 0.05 [get_clocks clk]

# =========================================================
# Input Delays
# =========================================================

set_input_delay -max 1.0 -clock clk [get_ports req]

# Optional (reset not timed strictly)
set_input_delay -max 1.0 -clock clk [get_ports rst_n]

# =========================================================
# Output Delays
# =========================================================

set_output_delay -max 1.0 -clock clk [get_ports grant]

# =========================================================
# Optional: False Path for Reset
# =========================================================

set_false_path -from [get_ports rst_n]
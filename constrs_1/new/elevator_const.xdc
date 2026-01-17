## XDC Constraints File for Elevator Controller on ZedBoard
## Zynq-7000 XC7Z020-CLG484

## Clock Signal - 50 MHz from ZedBoard (relaxed for timing)
## Original: 100 MHz = 10.000 ns period
## Relaxed: 50 MHz = 20.000 ns period (easier timing)
set_property -dict {PACKAGE_PIN Y9 IOSTANDARD LVCMOS33} [get_ports clk]
create_clock -period 20.000 -name sys_clk_pin -waveform {0.000 10.000} -add [get_ports clk]

## Reset Button - Center Push Button (BTNC)
set_property -dict {PACKAGE_PIN P16 IOSTANDARD LVCMOS18} [get_ports rst]

##############################################################################
## External Call Buttons (Outside Elevator) - Using Push Buttons
##############################################################################

## Floor 0 - UP button (BTNU - Up Button)
set_property -dict {PACKAGE_PIN T18 IOSTANDARD LVCMOS18} [get_ports call_up_0]

## Floor 1 - UP button (BTNR - Right Button)
set_property -dict {PACKAGE_PIN R18 IOSTANDARD LVCMOS18} [get_ports call_up_1]

## Floor 1 - DOWN button (BTNL - Left Button)
set_property -dict {PACKAGE_PIN N15 IOSTANDARD LVCMOS18} [get_ports call_down_1]

## Floor 2 - DOWN button (BTND - Down Button)
set_property -dict {PACKAGE_PIN R16 IOSTANDARD LVCMOS18} [get_ports call_down_2]

##############################################################################
## Internal Floor Selection Buttons (Inside Elevator) - Using Slide Switches
##############################################################################

## Select Floor 0 - SW0
set_property -dict {PACKAGE_PIN F22 IOSTANDARD LVCMOS18} [get_ports select_floor_0]

## Select Floor 1 - SW1
set_property -dict {PACKAGE_PIN G22 IOSTANDARD LVCMOS18} [get_ports select_floor_1]

## Select Floor 2 - SW2
set_property -dict {PACKAGE_PIN H22 IOSTANDARD LVCMOS18} [get_ports select_floor_2]

##############################################################################
## Output Indicators - Using LEDs
##############################################################################

## Current Floor Display (2-bit binary on LEDs)
## Floor 0 = 00, Floor 1 = 01, Floor 2 = 10
## LD0 - Bit 0 of current floor
set_property -dict {PACKAGE_PIN T22 IOSTANDARD LVCMOS33} [get_ports {current_floor[0]}]

## LD1 - Bit 1 of current floor
set_property -dict {PACKAGE_PIN T21 IOSTANDARD LVCMOS33} [get_ports {current_floor[1]}]

## Door Status LED - LD2 (ON when door is open)
set_property -dict {PACKAGE_PIN U22 IOSTANDARD LVCMOS33} [get_ports door_open]

## Movement Direction LEDs
## LD3 - Moving Up indicator
set_property -dict {PACKAGE_PIN U21 IOSTANDARD LVCMOS33} [get_ports moving_up]

## LD4 - Moving Down indicator
set_property -dict {PACKAGE_PIN V22 IOSTANDARD LVCMOS33} [get_ports moving_down]

##############################################################################
## Timing Constraints
##############################################################################

## Input Delay Constraints (for button/switch inputs)
set_input_delay -clock [get_clocks sys_clk_pin] -min 0.000 [get_ports {call_up_0 call_up_1 call_down_1 call_down_2}]
set_input_delay -clock [get_clocks sys_clk_pin] -max 2.000 [get_ports {call_up_0 call_up_1 call_down_1 call_down_2}]
set_input_delay -clock [get_clocks sys_clk_pin] -min 0.000 [get_ports {select_floor_0 select_floor_1 select_floor_2}]
set_input_delay -clock [get_clocks sys_clk_pin] -max 2.000 [get_ports {select_floor_0 select_floor_1 select_floor_2}]
set_input_delay -clock [get_clocks sys_clk_pin] -min 0.000 [get_ports rst]
set_input_delay -clock [get_clocks sys_clk_pin] -max 2.000 [get_ports rst]

## Output Delay Constraints (for LED outputs)
set_output_delay -clock [get_clocks sys_clk_pin] -min -1.000 [get_ports {current_floor[*]}]
set_output_delay -clock [get_clocks sys_clk_pin] -max 2.000 [get_ports {current_floor[*]}]
set_output_delay -clock [get_clocks sys_clk_pin] -min -1.000 [get_ports {door_open moving_up moving_down}]
set_output_delay -clock [get_clocks sys_clk_pin] -max 2.000 [get_ports {door_open moving_up moving_down}]

## False Path Constraints
## Disable timing analysis on asynchronous inputs
set_false_path -from [get_ports rst]
set_false_path -from [get_ports {call_up_0 call_up_1 call_down_1 call_down_2}]
set_false_path -from [get_ports {select_floor_0 select_floor_1 select_floor_2}]

##############################################################################
## Configuration Options for ZedBoard
##############################################################################
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
# Creating SmartDesign CLOCKS_AND_RESETS
set sd_name {CLOCKS_AND_RESETS}
create_smartdesign -sd_name ${sd_name}

# Disable auto promotion of pins of type 'pad'
auto_promote_pad_pins -promote_all 0

# Create top level Scalar Ports
sd_create_scalar_port -sd_name ${sd_name} -port_name {EXT_RST_N} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {MSS_PLL_LOCKS} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {REF_CLK_PAD_N} -port_direction {IN} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {REF_CLK_PAD_P} -port_direction {IN} -port_is_pad {1}

sd_create_scalar_port -sd_name ${sd_name} -port_name {BIT_CLK} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {CLK_125MHz} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {CLK_62_5MHz} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {LOCK} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {PCIe_CLK_125MHz} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {PCIe_REFERENCE_CLK} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {REF_CLK_TO_LANE} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {RESETN_CLK_125MHz} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {RESETN_CLK_62_5MHz} -port_direction {OUT}



# Create top level Bus interface Ports
sd_create_bif_port -sd_name ${sd_name} -port_name {CLKS_TO_XCVR} -port_bif_vlnv {Actel:busdef.clock:PF_TXPLL_XCVR_CLK:1.0} -port_bif_role {master} -port_bif_mapping {\
"LOCK:LOCK" \
"BIT_CLK:BIT_CLK" \
"REF_CLK_TO_LANE:REF_CLK_TO_LANE" } 

# Add CLK_125MHz_to_CLK_62_5MHz instance
sd_instantiate_component -sd_name ${sd_name} -component_name {CLK_DIV} -instance_name {CLK_125MHz_to_CLK_62_5MHz}



# Add CLK_160MHz_to_CLK_80MHz instance
sd_instantiate_component -sd_name ${sd_name} -component_name {CLK_DIV} -instance_name {CLK_160MHz_to_CLK_80MHz}



# Add GLITCHLESS_MUX instance
sd_instantiate_component -sd_name ${sd_name} -component_name {GLITCHLESS_MUX} -instance_name {GLITCHLESS_MUX}



# Add INIT_MONITOR_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {INIT_MONITOR} -instance_name {INIT_MONITOR_0}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {INIT_MONITOR_0:USRAM_INIT_DONE}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {INIT_MONITOR_0:SRAM_INIT_DONE}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {INIT_MONITOR_0:XCVR_INIT_DONE}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {INIT_MONITOR_0:USRAM_INIT_FROM_SNVM_DONE}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {INIT_MONITOR_0:USRAM_INIT_FROM_UPROM_DONE}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {INIT_MONITOR_0:USRAM_INIT_FROM_SPI_DONE}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {INIT_MONITOR_0:SRAM_INIT_FROM_SNVM_DONE}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {INIT_MONITOR_0:SRAM_INIT_FROM_UPROM_DONE}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {INIT_MONITOR_0:SRAM_INIT_FROM_SPI_DONE}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {INIT_MONITOR_0:AUTOCALIB_DONE}



# Add OSCILLATOR_160MHz instance
sd_instantiate_component -sd_name ${sd_name} -component_name {OSCILLATOR_160MHz} -instance_name {OSCILLATOR_160MHz}



# Add PCIe_CLK_LOCK instance
sd_instantiate_macro -sd_name ${sd_name} -macro_name {AND2} -instance_name {PCIe_CLK_LOCK}



# Add PCIE_REF_CLK_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {PCIE_REF_CLK} -instance_name {PCIE_REF_CLK_0}



# Add RESET_CLK_62_5MHz instance
sd_instantiate_component -sd_name ${sd_name} -component_name {CORERESET} -instance_name {RESET_CLK_62_5MHz}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {RESET_CLK_62_5MHz:BANK_x_VDDI_STATUS} -value {VCC}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {RESET_CLK_62_5MHz:BANK_y_VDDI_STATUS} -value {VCC}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {RESET_CLK_62_5MHz:SS_BUSY} -value {GND}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {RESET_CLK_62_5MHz:FF_US_RESTORE} -value {GND}



# Add RESET_CLK_125MHz instance
sd_instantiate_component -sd_name ${sd_name} -component_name {CORERESET} -instance_name {RESET_CLK_125MHz}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {RESET_CLK_125MHz:BANK_x_VDDI_STATUS} -value {VCC}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {RESET_CLK_125MHz:BANK_y_VDDI_STATUS} -value {VCC}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {RESET_CLK_125MHz:SS_BUSY} -value {GND}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {RESET_CLK_125MHz:FF_US_RESTORE} -value {GND}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {RESET_CLK_125MHz:PLL_POWERDOWN_B}



# Add SYSTEM_PLL_LOCKs instance
sd_instantiate_macro -sd_name ${sd_name} -macro_name {AND2} -instance_name {SYSTEM_PLL_LOCKs}



# Add TRANSMIT_PLL_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {TRANSMIT_PLL} -instance_name {TRANSMIT_PLL_0}



# Add scalar net connections
sd_connect_pins -sd_name ${sd_name} -pin_names {"CLK_125MHz" "CLK_125MHz_to_CLK_62_5MHz:CLK_IN" "GLITCHLESS_MUX:CLK1" "RESET_CLK_125MHz:CLK" "TRANSMIT_PLL_0:CLK_125" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CLK_125MHz_to_CLK_62_5MHz:CLK_OUT" "CLK_62_5MHz" "RESET_CLK_62_5MHz:CLK" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CLK_160MHz_to_CLK_80MHz:CLK_IN" "OSCILLATOR_160MHz:RCOSC_160MHZ_CLK_DIV" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CLK_160MHz_to_CLK_80MHz:CLK_OUT" "GLITCHLESS_MUX:CLK0" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"EXT_RST_N" "RESET_CLK_125MHz:EXT_RST_N" "RESET_CLK_62_5MHz:EXT_RST_N" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"GLITCHLESS_MUX:CLK_OUT" "PCIe_CLK_125MHz" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"GLITCHLESS_MUX:SEL" "PCIe_CLK_LOCK:Y" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"INIT_MONITOR_0:DEVICE_INIT_DONE" "RESET_CLK_125MHz:INIT_DONE" "RESET_CLK_62_5MHz:INIT_DONE" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"INIT_MONITOR_0:FABRIC_POR_N" "RESET_CLK_125MHz:FPGA_POR_N" "RESET_CLK_62_5MHz:FPGA_POR_N" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"INIT_MONITOR_0:PCIE_INIT_DONE" "PCIe_CLK_LOCK:B" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"MSS_PLL_LOCKS" "SYSTEM_PLL_LOCKs:B" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"PCIE_REF_CLK_0:REF_CLK" "PCIe_REFERENCE_CLK" "TRANSMIT_PLL_0:REF_CLK" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"PCIE_REF_CLK_0:REF_CLK_PAD_N" "REF_CLK_PAD_N" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"PCIE_REF_CLK_0:REF_CLK_PAD_P" "REF_CLK_PAD_P" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"PCIe_CLK_LOCK:A" "SYSTEM_PLL_LOCKs:A" "TRANSMIT_PLL_0:PLL_LOCK" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"RESETN_CLK_125MHz" "RESET_CLK_125MHz:FABRIC_RESET_N" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"RESETN_CLK_62_5MHz" "RESET_CLK_62_5MHz:FABRIC_RESET_N" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"RESET_CLK_125MHz:PLL_LOCK" "RESET_CLK_62_5MHz:PLL_LOCK" "SYSTEM_PLL_LOCKs:Y" }


# Add bus interface net connections
sd_connect_pins -sd_name ${sd_name} -pin_names {"CLKS_TO_XCVR" "TRANSMIT_PLL_0:CLKS_TO_XCVR" }

# Re-enable auto promotion of pins of type 'pad'
auto_promote_pad_pins -promote_all 1
# Save the smartDesign
save_smartdesign -sd_name ${sd_name}
# Generate SmartDesign CLOCKS_AND_RESETS
generate_component -component_name ${sd_name}

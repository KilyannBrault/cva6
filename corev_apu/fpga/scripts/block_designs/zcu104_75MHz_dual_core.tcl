################################################################
# This is a generated script based on design: SoC
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
	proc get_script_folder {} {
		set script_path [file normalize [info script]]
		set script_folder [file dirname $script_path]
		return $script_folder
	}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2024.1
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
	puts ""

	if { [string compare $scripts_vivado_version $current_vivado_version] > 0 } {
		catch {common::send_gid_msg -ssname BD::TCL -id 2042 -severity "ERROR" " This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Sourcing the script failed since it was created with a future version of Vivado."}
	} else {
		catch {common::send_gid_msg -ssname BD::TCL -id 2041 -severity "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}
	}

	return 1
}

################################################################
# START
################################################################
# To test this script, run the following commands from Vivado Tcl console:
# source SoC_script.tcl

# The design that will be created by this Tcl script contains the following 
# module references:
# bootrom_wrapper, ariane_peripherals_wrapper_verilog, cva6_wrapper_verilog, clint_wrapper_verilog, debug_module_wrapper_verilog, axi_xbar_interface_verilog, axi_riscv_amos_wrapper_verilog

# Please add the sources of those modules before sourcing this Tcl script.

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
	create_project project_1 myproj -part xczu7ev-ffvc1156-2-e
	set_property BOARD_PART xilinx.com:zcu104:part0:1.1 [current_project]
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name SoC

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
# 		create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
	# USE CASES:
	# 	1) Design_name not set

	set errMsg "Please set the variable <design_name> to a non-empty value."
	set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
	# USE CASES:
	# 	2): Current design opened AND is empty AND names same.
	# 	3): Current design opened AND is empty AND names diff; design_name NOT in project.
	# 	4): Current design opened AND is empty AND names diff; design_name exists in project.	
	
	if { $cur_design ne $design_name } {
		common::send_gid_msg -ssname BD::TCL -id 2001 -severity "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
		set design_name [get_property NAME $cur_design]
	}

	common::send_gid_msg -ssname BD::TCL -id 2002 -severity "INFO" "Constructing design in IPI design <$cur_design>..."
} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
	# USE CASES:
	# 	5) Current design opened AND has components AND same names.

	set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
	set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
	# USE CASES: 
	# 	6) Current opened design, has components, but diff names, design_name exists in project.
	# 	7) No opened design, design_name exists in project.

	set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
	set nRet 2
} else {
	# USE CASES:
	# 	8) No opened design, design_name not in project.
	# 	9) Current opened design, has components, but diff names, design_name not in project.

	common::send_gid_msg -ssname BD::TCL -id 2003 -severity "INFO" "Currently there is no design <$design_name> in project, so creating one..."

	create_bd_design $design_name

	common::send_gid_msg -ssname BD::TCL -id 2004 -severity "INFO" "Making design <$design_name> as current_bd_design."
	current_bd_design $design_name
}

common::send_gid_msg -ssname BD::TCL -id 2005 -severity "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
	catch {common::send_gid_msg -ssname BD::TCL -id 2006 -severity "ERROR" $errMsg}
	return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
	set list_check_ips "\ 
xilinx.com:ip:axi_bram_ctrl:4.1\
xilinx.com:ip:axi_quad_spi:3.2\
xilinx.com:ip:xlconcat:2.1\
xilinx.com:ip:proc_sys_reset:5.0\
xilinx.com:ip:xlconstant:1.1\
xilinx.com:ip:ddr4:2.2\
xilinx.com:ip:axi_gpio:2.0\
xilinx.com:ip:axi_uart16550:2.0\
xilinx.com:ip:xlslice:1.0\
xilinx.com:ip:util_vector_logic:2.0\
xilinx.com:ip:clk_wiz:6.0\
xilinx.com:ip:axi_clock_converter:2.1\
xilinx.com:ip:axi_protocol_converter:2.1\
xilinx.com:ip:axi_dwidth_converter:2.1\
xilinx.com:ip:axi_dma:7.1\
"

	set list_ips_missing ""
	common::send_gid_msg -ssname BD::TCL -id 2011 -severity "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

	foreach ip_vlnv $list_check_ips {
		set ip_obj [get_ipdefs -all $ip_vlnv]
		if { $ip_obj eq "" } {
			lappend list_ips_missing $ip_vlnv
		}
	}

	if { $list_ips_missing ne "" } {
		catch {common::send_gid_msg -ssname BD::TCL -id 2012 -severity "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
		set bCheckIPsPassed 0
	}
}

##################################################################
# CHECK Modules
##################################################################
set bCheckModules 1
if { $bCheckModules == 1 } {
	set list_check_mods "\ 
bootrom_wrapper\
ariane_peripherals_wrapper_verilog\
cva6_wrapper_verilog\
clint_wrapper_verilog\
debug_module_wrapper_verilog\
axi_xbar_interface_verilog\
axi_riscv_amos_wrapper_verilog\
"

	set list_mods_missing ""
	common::send_gid_msg -ssname BD::TCL -id 2020 -severity "INFO" "Checking if the following modules exist in the project's sources: $list_check_mods ."

	foreach mod_vlnv $list_check_mods {
		if { [can_resolve_reference $mod_vlnv] == 0 } {
			lappend list_mods_missing $mod_vlnv
		}
	}

	if { $list_mods_missing ne "" } {
		catch {common::send_gid_msg -ssname BD::TCL -id 2021 -severity "ERROR" "The following module(s) are not found in the project: $list_mods_missing" }
		common::send_gid_msg -ssname BD::TCL -id 2022 -severity "INFO" "Please add source files for the missing module(s) above."
		set bCheckIPsPassed 0
	}
}

if { $bCheckIPsPassed != 1 } {
	common::send_gid_msg -ssname BD::TCL -id 2023 -severity "WARNING" "Will not continue with creation of design due to the error(s) above."
	return 3
}


##################################################################
# DATA FILE TCL PROCs
##################################################################
proc write_ddr4_file_SoC_ddr4_0_0 { str_filepath } {
	file mkdir [ file dirname "$str_filepath" ]
	set data_file [open $str_filepath w+]

	puts $data_file {Part type,Part name,Rank,StackHeight,CA Mirror,Data mask,Address width,Row width,Column width,Bank width,Bank group width,CS width,CKE width,ODT width,CK width,Memory speed grade,Memory density,Component density,Memory device width,Memory component width,Data bits per strobe,IO Voltages,Data widths,Min period,Max period,tCKE,tFAW,tFAW_dlr,tMRD,tRAS,tRCD,tREFI,tRFC,tRFC_dlr,tRP,tRRD_S,tRRD_L,tRRD_dlr,tRTP,tWR,tWTR_S,tWTR_L,tXPR,tZQCS,tZQINIT,tCCD_3ds,cas latency,cas write latency,burst length}
	puts $data_file {SODIMMs,MTA8ATF1G64HZ-2G3,1,1,0,1,17,16,10,2,2,1,1,1,1,2G3,8GB,1Gb,64,8,8,1.2V,64,833,1600,5000 ps,30000 ps,0,8 tck,32000 ps,14160 ps,7800000 ps,350000 ps,0,14160 ps,5300 ps,6400 ps,0,7500 ps,15000 ps,2500 ps,7500 ps,360 ns,128 tck,1024 tck,0,18,18,8}

	close $data_file
}
# End of write_ddr4_file_SoC_ddr4_0_0()

# Hierarchical cell: northbridge
proc create_hier_cell_northbridge { parentCell nameHier } {
	variable script_folder

	if { $parentCell eq "" || $nameHier eq "" } {
		catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_northbridge() - Empty argument(s)!"}
		return
	}

	# Get object for parentCell
	set parentObj [get_bd_cells $parentCell]
	if { $parentObj == "" } {
		catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
		return
	}

	# Make sure parentObj is hier blk
	set parentType [get_property TYPE $parentObj]
	if { $parentType ne "hier" } {
		catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
		return
	}

	# Save current instance; Restore later
	set oldCurInst [current_bd_instance .]

	# Set parent object as current
	current_bd_instance $parentObj

	# Create cell and set as current instance
	set hier_obj [create_bd_cell -type hier $nameHier]
	current_bd_instance $hier_obj

	# Create interface pins
	create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 CPU_AXI

	create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 DDR_AXI

	create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 UART_AXILite

	create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 CLINT_AXI

	create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 TIMER_AXI

	create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 BOOTROM_AXI

	create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 SDCARD_AXI

	create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 DEBUG_MODULE_AXI

	create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 DEBUG_AXI

	create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 PLIC_AXI

	create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 GPIO_AXI


	# Create pins
	create_bd_pin -dir I -type clk aclk
	create_bd_pin -dir I -from 5 -to 0 cpu_atop_in
	create_bd_pin -dir I -type rst aresetn
	create_bd_pin -dir I -type rst cpu_peripheral_aresetn
	create_bd_pin -dir I -type clk ddr_clk
	create_bd_pin -dir O -type intr mm2s_introut
	create_bd_pin -dir O -type intr s2mm_introut
	create_bd_pin -dir I -from 5 -to 0 debug_module_atop
	create_bd_pin -dir O -from 5 -to 0 m_axi_debug_awatop
	create_bd_pin -dir O -from 5 -to 0 m_axi_clint_awatop
	create_bd_pin -dir O -from 5 -to 0 m_axi_timer_awatop
	create_bd_pin -dir O -from 5 -to 0 m_axi_plic_awatop
	create_bd_pin -dir I -type rst ddr_aresetn

	# Create instance: axi_xbar_interface_v_0, and set properties
	set block_name axi_xbar_interface_verilog
	set block_cell_name axi_xbar_interface_v_0
	if { [catch {set axi_xbar_interface_v_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
		catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
		return 1
	} elseif { $axi_xbar_interface_v_0 eq "" } {
		catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
		return 1
	}
	set_property -dict [list \
		CONFIG.AXI_MST_ID_WIDTH {6} \
		CONFIG.AXI_SLV_ID_WIDTH {4} \
		CONFIG.AXI_USER_WIDTH {0} \
	] $axi_xbar_interface_v_0


	# Create instance: xlconstant_0, and set properties
	set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
	set_property -dict [list \
		CONFIG.CONST_VAL {0} \
		CONFIG.CONST_WIDTH {6} \
	] $xlconstant_0


	# Create instance: axi_clock_converter_0, and set properties
	set axi_clock_converter_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_clock_converter:2.1 axi_clock_converter_0 ]

	# Create instance: gpio_axi_protocol_convert, and set properties
	set gpio_axi_protocol_convert [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_protocol_converter:2.1 gpio_axi_protocol_convert ]

	# Create instance: uart_axi_protocol_convert, and set properties
	set uart_axi_protocol_convert [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_protocol_converter:2.1 uart_axi_protocol_convert ]

	# Create instance: sdcard_axi_dwidth_converter, and set properties
	set sdcard_axi_dwidth_converter [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dwidth_converter:2.1 sdcard_axi_dwidth_converter ]

	# Create instance: gpio_axi_dwidth_converter, and set properties
	set gpio_axi_dwidth_converter [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dwidth_converter:2.1 gpio_axi_dwidth_converter ]

	# Create instance: uart_axi_dwidth_converter, and set properties
	set uart_axi_dwidth_converter [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dwidth_converter:2.1 uart_axi_dwidth_converter ]

	# Create instance: gpio_axi_dwidth_converter1, and set properties
	set gpio_axi_dwidth_converter1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dwidth_converter:2.1 gpio_axi_dwidth_converter1 ]

	# Create instance: axi_riscv_amos_wrapp_0, and set properties
	set block_name axi_riscv_amos_wrapper_verilog
	set block_cell_name axi_riscv_amos_wrapp_0
	if { [catch {set axi_riscv_amos_wrapp_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
		catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
		return 1
	} elseif { $axi_riscv_amos_wrapp_0 eq "" } {
		catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
		return 1
	}
	set_property CONFIG.AXI_ID_WIDTH {6} $axi_riscv_amos_wrapp_0

	
	# Create interface connections
	connect_bd_intf_net -intf_net CPU_AXI_1 [get_bd_intf_pins CPU_AXI] [get_bd_intf_pins axi_xbar_interface_v_0/s_axi_cpu]
	connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins gpio_axi_dwidth_converter/M_AXI] [get_bd_intf_pins GPIO_AXI]
	connect_bd_intf_net -intf_net DEBUG_MODULE_AXI_1 [get_bd_intf_pins DEBUG_MODULE_AXI] [get_bd_intf_pins axi_xbar_interface_v_0/s_axi_debug]
	connect_bd_intf_net -intf_net axi_clock_converter_0_M_AXI [get_bd_intf_pins DDR_AXI] [get_bd_intf_pins axi_clock_converter_0/M_AXI]
	connect_bd_intf_net -intf_net axi_dwidth_converter_0_M_AXI [get_bd_intf_pins SDCARD_AXI] [get_bd_intf_pins sdcard_axi_dwidth_converter/M_AXI]
	connect_bd_intf_net -intf_net axi_riscv_amos_wrapp_0_m_axi_out [get_bd_intf_pins axi_clock_converter_0/S_AXI] [get_bd_intf_pins axi_riscv_amos_wrapp_0/m_axi_out]
	connect_bd_intf_net -intf_net axi_xbar_interface_v_0_m_axi_bootrom [get_bd_intf_pins BOOTROM_AXI] [get_bd_intf_pins axi_xbar_interface_v_0/m_axi_bootrom]
	connect_bd_intf_net -intf_net axi_xbar_interface_v_0_m_axi_clint [get_bd_intf_pins CLINT_AXI] [get_bd_intf_pins axi_xbar_interface_v_0/m_axi_clint]
	connect_bd_intf_net -intf_net axi_xbar_interface_v_0_m_axi_debug [get_bd_intf_pins DEBUG_AXI] [get_bd_intf_pins axi_xbar_interface_v_0/m_axi_debug]
	connect_bd_intf_net -intf_net axi_xbar_interface_v_0_m_axi_gpio [get_bd_intf_pins gpio_axi_protocol_convert/S_AXI] [get_bd_intf_pins axi_xbar_interface_v_0/m_axi_gpio]
	connect_bd_intf_net -intf_net axi_xbar_interface_v_0_m_axi_plic [get_bd_intf_pins PLIC_AXI] [get_bd_intf_pins axi_xbar_interface_v_0/m_axi_plic]
	connect_bd_intf_net -intf_net axi_xbar_interface_v_0_m_axi_ram [get_bd_intf_pins axi_xbar_interface_v_0/m_axi_ram] [get_bd_intf_pins axi_riscv_amos_wrapp_0/s_axi_in]
	connect_bd_intf_net -intf_net axi_xbar_interface_v_0_m_axi_sdcard [get_bd_intf_pins axi_xbar_interface_v_0/m_axi_sdcard] [get_bd_intf_pins sdcard_axi_dwidth_converter/S_AXI]
	connect_bd_intf_net -intf_net axi_xbar_interface_v_0_m_axi_timer [get_bd_intf_pins TIMER_AXI] [get_bd_intf_pins axi_xbar_interface_v_0/m_axi_timer]
	connect_bd_intf_net -intf_net axi_xbar_interface_v_0_m_axi_uart [get_bd_intf_pins uart_axi_protocol_convert/S_AXI] [get_bd_intf_pins axi_xbar_interface_v_0/m_axi_uart]
	connect_bd_intf_net -intf_net gpio_axi_protocol_convert_M_AXI [get_bd_intf_pins gpio_axi_protocol_convert/M_AXI] [get_bd_intf_pins gpio_axi_dwidth_converter/S_AXI]
	connect_bd_intf_net -intf_net uart_axi_dwidth_converter_M_AXI [get_bd_intf_pins UART_AXILite] [get_bd_intf_pins uart_axi_dwidth_converter/M_AXI]
	connect_bd_intf_net -intf_net uart_axi_protocol_convert_M_AXI [get_bd_intf_pins uart_axi_dwidth_converter/S_AXI] [get_bd_intf_pins uart_axi_protocol_convert/M_AXI]

	# Create port connections
	connect_bd_net -net aresetn_1 [get_bd_pins aresetn] [get_bd_pins axi_clock_converter_0/s_axi_aresetn] [get_bd_pins gpio_axi_protocol_convert/aresetn] [get_bd_pins uart_axi_protocol_convert/aresetn] [get_bd_pins gpio_axi_dwidth_converter/s_axi_aresetn] [get_bd_pins uart_axi_dwidth_converter/s_axi_aresetn] [get_bd_pins gpio_axi_dwidth_converter1/s_axi_aresetn] [get_bd_pins axi_xbar_interface_v_0/aresetn] [get_bd_pins axi_riscv_amos_wrapp_0/aresetn] [get_bd_pins sdcard_axi_dwidth_converter/s_axi_aresetn]
	connect_bd_net -net axi_xbar_interface_v_0_m_axi_clint_awatop [get_bd_pins axi_xbar_interface_v_0/m_axi_clint_awatop] [get_bd_pins m_axi_clint_awatop]
	connect_bd_net -net axi_xbar_interface_v_0_m_axi_debug_awatop [get_bd_pins axi_xbar_interface_v_0/m_axi_debug_awatop] [get_bd_pins m_axi_debug_awatop]
	connect_bd_net -net axi_xbar_interface_v_0_m_axi_plic_awatop [get_bd_pins axi_xbar_interface_v_0/m_axi_plic_awatop] [get_bd_pins m_axi_plic_awatop]
	connect_bd_net -net axi_xbar_interface_v_0_m_axi_ram_awatop [get_bd_pins axi_xbar_interface_v_0/m_axi_ram_awatop] [get_bd_pins axi_riscv_amos_wrapp_0/s_axi_in_awatop]
	connect_bd_net -net axi_xbar_interface_v_0_m_axi_timer_awatop [get_bd_pins axi_xbar_interface_v_0/m_axi_timer_awatop] [get_bd_pins m_axi_timer_awatop]
	connect_bd_net -net aclk_1 [get_bd_pins aclk] [get_bd_pins axi_clock_converter_0/s_axi_aclk] [get_bd_pins uart_axi_protocol_convert/aclk] [get_bd_pins gpio_axi_protocol_convert/aclk] [get_bd_pins gpio_axi_dwidth_converter/s_axi_aclk] [get_bd_pins uart_axi_dwidth_converter/s_axi_aclk] [get_bd_pins gpio_axi_dwidth_converter1/s_axi_aclk] [get_bd_pins axi_xbar_interface_v_0/aclk] [get_bd_pins axi_riscv_amos_wrapp_0/CLK] [get_bd_pins sdcard_axi_dwidth_converter/s_axi_aclk]
	connect_bd_net -net cpu_atop_in_1 [get_bd_pins cpu_atop_in] [get_bd_pins axi_xbar_interface_v_0/s_axi_cpu_awatop]
	connect_bd_net -net ddr_aresetn_1 [get_bd_pins ddr_aresetn] [get_bd_pins axi_clock_converter_0/m_axi_aresetn]
	connect_bd_net -net ddr_clk_1 [get_bd_pins ddr_clk] [get_bd_pins axi_clock_converter_0/m_axi_aclk]
	connect_bd_net -net debug_module_atop_1 [get_bd_pins debug_module_atop] [get_bd_pins axi_xbar_interface_v_0/s_axi_debug_awatop]

	# Restore current instance
	current_bd_instance $oldCurInst
}


# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {
	variable script_folder
	variable design_name

	if { $parentCell eq "" } {
		set parentCell [get_bd_cells /]
	}

	# Get object for parentCell
	set parentObj [get_bd_cells $parentCell]
	if { $parentObj == "" } {
		catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
		return
	}

	# Make sure parentObj is hier blk
	set parentType [get_property TYPE $parentObj]
	if { $parentType ne "hier" } {
		catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
		return
	}

	# Save current instance; Restore later
	set oldCurInst [current_bd_instance .]

	# Set parent object as current
	current_bd_instance $parentObj


	# Create interface ports
	set clk_300mhz [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 clk_300mhz ]
	set_property -dict [ list \
		CONFIG.FREQ_HZ {300000000} \
	] $clk_300mhz

	set led_4bits [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 led_4bits ]

	set uart2_pl [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:uart_rtl:1.0 uart2_pl ]

	set c0_ddr4 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddr4_rtl:1.0 c0_ddr4 ]

	set clk_125 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 clk_125 ]
	set_property -dict [ list \
		CONFIG.FREQ_HZ {125000000} \
	] $clk_125


	# Create ports
	set spi_clk_o [ create_bd_port -dir O -type clk spi_clk_o ]
	set spi_ss [ create_bd_port -dir O -from 0 -to 0 -type data spi_ss ]
	set spi_mosi [ create_bd_port -dir O -type data spi_mosi ]
	set spi_miso [ create_bd_port -dir I -type data spi_miso ]
	set led_0_a [ create_bd_port -dir I led_0_a ]
	set int_n [ create_bd_port -dir I int_n ]
	set led_ar_a_c2m [ create_bd_port -dir O -from 0 -to 0 -type data led_ar_a_c2m ]
	set led_ar_c_c2m [ create_bd_port -dir O -from 0 -to 0 -type data led_ar_c_c2m ]
	set sys_rst [ create_bd_port -dir I sys_rst ]

	# Create instance: axi_bootrom_control, and set properties
	set axi_bootrom_control [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 axi_bootrom_control ]
	set_property -dict [list \
		CONFIG.DATA_WIDTH {64} \
		CONFIG.SINGLE_PORT_BRAM {1} \
	] $axi_bootrom_control


	# Create instance: sdcard_quad_spi_axi, and set properties
	set sdcard_quad_spi_axi [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_quad_spi:3.2 sdcard_quad_spi_axi ]
	set_property -dict [list \
		CONFIG.C_FAMILY {kintex7} \
		CONFIG.C_FIFO_DEPTH {256} \
		CONFIG.C_NUM_TRANSFER_BITS {8} \
		CONFIG.C_SCK_RATIO {2} \
		CONFIG.C_SPI_MODE {0} \
		CONFIG.C_SUB_FAMILY {kintex7} \
		CONFIG.C_TYPE_OF_AXI4_INTERFACE {1} \
		CONFIG.C_USE_STARTUP {0} \
		CONFIG.QSPI_BOARD_INTERFACE {Custom} \
		CONFIG.UC_FAMILY {0} \
		CONFIG.USE_BOARD_FLOW {true} \
	] $sdcard_quad_spi_axi


	# Create instance: bootrom_wrapper_0, and set properties
	set block_name bootrom_wrapper
	set block_cell_name bootrom_wrapper_0
	if { [catch {set bootrom_wrapper_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
		catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
		return 1
	} elseif { $bootrom_wrapper_0 eq "" } {
		catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
		return 1
	}

	# Create instance: ariane_peripherals_0, and set properties
	set block_name ariane_peripherals_wrapper_verilog
	set block_cell_name ariane_peripherals_0
	if { [catch {set ariane_peripherals_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
		catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
		return 1
	} elseif { $ariane_peripherals_0 eq "" } {
		catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
		return 1
	}
	set_property -dict [list \
		CONFIG.AXI_DATA_WIDTH {64} \
		CONFIG.AXI_ID_WIDTH {6} \
		CONFIG.AXI_USER_WIDTH {0} \
		CONFIG.NR_CORES {2} \
	] $ariane_peripherals_0


	# Create instance: irqconcat, and set properties
	set irqconcat [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 irqconcat ]
	set_property -dict [list \
		CONFIG.IN3_WIDTH {20} \
		CONFIG.IN5_WIDTH {18} \
		CONFIG.NUM_PORTS {4} \
	] $irqconcat


	# Create instance: cpu_0, and set properties
	set block_name cva6_wrapper_verilog
	set block_cell_name cpu_0
	if { [catch {set cpu_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
		catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
		return 1
	} elseif { $cpu_0 eq "" } {
		catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
		return 1
	}
	set_property -dict [list \
		CONFIG.AXI_CUT_BYPASS {1} \
		CONFIG.AXI_ID_WIDTH {4} \
		CONFIG.AXI_USER_WIDTH {0} \
		CONFIG.NR_CORES {2} \
	] $cpu_0


	# Create instance: clint_0, and set properties
	set block_name clint_wrapper_verilog
	set block_cell_name clint_0
	if { [catch {set clint_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
		catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
		return 1
	} elseif { $clint_0 eq "" } {
		catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
		return 1
	}
	set_property -dict [list \
		CONFIG.AXI_ID_WIDTH {6} \
		CONFIG.AXI_USER_WIDTH {0} \
		CONFIG.NR_CORES {2} \
	] $clint_0


	# Create instance: northbridge
	create_hier_cell_northbridge [current_bd_instance .] northbridge

	# Create instance: cpu_reset_gen, and set properties
	set cpu_reset_gen [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 cpu_reset_gen ]

	# Create instance: cpu_debug, and set properties
	set block_name debug_module_wrapper_verilog
	set block_cell_name cpu_debug
	if { [catch {set cpu_debug [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
		catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
		return 1
	} elseif { $cpu_debug eq "" } {
		catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
		return 1
	}
	set_property -dict [list \
		CONFIG.AXI_USER_WIDTH {0} \
		CONFIG.NR_CORES {2} \
	] $cpu_debug


	# Create instance: xlconstant_1, and set properties
	set xlconstant_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_1 ]
	set_property CONFIG.CONST_VAL {1} $xlconstant_1


	# Create instance: ddr4_0, and set properties
	set ddr4_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:ddr4:2.2 ddr4_0 ]

	# Generate the DDR4 Custom Parts File
	set str_ddr4_folder [get_property IP_DIR [ get_ips [ get_property CONFIG.Component_Name $ddr4_0 ] ] ]
	set str_ddr4_file_name MTA8ATF1G64HZ.csv
	set str_ddr4_file_path ${str_ddr4_folder}/${str_ddr4_file_name}

	write_ddr4_file_SoC_ddr4_0_0 $str_ddr4_file_path

	set_property -dict [list \
		CONFIG.ADDN_UI_CLKOUT1_FREQ_HZ {300} \
		CONFIG.ADDN_UI_CLKOUT2_FREQ_HZ {None} \
		CONFIG.ADDN_UI_CLKOUT3_FREQ_HZ {None} \
		CONFIG.C0.DDR4_AxiDataWidth {64} \
		CONFIG.C0.DDR4_CasLatency {20} \
		CONFIG.C0.DDR4_CasWriteLatency {16} \
		CONFIG.C0.DDR4_CustomParts {MTA8ATF1G64HZ.csv} \
		CONFIG.C0.DDR4_DataMask {DM_DBI_RD} \
		CONFIG.C0.DDR4_InputClockPeriod {3332} \
		CONFIG.C0.DDR4_MemoryPart {MTA8ATF1G64HZ-2G3} \
		CONFIG.C0.DDR4_MemoryType {SODIMMs} \
		CONFIG.C0.DDR4_Specify_MandD {false} \
		CONFIG.C0.DDR4_TimePeriod {833} \
		CONFIG.C0.DDR4_isCustom {true} \
		CONFIG.C0_CLOCK_BOARD_INTERFACE {clk_300mhz} \
		CONFIG.C0_DDR4_BOARD_INTERFACE {Custom} \
		CONFIG.RESET_BOARD_INTERFACE {Custom} \
		CONFIG.System_Clock {Differential} \
	] $ddr4_0


	# Create instance: axi_gpio_0, and set properties
	set axi_gpio_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_0 ]
	set_property -dict [list \
		CONFIG.GPIO_BOARD_INTERFACE {led_4bits} \
		CONFIG.USE_BOARD_FLOW {true} \
	] $axi_gpio_0


	# Create instance: axi_uart16550_0, and set properties
	set axi_uart16550_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uart16550:2.0 axi_uart16550_0 ]
	set_property -dict [list \
		CONFIG.UART_BOARD_INTERFACE {uart2_pl} \
		CONFIG.USE_BOARD_FLOW {true} \
	] $axi_uart16550_0


	# Create instance: xlconstant_0, and set properties
	set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
	set_property CONFIG.CONST_VAL {0} $xlconstant_0


	# Create instance: xlconcat_0, and set properties
	set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
	set_property -dict [list \
		CONFIG.IN0_WIDTH {16} \
		CONFIG.IN1_WIDTH {48} \
	] $xlconcat_0


	# Create instance: proc_sys_reset_0, and set properties
	set proc_sys_reset_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0 ]


	# Create instance: xlconstant_2, and set properties
	set xlconstant_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_2 ]
	set_property CONFIG.CONST_VAL {0} $xlconstant_2


	# Create instance: xlconstant_3, and set properties
	set xlconstant_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_3 ]
	set_property -dict [list \
		CONFIG.CONST_VAL {0} \
		CONFIG.CONST_WIDTH {20} \
	] $xlconstant_3

	# Create instance: xlconstant_4, and set properties
	set xlconstant_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_4 ]
	set_property CONFIG.CONST_VAL {1} $xlconstant_4


	# Create instance: util_vector_logic_0, and set properties
	set util_vector_logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_0 ]
	set_property -dict [list \
		CONFIG.C_OPERATION {or} \
		CONFIG.C_SIZE {1} \
	] $util_vector_logic_0


	# Create instance: util_vector_logic_1, and set properties
	set util_vector_logic_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_1 ]
	set_property -dict [list \
		CONFIG.C_OPERATION {not} \
		CONFIG.C_SIZE {1} \
	] $util_vector_logic_1


	# Create instance: clk_wiz_0, and set properties
	set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_0 ]
	set_property -dict [list \
		CONFIG.CLKIN1_JITTER_PS {80.0} \
		CONFIG.CLKOUT1_JITTER {185.448} \
		CONFIG.CLKOUT1_PHASE_ERROR {222.305} \
		CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {75} \
		CONFIG.CLKOUT2_JITTER {196.543} \
		CONFIG.CLKOUT2_PHASE_ERROR {222.305} \
		CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {50} \
		CONFIG.CLKOUT2_USED {true} \
		CONFIG.CLK_OUT1_PORT {clk_core} \
		CONFIG.CLK_OUT2_PORT {clk_spi} \
		CONFIG.MMCM_CLKFBOUT_MULT_F {48.000} \
		CONFIG.MMCM_CLKIN1_PERIOD {8.000} \
		CONFIG.MMCM_CLKOUT0_DIVIDE_F {16.000} \
		CONFIG.MMCM_CLKOUT1_DIVIDE {24} \
		CONFIG.MMCM_DIVCLK_DIVIDE {5} \
		CONFIG.NUM_OUT_CLKS {2} \
		CONFIG.PRIM_SOURCE {Differential_clock_capable_pin} \
		CONFIG.USE_LOCKED {false} \
		CONFIG.USE_RESET {false} \
	] $clk_wiz_0


	# Create interface connections
	connect_bd_intf_net -intf_net axi_gpio_0_GPIO [get_bd_intf_ports led_4bits] [get_bd_intf_pins axi_gpio_0/GPIO]
	connect_bd_intf_net -intf_net axi_interconnect_0_M04_AXI [get_bd_intf_pins axi_bootrom_control/S_AXI] [get_bd_intf_pins northbridge/BOOTROM_AXI]
	connect_bd_intf_net -intf_net axi_interconnect_0_M05_AXI [get_bd_intf_pins northbridge/CLINT_AXI] [get_bd_intf_pins clint_0/s_axi_clint]
	connect_bd_intf_net -intf_net axi_interconnect_0_M09_AXI [get_bd_intf_pins northbridge/PLIC_AXI] [get_bd_intf_pins ariane_peripherals_0/s_axi_plic]
	connect_bd_intf_net -intf_net axi_interconnect_0_M10_AXI [get_bd_intf_pins northbridge/TIMER_AXI] [get_bd_intf_pins ariane_peripherals_0/s_axi_timer]
	connect_bd_intf_net -intf_net axi_uart16550_0_UART [get_bd_intf_ports uart2_pl] [get_bd_intf_pins axi_uart16550_0/UART]
	connect_bd_intf_net -intf_net clk_125_1 [get_bd_intf_ports clk_125] [get_bd_intf_pins clk_wiz_0/CLK_IN1_D]
	connect_bd_intf_net -intf_net clk_300mhz_1 [get_bd_intf_ports clk_300mhz] [get_bd_intf_pins ddr4_0/C0_SYS_CLK]
	connect_bd_intf_net -intf_net cpu_0_m_axi_cpu [get_bd_intf_pins cpu_0/m_axi_cpu] [get_bd_intf_pins northbridge/CPU_AXI]
	connect_bd_intf_net -intf_net cpu_debug_m_axi_dmi_jtag [get_bd_intf_pins cpu_debug/m_axi_dmi_jtag] [get_bd_intf_pins northbridge/DEBUG_MODULE_AXI]
	connect_bd_intf_net -intf_net ddr4_0_C0_DDR4 [get_bd_intf_ports c0_ddr4] [get_bd_intf_pins ddr4_0/C0_DDR4]
	connect_bd_intf_net -intf_net northbridge_DDR_AXI [get_bd_intf_pins ddr4_0/C0_DDR4_S_AXI] [get_bd_intf_pins northbridge/DDR_AXI]
	connect_bd_intf_net -intf_net northbridge_M06_AXI [get_bd_intf_pins sdcard_quad_spi_axi/AXI_FULL] [get_bd_intf_pins northbridge/SDCARD_AXI]
	connect_bd_intf_net -intf_net northbridge_M12_AXI [get_bd_intf_pins cpu_debug/s_axi_dmi_jtag] [get_bd_intf_pins northbridge/DEBUG_AXI]
	connect_bd_intf_net -intf_net northbridge_M_AXI [get_bd_intf_pins axi_gpio_0/S_AXI] [get_bd_intf_pins northbridge/GPIO_AXI]
	connect_bd_intf_net -intf_net northbridge_UART_AXI [get_bd_intf_pins axi_uart16550_0/S_AXI] [get_bd_intf_pins northbridge/UART_AXILite]

	# Create port connections
	connect_bd_net -net ariane_peripherals_0_irq_out [get_bd_pins ariane_peripherals_0/irq_out] [get_bd_pins cpu_0/irqs_in]
	connect_bd_net -net axi_bootrom_control_bram_addr_a [get_bd_pins axi_bootrom_control/bram_addr_a] [get_bd_pins xlconcat_0/In0]
	connect_bd_net -net axi_bram_ctrl_0_bram_clk_a [get_bd_pins axi_bootrom_control/bram_clk_a] [get_bd_pins bootrom_wrapper_0/clk_i]
	connect_bd_net -net axi_bram_ctrl_0_bram_en_a [get_bd_pins axi_bootrom_control/bram_en_a] [get_bd_pins bootrom_wrapper_0/req_i]
	connect_bd_net -net axi_quad_spi_0_io0_o [get_bd_pins sdcard_quad_spi_axi/io0_o] [get_bd_ports spi_mosi]
	connect_bd_net -net axi_quad_spi_0_sck_o [get_bd_pins sdcard_quad_spi_axi/sck_o] [get_bd_ports spi_clk_o]
	connect_bd_net -net axi_quad_spi_0_ss_o [get_bd_pins sdcard_quad_spi_axi/ss_o] [get_bd_ports spi_ss]
	connect_bd_net -net axi_uart16550_0_ip2intc_irpt [get_bd_pins axi_uart16550_0/ip2intc_irpt] [get_bd_pins ariane_peripherals_0/uart_irq_i]
	connect_bd_net -net bootrom_wrapper_0_rdata_o [get_bd_pins bootrom_wrapper_0/rdata_o] [get_bd_pins axi_bootrom_control/bram_rddata_a]
	connect_bd_net -net clint_0_ipi_o [get_bd_pins clint_0/ipi_o] [get_bd_pins cpu_0/ipi_in]
	connect_bd_net -net clint_0_timer_irq_o [get_bd_pins clint_0/timer_irq_o] [get_bd_pins cpu_0/timer_irq_i]
	connect_bd_net -net clk_wiz_0_clk_spi [get_bd_pins clk_wiz_0/clk_spi] [get_bd_pins sdcard_quad_spi_axi/ext_spi_clk]
	connect_bd_net -net cpu_0_m_axi_cpu_awatop [get_bd_pins cpu_0/m_axi_cpu_awatop] [get_bd_pins northbridge/cpu_atop_in]
	connect_bd_net -net cpu_debug_debug_req_irq [get_bd_pins cpu_debug/debug_req_irq] [get_bd_pins cpu_0/debug_req_irq]
	connect_bd_net -net cpu_debug_m_axi_dmi_jtag_awatop [get_bd_pins cpu_debug/m_axi_dmi_jtag_awatop] [get_bd_pins northbridge/debug_module_atop]
	connect_bd_net -net cpu_debug_ndmreset [get_bd_pins cpu_debug/ndmreset] [get_bd_pins util_vector_logic_0/Op2]
	connect_bd_net -net cpu_interconnect_aresetn_1 [get_bd_pins cpu_reset_gen/interconnect_aresetn] [get_bd_pins northbridge/aresetn] [get_bd_pins cpu_debug/aresetn]
	connect_bd_net -net cpu_reset_gen_peripheral_aresetn [get_bd_pins cpu_reset_gen/peripheral_aresetn] [get_bd_pins northbridge/cpu_peripheral_aresetn] [get_bd_pins axi_bootrom_control/s_axi_aresetn] [get_bd_pins sdcard_quad_spi_axi/s_axi4_aresetn] [get_bd_pins axi_gpio_0/s_axi_aresetn] [get_bd_pins axi_uart16550_0/s_axi_aresetn] [get_bd_pins clint_0/aresetn] [get_bd_pins cpu_0/aresetn] [get_bd_pins ariane_peripherals_0/aresetn]
	connect_bd_net -net ddr4_0_c0_ddr4_ui_clk [get_bd_pins ddr4_0/c0_ddr4_ui_clk] [get_bd_pins northbridge/ddr_clk] [get_bd_pins proc_sys_reset_0/slowest_sync_clk]
	connect_bd_net -net ext_reset_1 [get_bd_ports sys_rst] [get_bd_pins util_vector_logic_0/Op1]
	connect_bd_net -net int_n_1 [get_bd_ports int_n] [get_bd_pins util_vector_logic_1/Op1]
	connect_bd_net -net irqconcat_dout [get_bd_pins irqconcat/dout] [get_bd_pins ariane_peripherals_0/irq_i]
	connect_bd_net -net led_0_a_1 [get_bd_ports led_0_a] [get_bd_ports led_ar_c_c2m]
	connect_bd_net -net mig_aclk_1 [get_bd_pins clk_wiz_0/clk_core] [get_bd_pins northbridge/aclk] [get_bd_pins axi_bootrom_control/s_axi_aclk] [get_bd_pins sdcard_quad_spi_axi/s_axi4_aclk] [get_bd_pins cpu_reset_gen/slowest_sync_clk] [get_bd_pins axi_gpio_0/s_axi_aclk] [get_bd_pins axi_uart16550_0/s_axi_aclk] [get_bd_pins clint_0/aclk] [get_bd_pins cpu_0/aclk] [get_bd_pins cpu_debug/aclk] [get_bd_pins ariane_peripherals_0/aclk]
	connect_bd_net -net northbridge_m_axi_clint_awatop [get_bd_pins northbridge/m_axi_clint_awatop] [get_bd_pins clint_0/s_axi_clint_awatop]
	connect_bd_net -net northbridge_m_axi_debug_awatop [get_bd_pins northbridge/m_axi_debug_awatop] [get_bd_pins cpu_debug/s_axi_dmi_jtag_awatop]
	connect_bd_net -net northbridge_m_axi_plic_awatop [get_bd_pins northbridge/m_axi_plic_awatop] [get_bd_pins ariane_peripherals_0/s_axi_plic_awatop]
	connect_bd_net -net northbridge_m_axi_timer_awatop [get_bd_pins northbridge/m_axi_timer_awatop] [get_bd_pins ariane_peripherals_0/s_axi_timer_awatop]
	connect_bd_net -net northbridge_mm2s_introut [get_bd_pins northbridge/mm2s_introut] [get_bd_pins irqconcat/In0]
	connect_bd_net -net northbridge_s2mm_introut [get_bd_pins northbridge/s2mm_introut] [get_bd_pins irqconcat/In1]
	connect_bd_net -net proc_sys_reset_0_interconnect_aresetn [get_bd_pins proc_sys_reset_0/interconnect_aresetn] [get_bd_pins northbridge/ddr_aresetn]
	connect_bd_net -net proc_sys_reset_0_peripheral_aresetn [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_pins ddr4_0/c0_ddr4_aresetn]
	connect_bd_net -net proc_sys_reset_0_peripheral_reset [get_bd_pins proc_sys_reset_0/peripheral_reset] [get_bd_pins ddr4_0/sys_rst]
	connect_bd_net -net rst_ps8_0_200M_peripheral_aresetn [get_bd_pins ddr4_0/c0_ddr4_ui_clk_sync_rst] [get_bd_pins cpu_reset_gen/aux_reset_in]
	connect_bd_net -net sdcard_quad_spi_axi_ip2intc_irpt [get_bd_pins sdcard_quad_spi_axi/ip2intc_irpt] [get_bd_pins ariane_peripherals_0/spi_irq_i]
	connect_bd_net -net spi_miso_1 [get_bd_ports spi_miso] [get_bd_pins sdcard_quad_spi_axi/io1_i]
	connect_bd_net -net util_vector_logic_0_Res [get_bd_pins util_vector_logic_0/Res] [get_bd_pins cpu_reset_gen/ext_reset_in]
	connect_bd_net -net util_vector_logic_1_Res [get_bd_pins util_vector_logic_1/Res] [get_bd_pins irqconcat/In2]
	connect_bd_net -net xlconcat_0_dout [get_bd_pins xlconcat_0/dout] [get_bd_pins bootrom_wrapper_0/addr_i]
	connect_bd_net -net xlconstant_0_dout [get_bd_pins xlconstant_0/dout] [get_bd_pins axi_uart16550_0/freeze]
	connect_bd_net -net xlconstant_1_dout [get_bd_pins xlconstant_1/dout] [get_bd_pins cpu_debug/jtag_trst_n]
	connect_bd_net -net xlconstant_2_dout [get_bd_pins xlconstant_2/dout] [get_bd_ports led_ar_a_c2m]
	connect_bd_net -net xlconstant_3_dout [get_bd_pins xlconstant_3/dout] [get_bd_pins irqconcat/In3]
	connect_bd_net -net xlconstant_4_dout [get_bd_pins xlconstant_4/dout] [get_bd_pins proc_sys_reset_0/ext_reset_in] [get_bd_pins proc_sys_reset_0/aux_reset_in]

	# Create address segments
	assign_bd_address -offset 0x00000000 -range 0x00010000000000000000 -target_address_space [get_bd_addr_spaces cpu_0/m_axi_cpu] [get_bd_addr_segs northbridge/axi_xbar_interface_v_0/s_axi_cpu/reg0] -force
	assign_bd_address -offset 0x00000000 -range 0x00010000000000000000 -target_address_space [get_bd_addr_spaces cpu_debug/m_axi_dmi_jtag] [get_bd_addr_segs northbridge/axi_xbar_interface_v_0/s_axi_debug/reg0] -force
	assign_bd_address -offset 0x80000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces northbridge/axi_riscv_amos_wrapp_0/m_axi_out] [get_bd_addr_segs ddr4_0/C0_DDR4_MEMORY_MAP/C0_DDR4_ADDRESS_BLOCK] -force
	assign_bd_address -offset 0x00010000 -range 0x00010000 -target_address_space [get_bd_addr_spaces northbridge/axi_xbar_interface_v_0/m_axi_bootrom] [get_bd_addr_segs axi_bootrom_control/S_AXI/Mem0] -force
	assign_bd_address -offset 0x02000000 -range 0x00040000 -target_address_space [get_bd_addr_spaces northbridge/axi_xbar_interface_v_0/m_axi_clint] [get_bd_addr_segs clint_0/s_axi_clint/reg0] -force
	assign_bd_address -offset 0x00000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces northbridge/axi_xbar_interface_v_0/m_axi_debug] [get_bd_addr_segs cpu_debug/s_axi_dmi_jtag/reg0] -force
	assign_bd_address -offset 0x40000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces northbridge/axi_xbar_interface_v_0/m_axi_gpio] [get_bd_addr_segs axi_gpio_0/S_AXI/Reg] -force
	assign_bd_address -offset 0x0C000000 -range 0x04000000 -target_address_space [get_bd_addr_spaces northbridge/axi_xbar_interface_v_0/m_axi_plic] [get_bd_addr_segs ariane_peripherals_0/s_axi_plic/reg0] -force
	assign_bd_address -offset 0x18000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces northbridge/axi_xbar_interface_v_0/m_axi_timer] [get_bd_addr_segs ariane_peripherals_0/s_axi_timer/reg0] -force
	assign_bd_address -offset 0x00000000 -range 0x00010000000000000000 -target_address_space [get_bd_addr_spaces northbridge/axi_xbar_interface_v_0/m_axi_ram] [get_bd_addr_segs northbridge/axi_riscv_amos_wrapp_0/s_axi_in/reg0] -force
	assign_bd_address -offset 0x20000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces northbridge/axi_xbar_interface_v_0/m_axi_sdcard] [get_bd_addr_segs sdcard_quad_spi_axi/aximm/MEM0] -force
	assign_bd_address -offset 0x10000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces northbridge/axi_xbar_interface_v_0/m_axi_uart] [get_bd_addr_segs axi_uart16550_0/S_AXI/Reg] -force
	

	# Restore current instance
	current_bd_instance $oldCurInst

	validate_bd_design
	save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################
create_root_design ""

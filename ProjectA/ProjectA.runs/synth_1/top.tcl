# 
# Synthesis run script generated by Vivado
# 

create_project -in_memory -part xc7a100tcsg324-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir E:/Vivado/Projects/ProjectA/ProjectA.cache/wt [current_project]
set_property parent.project_path E:/Vivado/Projects/ProjectA/ProjectA.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property ip_output_repo e:/Vivado/Projects/ProjectA/ProjectA.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_verilog E:/Vivado/Projects/ProjectA/ProjectA.srcs/sources_1/imports/new/display640x480.vh
read_verilog -library xil_defaultlib -sv {
  E:/Vivado/Projects/ProjectA/ProjectA.srcs/sources_1/imports/sources_1/imports/sources_1/imports/sources_1/new/ALU.sv
  E:/Vivado/Projects/ProjectA/ProjectA.srcs/sources_1/new/LED_reg.sv
  E:/Vivado/Projects/ProjectA/ProjectA.srcs/sources_1/imports/sources_1/imports/lol/accelerometer.sv
  E:/Vivado/Projects/ProjectA/ProjectA.srcs/sources_1/imports/sources_1/imports/sources_1/imports/sources_1/new/adder.sv
  E:/Vivado/Projects/ProjectA/ProjectA.srcs/sources_1/imports/sources_1/imports/sources_1/imports/sources_1/new/addsub.sv
  E:/Vivado/Projects/ProjectA/ProjectA.srcs/sources_1/imports/new/bitmapmem.sv
  E:/Vivado/Projects/ProjectA/ProjectA.srcs/sources_1/new/clockdivider_Nexys4.sv
  E:/Vivado/Projects/ProjectA/ProjectA.srcs/sources_1/imports/sources_1/imports/sources_1/imports/sources_1/new/comparator.sv
  E:/Vivado/Projects/ProjectA/ProjectA.srcs/sources_1/imports/sources_1/new/controller.sv
  E:/Vivado/Projects/ProjectA/ProjectA.srcs/sources_1/imports/sources_1/imports/sources_1/new/datapath.sv
  E:/Vivado/Projects/ProjectA/ProjectA.srcs/sources_1/imports/sources_1/new/dmem.sv
  E:/Vivado/Projects/ProjectA/ProjectA.srcs/sources_1/imports/sources_1/imports/new/fulladder.sv
  E:/Vivado/Projects/ProjectA/ProjectA.srcs/sources_1/imports/sources_1/new/imem.sv
  E:/Vivado/Projects/ProjectA/ProjectA.srcs/sources_1/imports/sources_1/new/keyboard.sv
  E:/Vivado/Projects/ProjectA/ProjectA.srcs/sources_1/imports/sources_1/imports/sources_1/imports/sources_1/new/logical.sv
  E:/Vivado/Projects/ProjectA/ProjectA.srcs/sources_1/new/memIO.sv
  E:/Vivado/Projects/ProjectA/ProjectA.srcs/sources_1/imports/sources_1/new/mips.sv
  E:/Vivado/Projects/ProjectA/ProjectA.srcs/sources_1/imports/sources_1/new/montek_sound_Nexys4.sv
  E:/Vivado/Projects/ProjectA/ProjectA.srcs/sources_1/imports/sources_1/new/programcounter.sv
  E:/Vivado/Projects/ProjectA/ProjectA.srcs/sources_1/imports/sources_1/imports/sources_1/new/register_file.sv
  E:/Vivado/Projects/ProjectA/ProjectA.srcs/sources_1/imports/new/screenmem.sv
  E:/Vivado/Projects/ProjectA/ProjectA.srcs/sources_1/imports/sources_1/imports/sources_1/imports/sources_1/new/shifter.sv
  E:/Vivado/Projects/ProjectA/ProjectA.srcs/sources_1/new/sound_reg.sv
  E:/Vivado/Projects/ProjectA/ProjectA.srcs/sources_1/imports/imports/sources_1/new/vgadisplaydriver.sv
  E:/Vivado/Projects/ProjectA/ProjectA.srcs/sources_1/imports/imports/sources_1/new/vgatimer.sv
  E:/Vivado/Projects/ProjectA/ProjectA.srcs/sources_1/imports/imports/sources_1/imports/new/xycounter.sv
  E:/Vivado/Projects/ProjectA/ProjectA.srcs/sources_1/imports/sources_1/new/top.sv
}
read_vhdl -library xil_defaultlib {
  E:/Vivado/Projects/ProjectA/ProjectA.srcs/sources_1/imports/sources_1/imports/lol/ADXL362Ctrl.vhd
  E:/Vivado/Projects/ProjectA/ProjectA.srcs/sources_1/imports/sources_1/imports/lol/AccelArithmetics.vhd
  E:/Vivado/Projects/ProjectA/ProjectA.srcs/sources_1/imports/sources_1/imports/lol/AccelerometerCtl.vhd
  E:/Vivado/Projects/ProjectA/ProjectA.srcs/sources_1/imports/sources_1/imports/lol/SPI_If.vhd
}
# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc E:/Vivado/Projects/ProjectA/ProjectA.srcs/constrs_1/imports/constrs_1/new/accel.xdc
set_property used_in_implementation false [get_files E:/Vivado/Projects/ProjectA/ProjectA.srcs/constrs_1/imports/constrs_1/new/accel.xdc]

read_xdc E:/Vivado/Projects/ProjectA/ProjectA.srcs/constrs_1/imports/constrs_1/new/clock.xdc
set_property used_in_implementation false [get_files E:/Vivado/Projects/ProjectA/ProjectA.srcs/constrs_1/imports/constrs_1/new/clock.xdc]

read_xdc E:/Vivado/Projects/ProjectA/ProjectA.srcs/constrs_1/imports/constrs_1/new/keyboard.xdc
set_property used_in_implementation false [get_files E:/Vivado/Projects/ProjectA/ProjectA.srcs/constrs_1/imports/constrs_1/new/keyboard.xdc]

read_xdc E:/Vivado/Projects/ProjectA/ProjectA.srcs/constrs_1/imports/constrs_1/new/led.xdc
set_property used_in_implementation false [get_files E:/Vivado/Projects/ProjectA/ProjectA.srcs/constrs_1/imports/constrs_1/new/led.xdc]

read_xdc E:/Vivado/Projects/ProjectA/ProjectA.srcs/constrs_1/imports/constrs_1/new/sound.xdc
set_property used_in_implementation false [get_files E:/Vivado/Projects/ProjectA/ProjectA.srcs/constrs_1/imports/constrs_1/new/sound.xdc]

read_xdc E:/Vivado/Projects/ProjectA/ProjectA.srcs/constrs_1/new/vga.xdc
set_property used_in_implementation false [get_files E:/Vivado/Projects/ProjectA/ProjectA.srcs/constrs_1/new/vga.xdc]

read_xdc E:/Vivado/Projects/ProjectA/ProjectA.srcs/constrs_1/new/reset.xdc
set_property used_in_implementation false [get_files E:/Vivado/Projects/ProjectA/ProjectA.srcs/constrs_1/new/reset.xdc]


synth_design -top top -part xc7a100tcsg324-1


write_checkpoint -force -noxdef top.dcp

catch { report_utilization -file top_utilization_synth.rpt -pb top_utilization_synth.pb }
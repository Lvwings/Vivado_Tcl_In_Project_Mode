# MIT License
# 
# Copyright (c) [2021] Lvwings
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# file list
# work_dir
#	|-- tcl
#	|-- sources
#		|-- rtl
#		|-- coe
#		|-- ips
#	|-- sim
#	|-- constrs

#---------------------------------------------------------
# user settings
#---------------------------------------------------------

# STEP 0 : define work directory
set 	work_dir			D:/SourceTree/SourceTree/Vivado_Project_Mode
cd							$work_dir

# STEP 1 : define project name
set 	project_name		test

# STEP 2 : define FPGA Chip 
set		device				xc7a100t
set 	package            	fgg484
set 	speed              	-2L
set 	part             	$device$package$speed

# STEP 3 : define the output directory area
set		project_dir 		[file normalize ./$project_name	]
file	mkdir 				$project_dir

# STEP 4 : define file directory
set 	sources_dir			[file normalize ./sources	] 
set 	sim_dir				[file normalize ./sim		]	
set 	constrs_dir			[file normalize ./constrs	]	
set 	tcl_dir				[file normalize ./tcl		]	

# STEP 5 : define top module name
set		top					eth_top

#---------------------------------------------------------
# add files
#---------------------------------------------------------

# create project
create_project $project_name $project_dir -part $part -force

# add find_files $basedir $pattern : match the specific ".extension" in basedir and its subdirectory
source [file join $tcl_dir proc_find_files.tcl]
source [file join $tcl_dir proc_update_files.tcl]

# add source files - include subdirectory
# [-quiet] Ignore command errors (handle no file matches "*.extension" case)

# find_files {base_dir pattern}
# base_dir- the directory to start looking in
# pattern - A match pattern, as defined by the glob command
add_files 				-quiet	[find_files $sources_dir/rtl *.sv]
add_files 				-quiet	[find_files $sources_dir/rtl *.v]
add_files 				-quiet	[find_files $sources_dir/rtl *.vh]
add_files 				-quiet 	[find_files $sources_dir/coe *.coe]	
add_files 				-quiet	[find_files $sources_dir/ips *.xcix]
update_compile_order 	-fileset sources_1

# add simulation files
add_files 				-fileset sim_1	-quiet [find_files $sim_dir *.sv]
update_compile_order 	-fileset sim_1

# add constraint files
add_files 				-fileset constrs_1 -quiet [find_files $constrs_dir *.xdc]
update_compile_order 	-fileset constrs_1


#---------------------------------------------------------
# options : update unavailable coe file
#---------------------------------------------------------

# update_file {base_dir config_type}
# base_dir      - the directory storing update file
# config_type   - exact config property of ips (use [get_property [get_ips $ipname]] to find) 
#                 for example: coe file - CONFIG.coefficient_file
remove_files 			[get_files -of [get_filesets sources_1] -filter {!IS_AVAILABLE && FILE_TYPE == "Coefficient Files"}]
update_files 			$sources_dir/coe "CONFIG.coefficient_file"

#---------------------------------------------------------
# project settings
#---------------------------------------------------------
set_property 			coreContainer.enable 1 [current_project]

#---------------------------------------------------------
# run synthesis and the default utilization report.
#---------------------------------------------------------
#set_property			strategy Default [get_runs synth_1]

launch_runs 			synth_1
wait_on_run 			synth_1

#---------------------------------------------------------
# run logic optimization, placement, physical logic optimization and route.
# bitstream generation -to_step write_bitstream
#---------------------------------------------------------

# set_property STEPS.PHYS_OPT_DESIGN.IS_ENABLED true [get_runs impl_1]
# set_property STEPS.OPT_DESIGN.TCL.PRE [pwd]/pre_opt_design.tcl [get_runs impl_1]
# set_property STEPS.OPT_DESIGN.TCL.POST [pwd]/post_opt_design.tcl [get_runs impl_1]
# set_property STEPS.PLACE_DESIGN.TCL.POST [pwd]/post_place_design.tcl [get_runs impl_1]
# set_property STEPS.PHYS_OPT_DESIGN.TCL.POST [pwd]/post_phys_opt_design.tcl [get_runs impl_1]
# set_property STEPS.ROUTE_DESIGN.TCL.POST [pwd]/post_route_design.tcl [get_runs impl_1]

launch_runs 			impl_1 
wait_on_run 			impl_1 
puts "Implementation done!"

#start_gui
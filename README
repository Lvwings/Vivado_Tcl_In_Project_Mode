# Vivado Tcl in project mode

## overview

This project is based on Tcl script for Vivado to regenerate  project in project mode. Its main purpose is to assist code management  and be an aid for project migration. 

Main function of this project is to ：

- add existing files include subdirectory (RTL code, IP files, etc.)
- replace false-path configuration files（coe file verified）
- run general design flow

The Tcl script is mainly divided into 3 parts ：

- user settings（define work directory，FPGA specification，etc.）
- add files
- run synthesis and Implementation

## How to use

open Vivado/Tools/Run Tcl Script, select `launch.tcl` (./tcl/) 

## user settings

work directory file list：

```tcl
# file list
# work_dir
#	|-- tcl
#	|-- sources
#		|-- rtl
#		|-- coe
#		|-- ips
#	|-- sim
#	|-- constrs
```

In this part, 6-property should be define :

- work directory : main directory where codes and project be placed

```tcl
# STEP 0 : define work directory
set 	work_dir			D:/
cd							$work_dir
```

- project name

```tcl
# STEP 1 : define project name
set 	project_name		test
```

- FPGA specification 

```tcl
# STEP 2 : define FPGA Chip 
set		device				xc7a100t
set 	package            	fgg484
set 	speed              	-2L
set 	part             	$device$package$speed
```

- regeneration project directory

```tcl
# STEP 3 : define the output directory area
set		project_dir 		[file normalize ./$project_name	]
file	mkdir 				$project_dir
```

- existing file directory

```tcl
# STEP 4 : define file directory
set 	sources_dir			[file normalize ./sources	] 
set 	sim_dir				[file normalize ./sim		]	
set 	constrs_dir			[file normalize ./constrs	]	
set 	tcl_dir				[file normalize ./tcl		]	
```

- top module name (option)

```tcl
# STEP 5 : define top module name
set		top					eth_top
```



## add files

Two process are designed to help search and replace files

### find_files

find_files makes it possible to search specific extension file in provided directory and its subdirectory. It returns the path of the matched files and {} is returned if no file matched.

```tcl
# find_files {base_dir pattern}
# basedir - the directory to start looking in
# pattern - A match pattern, as defined by the glob command
```

How to use : add all .sv files in RTL directory 

```tcl
add_files 				-quiet	[find_files $sources_dir/rtl *.sv]
```

### update_file

update_files is designed to replace the false-path  configuration files of used ips. 

```tcl
# update_file {base_dir config_type}
# base_dir      - the directory storing update file
# config_type   - exact config property of ips (use [get_property [get_ips $ipname]] to find) 
```

How to use : replace .coe files of ip

```tcl
update_files 			$sources_dir/coe "CONFIG.coefficient_file"
```



## run synthesis and Implementation

run synthesis  and Implementation

```tcl
launch_runs 			synth_1
wait_on_run 			synth_1
launch_runs 			impl_1 
wait_on_run 			impl_1 
```


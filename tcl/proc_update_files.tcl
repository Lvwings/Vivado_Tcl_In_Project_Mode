# update_file : update specific file from used ips
# base_dir      - the directory storing update file
# config_type   - exact config property of ips (use [get_property [get_ips $ipname]] to find) 
#                 for example: coe file - CONFIG.coefficient_file

proc update_files {base_dir config_type} {
    # Fix the directory name, this ensures the directory name is : ./xx/xx/  (To match [glob] grammar)
    # 1. in the native format for the platform
    # 2. contains a final directory seperator "/" (string trimright: cut out blank " " )
    set base_dir [string trimright [file join [file normalize $base_dir] { }]]

    # seach all used ips for config_type
    foreach ipname [get_ips] {
        # get the previous file directory : for ip's property doesn't match config_type retrun {}
    	set pre_file_dir [get_property -quiet $config_type [get_ips $ipname]]
        # when ip's property matches config_type
    	if {[llength "$pre_file_dir"] > 0} {
            # get the file name 
    		set file_name	    [file tail $pre_file_dir]
            # get the update file in base directory
    		set update_file 	[glob -nocomplain -type {f r} -path $base_dir $file_name]
            # change directory
    		set_property  -dict [list $config_type $update_file] [get_ips $ipname] 
            puts           "IP-$ipname update File-$file_name successful."      		
    	}
    }
}
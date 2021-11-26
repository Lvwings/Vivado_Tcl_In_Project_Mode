# find_files
# base_dir - the directory to start looking in
# pattern - A match pattern, as defined by the glob command

proc find_files { base_dir pattern } {

    # Fix the directory name, this ensures the directory name is : ./xx/xx/ (To match [glob] grammar)
    # 1. in the native format for the platform
    # 2. contains a final directory seperator "/" (string trimright cut out blank " " )
    set base_dir [string trimright [file join [file normalize $base_dir] { }]]
    set fileList {}

    # Look in the current directory for matching files 
    # -type {f r} means only readable normal files are looked at
    # -nocomplain stops an error being thrown if the returned list is empty
    foreach fileName [glob -nocomplain -type {f r} -path $base_dir $pattern] {
        lappend fileList $fileName
    }

    # Now look for any sub direcories in the current directory
    foreach dir_name [glob -nocomplain -type {d r} -path $base_dir *] {
        # Recusively call the routine on the sub directory and append any
        # new files to the results
        set subDirList [find_files $dir_name $pattern]
        if { [llength $subDirList] > 0 } {
            foreach subDirFile $subDirList {
                lappend fileList $subDirFile
            }
        }
    }
    return $fileList
 }
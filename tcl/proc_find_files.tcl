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
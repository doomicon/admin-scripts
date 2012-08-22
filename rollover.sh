#!/bin/bash
# http://stackoverflow.com/questions/3690936/change-file-name-suffixes-using-sed/3691279#3691279
# rollover.sh
#   Rolls over log files in the current directory.
#     *.log.8 -> *.log.9
#     *.log.7 -> *.log.8
#     : : :
#     *.log.1 -> *.log.2
#     *.log   -> *.log.1

shft() {
    # Change this '8' to one less than your desired maximum rollover file.
    # Must be in reverse order for renames to work (n..1, not 1..n).
    for suff in {8..1} ; do
        if [[ -f "$1.${suff}" ]] ; then
            ((nxt = suff + 1))
            echo Moving "$1.${suff}" to "$1.${nxt}"
            mv -f "$1.${suff}" "$1.${nxt}"
        fi
    done
    echo Moving "$1" to "$1.1"
    mv -f "$1" "$1.1"
}

for fspec in *.sql ; do
    shft "${fspec}"
    #date >"${fspec}" #DEBUG code
done

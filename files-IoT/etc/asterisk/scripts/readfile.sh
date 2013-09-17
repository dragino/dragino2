#!/bin/ash
# This is a simple AGI script that provides equivalent functionality to the ReadFile command missing in 
# the asterisk 1.8 packages for OpenWRT rv28943. 
# Author: K Williamson 2011

# First read through all of the AGI channel variables written to stdout at the start of an AGI invocation. The 
# final three are the arg_v arguments supplied in the user's AGI call. Those are the only ones we're interested in. 
# Each variable is output in the form of "VARNAME: value" so we strip out the colon with sed and then grab just 
# the value with cut. 

# ARG1 will be the channel variable specified by the caller.
# ARG2 will be the file to read
# ARG3 will be the max length to read

while read ARG && [ "$ARG" ] ; do
	ARG1=$ARG2
	ARG2=$ARG3
	ARG3=`echo $ARG | sed -e 's/://' | cut -d' ' -f2`
done

# Standard checkresults function needed to read the AGI response to the AGI command invoked in the script.
checkresults() {
	while read line
	do
	case ${line:0:4} in
	"200 " ) echo $line >> /tmp/agi-log
	         return;;
	"510 " ) echo $line >> /tmp/agi-log
	         return;;	
	"520 " ) echo $line >> /tmp/agi-log
	         return;;
	*      ) echo $line >> /tmp/agi-log ;;	#keep on reading those Invlid command
					#command syntax until "520 End ..."
	esac
	done
}

# Read just the first line of the file specified in ARG2 and then cut out the first ARG3 bytes. 
RESULT=`head $ARG2 | cut -b 1-$ARG3`

# Issue the "SET VARIABLE" AGI command to set the requested channel variable in ARG1 to the RESULT from above.
echo "SET VARIABLE $ARG1 $RESULT"

# Run checkresults to satisfy AGI's blocked-write of the result code. 
checkresults

exit 0



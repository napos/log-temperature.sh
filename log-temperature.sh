#!/bin/bash

### log-temperature.sh v1.0
#
# Copyright 2013, 2014 Siim Orasmäe
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
###
#
# Usage: log-temperature.sh [-i SECONDS] [-1] [-f] [-h]
#
#  -i	interval of readings (in seconds)
#  -1	poll once and exit
#  -f	display temperature in Fahrenheit
#  -h	print help
#
###

# Default interval between polling (in seconds)
DEFAULT_INTERVAL="10"

# What command-line calculator to use
CLI_CALCULATOR="bc"

#######################################################################


# Read RPi's SoC temperature
function read_soc {
	local TEMPSOC=$(/opt/vc/bin/vcgencmd measure_temp)
	echo -n ${TEMPSOC:5:4}
	}

# Read 1-Wire temperature sensors
function read_w1 {
	local W1DEVICES=$(find -H -O1 /sys/bus/w1/devices/28* -type f -name w1_slave)
	for i in $W1DEVICES; do
		TEMP=$(sed -n '2{p;q;}' $i)
		TEMP=${TEMP:29}
		TEMP=$(echo "scale=1;$TEMP/1000" | $CLI_CALCULATOR)
		echo -n "$TEMP "
	done
	}

# Convert C to F, requires $1
function convert_f {
    local TEMP=$(echo "scale=1;((9/5) * $1) + 32" | $CLI_CALCULATOR)
	echo -n "$TEMP "
	}


# Handle command-line options and arguments
while getopts ":i:fh1" opt; do
  case $opt in
  	h)
  		echo -e "Usage: log-temperature.sh [-i SECONDS] [-1] [-f] [-h]\n"
		echo    "  -i	interval in seconds (default 10)"
		echo    "  -1	poll temperatures only once and exit"
		echo    "  -f	display temperatures in Fahrenheit"
		echo -e "  -h	print help\n"
		echo    "Example: $0 -i 2 -f"
  		exit 1
  		;;
	i)
		REGNR="^[0-9]+([.][0-9]+)?$" # is it a number?
		if ! [[ $OPTARG =~ $REGNR ]]
			then
				echo "Option -i requires a number!" >&2
				echo "Use $0 -h to see valid options."
				exit 2
		fi
		OPI=$OPTARG
		;;
	f)
		OPF=true
		;;
	1)
		OP1=true
		;;
	\?)
		echo "Invalid option: -$OPTARG" >&2
		echo "Use $0 -h to see valid options."
		exit 2
		;;
    :)
		echo "Option -$OPTARG requires an argument." >&2
		echo "Use $0 -h to see valid arguments."
		exit 2
		;;
  esac
done


# The magic of looping shall commence!
while :
		do
			# Display date and time (ready, set, action!)
			echo -en $(date +"%d-%m-%Y %T\t")

			# Poll everything
			DISPLAY_SOC=$(read_soc)
			DISPLAY_W1=$(read_w1)
			
			# Do the Fahrenheit dance OR display sane numbers
			if [ $OPF ]
					then
						convert_f $DISPLAY_SOC
						for i in $DISPLAY_W1; do
							convert_f $i
						done
						echo " " # add \n at the end (pretty bash)
					else
						echo -n "$DISPLAY_SOC " # default no-arguments output!
						echo "$DISPLAY_W1"
			fi

			# Exit if the 'display once' option is enabled
			if [ $OP1 ]
					then
						exit 0
			fi

			# Use interval from command-line.. or don't
			if [ $OPI ]
					then
						sleep $OPI
					else
						sleep $DEFAULT_INTERVAL
			fi
		done

exit 0
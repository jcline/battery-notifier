#!/bin/bash

OLD=1
SHORT_SLEEP="1m"
MED_SLEEP="5m"
LONG_SLEEP="15m"

SLEEP=$LONG_SLEEP

while [ true ]
do

	if [ `< /sys/class/power_supply/BAT0/status` == "Discharging" ]
	then
		let NOW=`< /sys/class/power_supply/BAT0/charge_now`
		let FULL=`< /sys/class/power_supply/BAT0/charge_full`

		PERCENT="$(echo "scale = 5; $NOW / $FULL" | bc)"

		if [ $(echo "$PERCENT < .05" | bc) == 1 ]
		then
			SLEEP=$MED_SLEEP
			wall "`echo "$PERCENT*100" | bc`% battery left!"

			if [ $(echo "$PERCENT <= .01" | bc) == 1 ]
			then
				shutdown -Ph now
			fi
		fi

		OLD=$PERCENT
	else
		SLEEP=$LONG_SLEEP
	fi

	sleep $SLEEP
done

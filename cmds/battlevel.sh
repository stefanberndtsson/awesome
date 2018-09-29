#!/bin/bash

charge=$(cat /sys/class/power_supply/CMB1/charge_now)
full=$(cat /sys/class/power_supply/CMB1/charge_full)
percent=$(expr \( "$charge" \* 100 \) / "$full")
status=$(cat /sys/class/power_supply/CMB1/status)
direction="done"
if test "x$status" = "xCharging"
then
    direction="up"
fi

if test "x$status" = "xDischarging"
then
    direction="down"
fi

# acpi | sed -n 's/^.*, \([0-9]*\)%/\1/p'
echo "${direction} ${percent}"

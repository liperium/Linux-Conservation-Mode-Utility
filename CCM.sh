# Change Conservation Mode - Only accepts certain inputs
if [ $1 -eq 0 ] || [ $1 -eq 1 ]
then 
    echo "$1"| sudo tee /sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode
fi
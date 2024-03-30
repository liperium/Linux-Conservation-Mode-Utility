#!/bin/sh

# Remote stuff
BASE_URL="https://github.com/liperium/Linux-Conservation-Mode-Utility/releases/latest/download/"
DEFAULT="TrayConservationMode.tar.gz"
FILENAME="$DEFAULT"

# Install paths
FOLDER="conservation_mode"
BIN_FILE="conservationmode"
APP_INSTALL_FOLDER="/opt"
BIN_INSTALL_FOLDER="/usr/local/bin"

# Conservationmode file for the platform
CONSERVATIONMODEFILE=/sys/bus/platform/drivers/ideapad_acpi/VPC2004\:00/conservation_mode

# The permissions to read/write said file from the user, instead of giving conservation_mode sudo, prefer that way.
TO_ADD="%wheel ALL=(ALL) NOPASSWD: /usr/bin/tee $CONSERVATIONMODEFILE"

#Launch as sudo
[ "$UID" -eq 0 ] || exec sudo sh "$0" "$@"

#Go to tmp dir for manips
cd /tmp

#Test to see if system has right conservation_mode file
if test -f "$CONSERVATIONMODEFILE"; then
    echo "Found right conservation_mode file, installation can proceed."
else
    echo "conservation_mode file not found at correct directory, please try to install/compile program with the right folder"
    exit
fi

#Get latest release and extract
COMMAND="$BASE_URL$FILENAME"
wget "$COMMAND"
tar -xf $FILENAME

#Remove old version, even if doesn't exist
rm -r "$APP_INSTALL_FOLDER/$FOLDER"
rm "$BIN_INSTALL_FOLDER/$BIN_FILE"

#Move files
sudo mv "$FOLDER/$BIN_FILE" "$BIN_INSTALL_FOLDER/$BIN_FILE" #conservation mode cli
mv "$FOLDER" "$APP_INSTALL_FOLDER" # conservation mode app

#Give permission to anyone to tee the file (best way for now) and only adds if not already in file
sudo cat /etc/sudoers | grep "%wheel ALL=(ALL) NOPASSWD: /usr/bin/tee /sys/bus/platform/drivers/ideapad_acpi/VPC2004\\\\:00/conservation_mode" >/dev/null|| echo "$TO_ADD" | sudo EDITOR='tee -a' visudo

#Cleanup
rm -r $FILENAME
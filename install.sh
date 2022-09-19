#!/usr/bin/env bash


BASE_URL="https://github.com/liperium/Linux-Conservation-Mode-Utility/releases/latest/download/"
DEFAULT="TrayConservationMode.tar.gz"
LEGACY="TrayConservationMode_Legacy.tar.gz"
FILENAME="$DEFAULT"
FOLDER="TCM"
BIN_FILE="conservationmode"
USER_HOME=$(eval echo ~${SUDO_USER})
INSTALL_FOLDER="$USER_HOME/Documents"
CURR_DIR=$(pwd)
TO_ADD="%wheel ALL=(ALL) NOPASSWD: /usr/bin/tee /sys/bus/platform/drivers/ideapad_acpi/VPC2004\:00/conservation_mode"

#Launch as sudo
[ "$UID" -eq 0 ] || exec sudo bash "$0" "$@"

#Go to current dir ( because switched to sudo )
cd $CURR_DIR

#Legacy appindicators? Or ayatana
echo "Do you want to use legacy appindicators Y/n"
read -n 1 ans
echo $ans

if [[ $ans == "y" || $ans == "Y" ]]; then
    FILENAME=$LEGACY
fi

#Get latest release and extract
COMMAND="$BASE_URL$FILENAME"
wget "$COMMAND"
tar -xf $FILENAME

#Remove old version
rm -r "$INSTALL_FOLDER/$FOLDER"

#Move files
sudo mv "$FOLDER/$BIN_FILE" "/usr/bin/$BIN_FILE" #conservation mode cli
mv "$FOLDER" "$INSTALL_FOLDER" # conservation mode app

#Give permission to anyone to tee the file (best way for now)
sudo cat /etc/sudoers | grep "%wheel ALL=(ALL) NOPASSWD: /usr/bin/tee /sys/bus/platform/drivers/ideapad_acpi/VPC2004\\\\:00/conservation_mode" >/dev/null|| echo "$TO_ADD" | sudo EDITOR='tee -a' visudo


#Cleanup
rm -r $FILENAME
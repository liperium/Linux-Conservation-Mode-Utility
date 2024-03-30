# Linux Conservation Mode for Lenovo laptops

A tray application that shows the status of conservation mode and helps you enable it or disable it!

<p align="center">
  <img src="https://github.com/liperium/Linux-Conservation-Mode-Utility/blob/master/demo.gif" alt="Demo of the tray service"/>
</p>

**This project is a [fork from my previous one](https://github.com/liperium/Linux-Conservation-Mode-For-Lenovo) re-written in Go instead of Python. It is way smaller (executable file is 90% smaller and in ram ~40% smaller)**

## Works for

- Lenovo Legion 5 ( code : VPC2004:00 )

Many more laptops can be adapted with the right path in the *conservationmode* file

# Install with script

Copy the install.sh file of this repo. Same as the manual install, it doesn't add a .desktop and doesn't auto-start.

# Manual Installation

### Make sure you have libayatana-appindicator3

1. Download [latest release](https://github.com/liperium/Linux-Conservation-Mode-Utility/releases/latest)

2. Extract to /opt/conservation_mode

3. Move conservationmode to /usr/local/bin

4. Add permissions to access the file to the visudo

    1. sudo visudo

    2. Add to the end **(replace ```wheel``` with ```sudo``` if on Debian)** [issue](https://github.com/liperium/Linux-Conservation-Mode-Utility/issues/4):

           %wheel ALL=(ALL) NOPASSWD: /usr/bin/tee /sys/bus/platform/drivers/ideapad_acpi/VPC2004\:00/conservation_mode

5. Run TrayConservationMode

6. Optional : Add to startup applications and make a .desktop

### DEPRECATED SINCE 1.1 - If you have a problem with a appindicator dependancy and using the Legacy version, make sure you install the correct package as found in this [issue](https://github.com/liperium/Linux-Conservation-Mode-Utility/issues/3#issuecomment-1384463218)

## .desktop Entry template file (replace %USER% with yours)

```
[Desktop Entry]
Comment=
Exec=/opt/conservation_mode/TrayConservationMode
GenericName=Tray conservation mode manager for Lenovo laptops\s
Icon=/opt/conservation_mode/assets/iconOn.ico
Name=Tray Conservation Mode
NoDisplay=false
Terminal=false
Type=Application
```

# Linux Conservation Mode for Lenovo laptops

A tray application that shows the status of conservation mode and helps you enable it or disable it!

<p align="center">
  <img src="https://github.com/liperium/Linux-Conservation-Mode-For-Lenovo/blob/main/demo.gif" alt="Demo of the tray service"/>
</p>

## Works for :

- Lenovo Legion 5

Many more laptops can be adapted with the right settings in the .py and .sh

# Installation

## If you have the same laptop ( code : VPC2004:00 )

1. Download [latest release ](https://github.com/liperium/Linux-Conservation-Mode-For-Lenovo/releases)

2. Extract to Documents ( the directory TCM must be in documents for now )

3. Add CCM.sh to the visudo

    1. sudo visudo

    2. Add to the end : 
    
           **USER** ALL=(ALL:ALL) NOPASSWD:/home/**USER**/Documents/TCM/CCM.sh 

4. Run TrayConservationMode

5. Optional : Add to startup applications and make a .desktop
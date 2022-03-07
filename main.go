package main

import (
	"fmt"
	"io/ioutil"
	"os"
	"os/exec"
	"os/user"
	"path/filepath"

	"github.com/getlantern/systray"
)

func main() {
	systray.Run(onReady, onExit)
}

func getRunningDir() string {
	// ex, err := osext.Executable()
	// if err != nil {
	// 	panic(err)
	// }
	// exPath := filepath.Dir(ex)
	// TODO change this to be dynamic, not sure how to do it in go
	user, err := user.Current()
	if err != nil {
		fmt.Println(err.Error())
	}
	username := user.Username
	return "/home/" + username + "/Documents/TCM/"
}

func onReady() {
	conservationModeFile := "/sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode"
	systray.SetTitle("Linux Conservation Mode Switcher")
	systray.SetTooltip("Lenovo conservation mode utility for linux")

	mToggle := systray.AddMenuItemCheckbox("Status", "Is conservation mode on?", false)
	mQuitOrig := systray.AddMenuItem("Quit", "Quit the app")

	conservationMode := false

	go func() {
		<-mQuitOrig.ClickedCh
		fmt.Println("Requesting quit")
		systray.Quit()
		fmt.Println("Finished quitting")
	}()
	checkState := func() bool {
		status := false

		dat, err := os.ReadFile(conservationModeFile)
		if err != nil {
			fmt.Print(err)
		}
		statusString := string(dat)[0:1]
		fmt.Println(statusString)

		if statusString == "0" {
			status = false
		} else if statusString == "1" {
			status = true
		}
		return status
	}
	changeState := func(cmOn bool) {
		temp := " 0"
		if cmOn {
			temp = " 1"
		}
		pathToFile := filepath.Join(getRunningDir(), "CCM.sh")
		command := "sudo " + pathToFile + temp
		fmt.Println("Sending command :")
		runCommand := exec.Command("/bin/sh", "-c", command)
		fmt.Println(runCommand)
		runCommand.Run()
	}
	updateUI := func() {
		iconPaths := filepath.Join(getRunningDir(), "assets")
		if checkState() {
			mToggle.Check()
			fmt.Println("On")
			conservationMode = true
			systray.SetIcon(getIcon(filepath.Join(iconPaths, "iconOn.ico")))

		} else {
			mToggle.Uncheck()
			fmt.Println("Off")
			conservationMode = false
			systray.SetIcon(getIcon(filepath.Join(iconPaths, "iconOff.ico")))
		}
	}
	updateUI()
	go func() {

		for {
			select {
			case <-mToggle.ClickedCh:
				if mToggle.Checked() {
					conservationMode = false
				} else {
					conservationMode = true
				}
				changeState(conservationMode)
				updateUI()
			}
		}
	}()
}

func onExit() {
	// Cleaning stuff here.
}

func getIcon(s string) []byte {
	b, err := ioutil.ReadFile(s)
	if err != nil {
		fmt.Print(err)
	}
	return b
}

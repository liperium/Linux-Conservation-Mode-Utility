package main

import (
	"fmt"
	"os"
	"os/exec"
	"path"
	"path/filepath"
	"strings"

	"github.com/getlantern/systray"
)

func main() {
	systray.Run(onReady, onExit)
}

func getRunningDir() string {
	return strings.TrimSuffix(path.Dir(os.Args[0]), "bin")
}

func onReady() {
	//conservationModeFile := "/sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode"
	baseCommand := "conservationmode"
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
		cmd := exec.Command(baseCommand, "status")
		//fmt.Println(cmd)
		//dat, err := os.ReadFile(conservationModeFile)
		dat, err := cmd.Output()
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
		temp := "off"
		if cmOn {
			temp = "on"
		}
		baseCommand := "conservationmode"
		//pathToFile := filepath.Join(getRunningDir(), "CCM.sh")
		//fmt.Println("Sending command :")
		runCommand := exec.Command(baseCommand, temp)
		//fmt.Println(runCommand)
		runCommand.Run()
	}
	updateUI := func() {
		dir := getRunningDir()
		fmt.Println(dir)

		iconPaths := filepath.Join(dir, "assets")
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

		for range mToggle.ClickedCh {
			if mToggle.Checked() {
				conservationMode = false
			} else {
				conservationMode = true
			}
			changeState(conservationMode)
			updateUI()
		}
	}()
}

func onExit() {
	// Cleaning stuff here.
}

func getIcon(s string) []byte {
	b, err := os.ReadFile(s)
	if err != nil {
		fmt.Print(err)
	}
	return b
}

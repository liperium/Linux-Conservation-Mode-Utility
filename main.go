package main

import (
	"fmt"
	"io/ioutil"
	"os"
	"os/exec"
	"path/filepath"

	"github.com/getlantern/systray"
)

func main() {
	systray.Run(onReady, onExit)
}

func getRunningDir() string {
	ex, err := os.Executable()
	if err != nil {
		panic(err)
	}
	exPath := filepath.Dir(ex)
	return exPath
}

func onReady() {
	systray.SetIcon(getIcon("assets/iconOn.ico"))
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
		//TODO status check
		return status
	}
	changeState := func(cmOn bool) {
		temp := " 0"
		if cmOn {
			temp = " 1"
		}
		pathToFile := filepath.Join(getRunningDir(), "CCM.sh")
		command := "sudo " + pathToFile + temp
		fmt.Println("Sending command :" + command)
		exec.Command(command)
	}
	updateUI := func() {
		if checkState() {
			mToggle.Check()
			fmt.Println("On")
			conservationMode = true
			systray.SetIcon(getIcon("assets/iconOn.ico"))

		} else {
			mToggle.Uncheck()
			fmt.Println("Off")
			conservationMode = false
			systray.SetIcon(getIcon("assets/iconOff.ico"))
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

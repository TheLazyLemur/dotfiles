package main

import (
	"fmt"
	"os/exec"
	"time"
)

func main() {
	dateFormatString := "01/02 15:04"
	subCmd := "sketchybar --set $NAME label='%s' icon.color=0xffea9d34 background.border_color=0xffea9d34"
	subCmd = fmt.Sprintf(subCmd, time.Now().Format(dateFormatString))

	cmd := exec.Command("sh", "-c", subCmd)
	out, err := cmd.Output()
	if err != nil {
		panic(err)
	}

	println(string(out))
}

package og

import (
	"fmt"
	"io/ioutil"
	"os/exec"
)

func Compile(path string) string {
	file, err := ioutil.ReadFile(path)

	if err != nil {
		fmt.Println("error reading file", path, err)
	}

	preprocessed := Preproc(string(file))

	// fmt.Println(preprocessed)

	res := Parse(string(preprocessed))

	// fmt.Println("OUAT", res)

	final := format(res)

	return final
}

func format(str string) string {
	cmd := exec.Command("gofmt")

	stdin, _ := cmd.StdinPipe()

	go func() {
		defer stdin.Close()

		stdin.Write([]byte(str))
	}()

	final, _ := cmd.CombinedOutput()

	return string(final)
}

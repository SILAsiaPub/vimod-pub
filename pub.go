// Vimod-pub go implimention
// Initial build
// 2018-01-23

package main

import (
	"fmt"
	"strings"
	"os"
	//"os/exec"
	//"path"
	"path/filepath"
	"log"
	//"flag"
    "io"
    //"io/ioutil"
    //"bufio"
)

//var splitpath [2]string
//var projectpath, functiontodebug, inputtasklist, prams, drive  string
var count int = 0
var  projectsetupfolder string
var prt = fmt.Println
var defaultDataPath = "data"
var var1 string = "default"
var var2 string = "none"
var dbi debugInfo
var tf, text string

func main() {
	//flag.StringVar(&ptype, "type", "default", "If used can be: tasklist, menu, debug")
	//flag.StringVar(&typevalue, "value", "none", "If type defined value must be either: \n\t\tfull path to the tasklist \n\t\tor full path to the menu, \n\t\tor the func name to debug")
	//flag.Parse()
	if len(os.Args) > 1 { var1 = os.Args[1] }
	if len(os.Args) > 2 { var2 = os.Args[2] }

	fmt.Println("\n                        Vimod-Pub")
	fmt.Println("     Various inputs multiple outputs digital publishing")
	fmt.Println("          https://github.com/silasiapub/vimod-pub\n")

	//startpath, err := filepath.Abs(filepath.Dir(os.Args[0]))
	//if err != nil {
	//        log.Fatal(err)
	//}

	//var drive string = drive(startpath)
	//fmt.Println(startpath)
	//fmt.Println(drive)
	setup()
    var o debugInfo
	//fmt.Println(os.Args[0])
	//fmt.Println("type:",var1)
	//fmt.Println("value:",var2)
	switch var1 {
	case "tasklist":
		// run the supplied tasklist
		fmt.Println(var1 + " stuff:", var2)
		tasklist(var2)
	case "debug":
		// run the debug
		fmt.Println(var1 + ":", var2)
		o = debug(var2)
        fmt.Println( o.Rpt )
	case "menu":
		// open a menu
		fmt.Println(var1 + ":", var2)
		menu(var2)
	case "default":
		// run normally
		fmt.Println("default", var2)
    // add logic to determine if there is a project.menu
		// if not then generate a menu from the folders

	}
}

func setup() {
	// get variables

}

func tasklist(tl string) (err error) {

	// run a tasklist
	//var taskdrive string = drive(tl)
	//changedrive := exec.Command(taskdrive) // this does not work in windows
	//fmt.Println(taskdrive, changedrive.Run())
	fmt.Println("tasklist", tl)
    filerc, err := os.Open(tl)
    if err != nil{
     fmt.Println("Tasklist not found:", tl)
     log.Fatal(err)
    }
    defer filerc.Close()
    /* r := bufio.NewReader(filerc)
    scanner := bufio.NewScanner(strings.NewReader(string(r)))
    for scanner.Scan() {
        fmt.Println(scanner.Text())
    }
    for bytes, _, err := r.ReadLine(); err != io.EOF ; {
      var hash string = "#"
      var semicolon string = ";"
      line := string(bytes)
      // ...
      switch {
      case strings.ContainsAny(line, hash):
          // ignore line
          prt("ignored line:", line)
      case strings.ContainsAny(line, semicolon):
          // parse line
          // var initPart, funcPart string
          initPart := strings.Split(line, semicolon)[0]
          funcPart := strings.Split(line, semicolon)[1]
          prt(initPart)
          prt(funcPart)
      default:
          // ignore line
      }
    }*/
    return err
}

func menu(m string) (err error) {
	// run a menu
	count := 0
	fmt.Println(count)
	fmt.Println("menu", m)
    mfile, err := os.Open(m)
    if err != nil{
     fmt.Println("Tasklist not found:", m)
     log.Fatal(err)
    }
    defer mfile.Close()
    return err
}

func debug(d string) (dbi debugInfo) {
	// debug a function
	// fmt.Println("debug", d)
	s := "d:/testing/file.ext"
	m := "data/demo/books/setup/project.menu"
    tl := "data/demo/books/setup/sfm2html.tasks"  
    dbi.Func = d    
	var t string
    //    var e error
	//var b bool
	switch d {
	case "drive":
		t = drive(s)
        dbi.TestValue = s
        dbi.ReturnText = t
        dbi.Rpt = d + " input: " + s + "  output: " + t
        //fmt.Println(d,"input:", s, " output:", t)
	case "ext":
		t = ext(s)
        dbi.TestValue = s
        dbi.ReturnText = t
        dbi.Rpt = d + " input: " + s + "  output: " + t
	case "name":
		t = name(s)
        dbi.TestValue = s
        dbi.ReturnText = t
        dbi.Rpt = d + " input: " + s + "  output: " + t
	case "nameExt":
		t = nameExt(s)
        dbi.TestValue = s
        dbi.ReturnText = t
        dbi.Rpt = d + " input: " + s + "  output: " + t
	case "drivepath":
		t = drivepath(s)
        dbi.TestValue = s
        dbi.ReturnText = t
        dbi.Rpt = d + " input: " + s + "  output: " + t
        // Next error return
	case "tasklist":
		e := tasklist(tl)
        dbi.TestValue = tl
        dbi.Er1 = e
        tf = error2string(e)
        dbi.Rpt = d + " input: " + tl + "  isError: " + tf 
    case "menu":
		e := menu(m)
        tf = error2string(e)
        dbi.Rpt = d + " input: " + m + "  isError: " + tf 
	case "CopyFile":
        fmt.Println(d,"testing a file that exists.")
        f := testType{TestFile: "test-files/" + d + "output.txt", SourceFile: "tools/readme.txt"}
		err := CopyFile(f.SourceFile,f.TestFile)
        //fmt.Println(d,"error:", err)
        fmt.Println(d,"isError:", isError(err), err)
        fmt.Println(d,"testing a file that DOES NOT exist.")
        f2 := testType{TestFile: "test-files/" + d + "output.txt", SourceFile: "tools/no-readme.txt"}
		err2 := CopyFile(f2.SourceFile,f2.TestFile)
        //fmt.Println(d,"error:", err2)
        fmt.Println(d,"isError:", isError(err2), err)
	case "copyFileContents":
        f := testType{TestFile: "test-files/" + d + "output.txt", SourceFile: "tools/readme.txt"}
		copyFileContents(f.SourceFile,f.TestFile)
	default:
		fmt.Println("test not defined:", d)
	}
	return dbi
}

func error2string(e error) string {
    if isError(e) { 
        return "true"
    } else { 
        return "false"
    }
}

func drive(dp string) string {
	return strings.SplitAfter(dp, ":")[0]
}

func ext(f string) string {
	return filepath.Ext(f)
}

func name(f string) string {
	return strings.Split(filepath.Base(f), ".")[0]
}

func drivepath(f string) string {
	return filepath.Dir(f)
}

func nameExt(f string) string {
	return name(f) + ext(f)    
}


func check(e error) {
    if e != nil {
        panic(e)
    }
}

func isError(err error) bool {
	if err != nil {
		fmt.Println(err.Error())
	} 
        return (err != nil)
}

type testType struct {
	// for testing
		Type string
		TestFile string
		SourceFile string
		Comment string
}

type debugInfo struct {
	// for testing
		Func string
        TestValue string
        ReturnText string
		Er1 error
		Er2 error
        Rpt string
}

func copyFileContents(src, dst string) (err error) {
// copyFileContents copies the contents of the file named src to the file named
// by dst. The file will be created if it does not already exist. If the
// destination file exists, all it's contents will be replaced by the contents
// of the source file.
// source: https://stackoverflow.com/questions/21060945/simple-way-to-copy-a-file-in-golang
    in, err := os.Open(src)
    if isError(err) { return }
    defer in.Close()
    out, err := os.Create(dst)
    if isError(err) { return }
    defer func() {
        cerr := out.Close()
        if err == nil {
            err = cerr
        }
    }()
    if _, err = io.Copy(out, in); err != nil {
        return
    }
    err = out.Sync()
    return
}

func CopyFile(src, dst string) (err error) {
// CopyFile copies a file from src to dst. If src and dst files exist, and are
// the same, then return success. Otherise, attempt to create a hard link
// between the two files. If that fail, copy the file contents from src to dst.
// source https://stackoverflow.com/questions/21060945/simple-way-to-copy-a-file-in-golang
    sfi, err := os.Stat(src)
    if isError(err) { return }
    if !sfi.Mode().IsRegular() {
        // cannot copy non-regular files (e.g., directories,
        // symlinks, devices, etc.)
        return fmt.Errorf("CopyFile: non-regular source file %s (%q)", sfi.Name(), sfi.Mode().String())
    }
    dfi, err := os.Stat(dst)
    if err != nil {
        if !os.IsNotExist(err) {
            return
        }
    } else {
        if !(dfi.Mode().IsRegular()) {
            return fmt.Errorf("CopyFile: non-regular destination file %s (%q)", dfi.Name(), dfi.Mode().String())
        }
        if os.SameFile(sfi, dfi) {
            return
        }
    }
    if err = os.Link(src, dst); err == nil {
        return
    }
    err = copyFileContents(src, dst)
    if isError(err) {fmt.Println("File not copied")} else {fmt.Println("File copied")}
    return
}

func ifNotExist(t testType ) {
	// testType is a strut for handling variables
	if _, err := os.Stat(t.TestFile); os.IsNotExist(err) {
		// action
		switch t.Type {
		case "copy":
			CopyFile(t.SourceFile,t.TestFile)
		case "del":
			//t.delete()
			deleteFile(t.TestFile)
		}

	}
}

func deleteFile(file string) {
	// https://gist.github.com/novalagung/13c5c8f4d30e0c4bff27
	// delete file
	var err = os.Remove(file)
	if isError(err) { return }

	fmt.Println("==> done deleting file:",file)
}

func checkFile(f string) string {
	// https://gist.github.com/novalagung/13c5c8f4d30e0c4bff27
	file, err := os.Open(f)
	if err != nil {
		log.Fatal(err)
	}
	defer file.Close()
	return f
}

/* func writeFile(f string) string {
	file, err := os.OpenFile(f,os.O_RDWR|os.O_CREATE, 0666)
	if err != nil {
		log.Fatal(err)
	}
	defer file.Close()
	return f
}

func (r testType) copy() {
    // copy file
		// exec.LookPath("copy " + r.Param + " " + r.SourceFile + " " + r.TestFile)
		// following from https://shapeshed.com/copy-a-file-in-go/
		to := r.TestFile
		from, err := ioutil.ReadFile(r.SourceFile)
		check(err)
		_, err = io.Copy(to, from)
		check(err)
} */

func createFile(path string) {
	// https://gist.github.com/novalagung/13c5c8f4d30e0c4bff27
	// detect if file exists
	var _, err = os.Stat(path)

	// create file if not exists
	if os.IsNotExist(err) {
		var file, err = os.Create(path)
		if isError(err) { return }
		defer file.Close()
	}

	fmt.Println("==> done creating file", path)
}

func writeFile(path string,text string) {
	// https://gist.github.com/novalagung/13c5c8f4d30e0c4bff27
	// open file using READ & WRITE permission
	var file, err = os.OpenFile(path, os.O_RDWR, 0644)
	if isError(err) { return }
	defer file.Close()

	// write some text line-by-line to file
	_, err = file.WriteString(text)
	if isError(err) { return }

	// save changes
	err = file.Sync()
	if isError(err) { return }

	fmt.Println("==> done writing to file", path)
}

func readFile(path string) {
	// https://gist.github.com/novalagung/13c5c8f4d30e0c4bff27
	// re-open file
	var file, err = os.OpenFile(path, os.O_RDWR, 0644)
	if isError(err) { return }
	defer file.Close()

	// read file, line by line
	var text = make([]byte, 1024)
	for {
		_, err = file.Read(text)
		
		// break if finally arrived at end of file
		if err == io.EOF {
			break
		}
		
		// break if error occured
		if err != nil && err != io.EOF {
			isError(err)
			break
		}
	}
	
	fmt.Println("==> done reading from file")
	fmt.Println(string(text))
}
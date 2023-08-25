---
author: Pablo Iranzo Gómez
title: Go (golang) plugin in Citellus
tags:
  - go
  - golang
  - citellus
  - risu
layout: post
date: 2020-06-14 11:44:24 +0200
categories:
  - tech
  - risu
lang: en
lastmod: 2023-08-25T09:48:46.698Z
---

I wanted to practice a bit Go programing, so I divided that task in two parts, one, adding a golang extension for Citellus and a sample, but working plugin using it.

If interested in the code it's available at the review at <https://review.gerrithub.io/c/citellusorg/citellus/+/495622>.

The final sample code for it has been:

```go
// Author: Pablo Iranzo Gómez (Pablo.Iranzo@gmail.com)
// Header for citellus metadata
// long_name: Report detected number of CPU's
// description: List the processors detected in the system
// priority: 200

package main

import (
	"bufio"
	"io"
	"os"
	"runtime"
	"strconv"
	"strings"
)

func main() {
	var OKAY, _ = strconv.Atoi(os.Getenv("RC_OKAY"))
	var SKIP, _ = strconv.Atoi(os.Getenv("RC_SKIPPED"))
	var INFO, _ = strconv.Atoi(os.Getenv("RC_INFO"))
	var CITELLUS_ROOT = os.Getenv("CITELLUS_ROOT")
	var CITELLUS_LIVE, _ = strconv.Atoi(os.Getenv("CITELLUS_LIVE"))
	var FAILED, _ = strconv.Atoi(os.Getenv("RC_FAILED"))
	if CITELLUS_LIVE == 1 {
		// Report # of CPU's
		var CPUS = runtime.NumCPU()
		os.Stderr.WriteString(strconv.Itoa(CPUS))
		os.Exit(INFO)
	} else if CITELLUS_LIVE == 0 {
		file, err := os.Open(CITELLUS_ROOT + "/proc/cpuinfo")
		if err != nil {
			os.Stderr.WriteString("Failure to open required file " + CITELLUS_ROOT + "/proc/cpuinfo")
			os.Exit(SKIP)
		}
		defer file.Close()
		counts := wordCount(file)
		os.Stderr.WriteString(strconv.Itoa(counts["processor"]))
		os.Exit(INFO)
	} else {
		os.Stderr.WriteString("Undefined CITELLUS_LIVE status")
		os.Exit(FAILED)
	}
	// Failback case, exiting as OK
	os.Exit(OKAY)
}

// https://forgetcode.com/go/2348-count-the-number-of-word-occurrence-in-given-a-file
func wordCount(rdr io.Reader) map[string]int {
	counts := map[string]int{}
	scanner := bufio.NewScanner(rdr)
	scanner.Split(bufio.ScanWords)
	for scanner.Scan() {
		word := scanner.Text()
		word = strings.ToLower(word)
		counts[word]++
	}
	return counts
}
```

Of course, lot of googling helped to start building the pieces.

Things to have in consideration:

- Go programs are compiled so it requires being compiled with `go build XXX` or executed with `go run XXX`
- Programs executed with `go run XXX` might face some issues, as return code is not honoured (you can find more [information](https://github.com/golang/go/issues/13440) on this).
- As program needs to be compiled, it will take a while to compile before execution (but still is fast)
- Undefined variables will make the program compilation to fail.
- Variable types are checked, so expect to use conversion when reading values, etc to have it compiling and working.

For the [citellus]({{< relref "/tags/citellus" >}}) specifics:

- In above example, we use Citellus Return Codes as defined in the citellus guidelines, but when executed with `go run XXX` only standard error codes are returned
- As citellus metadata parser gets it from headers, an update to the default function was done so that the comment character can be defined, in case of Go programs it is: `//` citellus then takes it into consideration for the offsets to grab the data.

Happy coding!

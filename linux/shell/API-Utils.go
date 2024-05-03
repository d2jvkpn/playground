package main

import (
	// "errors"
	"flag"
	"fmt"
	"net/url"
	"os"
	"strconv"
	"strings"
	"time"

	"crypto/hmac"
	"crypto/md5"
	"crypto/sha1"
	"crypto/sha256"
	"encoding/base64"
	"encoding/hex"
)

func main() {
	var (
		content string
		secret  string
		method  string
		encode  string
		ans     []byte
		err     error
	)

	//
	flag.StringVar(
		&method, "method", "",
		"unix, from_unix, unix-milli, unix-milli, rfc3339, rfc3339-milli, rfc1123;\n"+
			"url-escape, url-unescape;\n"+
			"md5, sha1, sha224, sha256, hmac-sha1, hmac-sha256;",
	)

	flag.StringVar(&encode, "encode", "", "code method for hash and signature: base64, hex")

	flag.StringVar(&secret, "secret", "", "secret")

	flag.Parse()

	flag.Usage = func() {
		fmt.Fprintf(
			flag.CommandLine.Output(),
			"Usage of API-Utils:\n  API-Utils"+
				" -mehtod <Method> -encode [Encode] -secret [Secret] [...Content]\n",
		)
		flag.PrintDefaults()
	}

	//
	defer func() {
		if err != nil {
			fmt.Fprintf(os.Stderr, "%s\n", err.Error())
			os.Exit(1)
		}
	}()

	content = strings.Join(flag.Args(), " ")

	switch method {
	case "unix":
		var t1 time.Time

		if content != "" {
			t1, err = time.Parse(time.RFC3339, content)
			if err != nil {
				return
			}
		} else {
			t1 = time.Now()
		}

		fmt.Println(t1.Unix())
	case "from_unix":
		var ts int64

		if ts, err = strconv.ParseInt(content, 10, 64); err != nil {
			return
		}

		fmt.Println(time.Unix(ts, 0))
	case "unix-milli":
		var t1 time.Time

		if content != "" {
			t1, err = time.Parse("2006-01-02T15:04:05.000-07:00", content)
			if err != nil {
				return
			}
		} else {
			t1 = time.Now()
		}

		fmt.Println(t1.UnixMilli())
	case "from_unix-milli":
		var mts int64

		if mts, err = strconv.ParseInt(content, 10, 64); err != nil {
			return
		}

		fmt.Println(time.UnixMilli(mts))
	case "rfc3339":
		fmt.Println(time.Now().Format(time.RFC3339))
	case "rfc3339ms":
		fmt.Println(time.Now().Format("2006-01-02T15:04:05.000-07:00"))
	case "rfc1123":
		fmt.Println(time.Now().UTC().Format(time.RFC1123))
	case "url-escape":
		fmt.Println(url.QueryEscape(content))
	case "url-unescape":
		if encode, err = url.QueryUnescape(content); err != nil {
			return
		}
		fmt.Println(encode)

	case "md5":
		bts := md5.Sum([]byte(content))
		ans = bts[:]
	case "sha1":
		bts := sha1.Sum([]byte(content))
		ans = bts[:]
	case "sha224":
		bts := sha256.Sum224([]byte(content))
		ans = bts[:]
	case "sha256":
		bts := sha256.Sum256([]byte(content))
		ans = bts[:]
	case "hmac-sha1":
		// err = errors.New("secret is empty")
		hash := hmac.New(sha1.New, []byte(secret))
		hash.Write([]byte(content))
		bts := hash.Sum(nil)
		ans = bts[:]
	case "hmac-sha256":
		hash := hmac.New(sha256.New, []byte(secret))
		hash.Write([]byte(content))

		bts := hash.Sum(nil)
		ans = bts[:]
	default:
		flag.Usage()
		os.Exit(1)
	}

	if len(ans) == 0 {
		return
	}

	switch encode {
	case "hex":
		fmt.Println(hex.EncodeToString(ans[:]))
	case "base64":
		fmt.Println(base64.StdEncoding.EncodeToString(ans))
	default:
		fmt.Printf("%v\n", ans)
	}
}

/*
	for i := range sha {
		sha[i] = sha[i] & 0xff

		if sha[i] < 16 {
			sha[i] = '0'
		}
	}
*/

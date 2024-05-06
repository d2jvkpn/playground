package main

import (
	// "errors"
	"crypto/hmac"
	"crypto/md5"
	"crypto/sha1"
	"crypto/sha256"
	"encoding/base32"
	"encoding/base64"
	"encoding/hex"
	"flag"
	"fmt"
	"io/ioutil"
	"math/rand"
	"net/url"
	"os"
	"strconv"
	"strings"
	"time"

	"github.com/google/uuid"
	"golang.org/x/crypto/bcrypt"
)

const (
	RFC3339Milli = "2006-01-02T15:04:05.000-07:00"
)

func main() {
	var (
		content string
		key     string
		method  string
		encode  string
		ans     []byte
		args    []string
		err     error
	)

	//
	flag.StringVar(
		&method, "method", "",
		"unix, from_unix, unix-milli, from_unix-milli;\n"+
			"rfc3339, rfc3339-milli, rfc1123, rfc1123z;\n"+
			"url-escape, url-unescape, random_string, uuid, bcrypt-hash, bcrypt-verify;\n"+
			"file2string, string2bytes, echo, hex-decode, base32-decode, base64-decode;\n"+
			"md5, sha1, sha224, sha256;\n"+
			"hmac-sha1, hmac-sha256;",
	)

	flag.StringVar(&encode, "encode", "", "code method for hash and signature: base32, base64, hex")
	flag.StringVar(&key, "key", "", "key: secret, bcrypt hash cost, duration")
	flag.Parse()

	flag.Usage = func() {
		fmt.Fprintf(
			flag.CommandLine.Output(),
			"Usage of API-Utils:\n  API-Utils"+
				" <-mehtod Method> [-encode Encode] [-key key] [...Content]\n",
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

	args = flag.Args()
	content = strings.Join(args, " ")

	switch method {
	// time
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

		// TODO: key as Duration, support 1d, 1m, 1y

		fmt.Println(t1.Unix())
	case "from_unix":
		var ts int64

		if ts, err = strconv.ParseInt(content, 10, 64); err != nil {
			return
		}

		fmt.Println(time.Unix(ts, 0).Format(time.RFC3339))
	case "unix-milli":
		var t1 time.Time

		if content != "" {
			t1, err = time.Parse(RFC3339Milli, content)
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

		fmt.Println(time.UnixMilli(mts).Format(RFC3339Milli))
	case "rfc3339":
		fmt.Println(time.Now().Format(time.RFC3339))
	case "rfc3339ms":
		fmt.Println(time.Now().Format(RFC3339Milli))
	case "rfc1123":
		fmt.Println(time.Now().UTC().Format(time.RFC1123))
	case "rfc1123z":
		fmt.Println(time.Now().UTC().Format(time.RFC1123Z))
	// string
	case "url-escape":
		fmt.Println(url.QueryEscape(content))
	case "url-unescape":
		if encode, err = url.QueryUnescape(content); err != nil {
			return
		}
		fmt.Println(encode)
	case "random_string":
		var length int

		if length, err = strconv.Atoi(content); err != nil {
			return
		}

		rd := rand.New(rand.NewSource(time.Now().UnixNano()))
		templ := os.Getenv("templ")
		if templ == "" {
			templ = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
		} else {
			templ = strings.Replace(templ, "[a-z]", "abcdefghijklmnopqrstuvwxyz", -1)
			templ = strings.Replace(templ, "[A-Z]", "ABCDEFGHIJKLMNOPQRSTUVWXYZ", -1)
			templ = strings.Replace(templ, "[0-9]", "0123456789", -1)
		}

		bts := []byte(templ)
		result := make([]byte, length)

		for i := 0; i < length; i++ {
			result[i] = bts[int(rd.Int31n(int32(len(bts))))]
		}

		fmt.Println(string(result))
	case "uuid":
		id := uuid.New()
		fmt.Println(id.String())

	case "bcrypt-hash":
		var (
			cost int = 10
			bts  []byte
		)

		if key != "" {
			if cost, err = strconv.Atoi(key); err != nil {
				return
			}
		}

		if bts, err = bcrypt.GenerateFromPassword([]byte(content), cost); err != nil {
			return
		}

		fmt.Printf("%s\n", bts)

	case "bcrypt-verify":
		if err = bcrypt.CompareHashAndPassword([]byte(content), []byte(key)); err != nil {
			return
		}
		fmt.Println("ok")

	// convert
	case "file2string":
		if ans, err = ioutil.ReadFile(os.Args[1]); err != nil {
			return
		}
	case "string2bytes":
		bts := []byte(content)

		for i := 0; i < len(bts); i++ {
			fmt.Printf("%v ", bts[i])
		}
		fmt.Println("\b")

	case "hex-decode":
		var bts []byte

		if bts, err = hex.DecodeString(content); err != nil {
			return
		}

		fmt.Println(string(bts))
	case "base32-decode":
		var bts []byte

		if bts, err = base32.StdEncoding.DecodeString(content); err != nil {
			return
		}

		fmt.Println(string(bts))
	case "base64-decode":
		var bts []byte

		if bts, err = base64.StdEncoding.DecodeString(content); err != nil {
			return
		}

		fmt.Println(string(bts))
	case "echo":
		ans = []byte(content)
	// hasing
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
	// hmac
	case "hmac-sha1":
		// err = errors.New("key is empty")
		hash := hmac.New(sha1.New, []byte(key))
		hash.Write([]byte(content))
		bts := hash.Sum(nil)
		ans = bts[:]
	case "hmac-sha256":
		hash := hmac.New(sha256.New, []byte(key))
		hash.Write([]byte(content))

		bts := hash.Sum(nil)
		ans = bts[:]
	// default
	default:
		flag.Usage()
		os.Exit(1)
	}

	if len(ans) == 0 {
		return
	}

	switch encode {
	case "base32":
		fmt.Println(base32.StdEncoding.EncodeToString(ans))
	case "base64":
		fmt.Println(base64.StdEncoding.EncodeToString(ans))
	case "hex":
		fmt.Println(hex.EncodeToString(ans))
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

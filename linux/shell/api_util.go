package main

import (
	"errors"
	"flag"
	"fmt"
	"os"

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

	flag.StringVar(&content, "content", "", "content")
	flag.StringVar(&secret, "secret", "", "secret")
	flag.StringVar(&method, "method", "", "md5, sha1, sha224, sha256, hmac-sha1, hmac-sha256")
	flag.StringVar(&encode, "encode", "", "base64, hex")

	flag.Parse()

	defer func() {
		if err != nil {
			fmt.Fprintf(os.Stderr, "%s\n", err.Error())
		}
	}()

	if content == "" {
		err = errors.New("invalid conent")
		return
	}

	// fmt.Println(time.Now().UTC().Format(time.RFC1123))
	switch method {
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
		if secret == "" {
			err = errors.New("secret is empty")
			return
		}

		hash := hmac.New(sha1.New, []byte(secret))
		hash.Write([]byte(content))
		bts := hash.Sum(nil)
		ans = bts[:]
	case "hmac-sha256":
		if secret == "" {
			err = errors.New("secret is empty")
			return
		}

		hash := hmac.New(sha256.New, []byte(secret))
		hash.Write([]byte(content))

		bts := hash.Sum(nil)
		ans = bts[:]
	default:
		if secret == "" {
			err = errors.New("undefined method")
			return
		}
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

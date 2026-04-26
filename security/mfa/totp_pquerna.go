//go:build ignore

package main

import (
	"flag"
	"fmt"
	"os"
	"time"

	"github.com/mdp/qrterminal/v3"
	"github.com/pquerna/otp"
	gotp "github.com/pquerna/otp/totp"
)

func digitsOpt(n int) otp.Digits {
	if n == 8 {
		return otp.DigitsEight
	}
	return otp.DigitsSix
}

func main() {
	issuer  := flag.String("issuer", "MyApp", "服务名称")
	account := flag.String("account", "user@example.com", "账户名")
	secret  := flag.String("secret", "", "TOTP 密钥（Base32），留空则随机生成")
	digits  := flag.Int("digits", 6, "OTP 位数（6 或 8）")
	flag.Parse()

	// 无 secret 时随机生成
	if *secret == "" {
		key, err := gotp.Generate(gotp.GenerateOpts{
			Issuer:      *issuer,
			AccountName: *account,
			Algorithm:   otp.AlgorithmSHA1,
			Digits:      digitsOpt(*digits),
			Period:      30,
		})
		if err != nil {
			fmt.Fprintf(os.Stderr, "生成密钥失败: %v\n", err)
			os.Exit(1)
		}
		fmt.Printf("secret:       %s\n", key.Secret())
		fmt.Printf("otp_auth_url: %s\n\n", key.URL())
		qrterminal.GenerateHalfBlock(key.URL(), qrterminal.L, os.Stdout)
		fmt.Println()
		*secret = key.Secret()
	}

	// 生成当前 TOTP
	code, err := gotp.GenerateCodeCustom(*secret, time.Now(), gotp.ValidateOpts{
		Digits:    digitsOpt(*digits),
		Algorithm: otp.AlgorithmSHA1,
		Period:    30,
	})
	if err != nil {
		fmt.Fprintf(os.Stderr, "生成 TOTP 失败: %v\n", err)
		os.Exit(1)
	}
	fmt.Printf("totp:  %s\n", code)

	// 校验
	valid, _ := gotp.ValidateCustom(code, *secret, time.Now(), gotp.ValidateOpts{
		Digits:    digitsOpt(*digits),
		Algorithm: otp.AlgorithmSHA1,
		Period:    30,
	})
	fmt.Printf("valid: %v\n", valid)
}

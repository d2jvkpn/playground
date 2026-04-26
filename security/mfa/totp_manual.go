package main

import (
	"crypto/hmac"
	"crypto/sha1"
	"encoding/base32"
	"encoding/binary"
	"fmt"
	"strings"
	"time"
)

func totp(secretB32 string, digits int, period int64) (string, error) {
	secret := strings.ToUpper(strings.TrimSpace(secretB32))
	if pad := len(secret) % 8; pad != 0 {
		secret += strings.Repeat("=", 8-pad)
	}
	key, err := base32.StdEncoding.DecodeString(secret)
	if err != nil {
		return "", err
	}

	T := time.Now().Unix() / period

	msg := make([]byte, 8)
	binary.BigEndian.PutUint64(msg, uint64(T))
	mac := hmac.New(sha1.New, key)
	mac.Write(msg)
	h := mac.Sum(nil)

	offset := h[len(h)-1] & 0x0F
	code := binary.BigEndian.Uint32(h[offset:offset+4]) & 0x7FFFFFFF

	mod := uint32(1)
	for range digits {
		mod *= 10
	}
	return fmt.Sprintf("%0*d", digits, code%mod), nil
}

func main() {
	secret := "JBSWY3DPEHPK3PXP"
	code, err := totp(secret, 6, 30)
	if err != nil {
		panic(err)
	}
	fmt.Printf("TOTP: %s\n", code)
}

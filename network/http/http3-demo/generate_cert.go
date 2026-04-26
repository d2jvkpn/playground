package main

import (
	"crypto/ecdsa"
	"crypto/elliptic"
	"crypto/rand"
	"crypto/x509"
	"crypto/x509/pkix"
	"encoding/pem"
	"math/big"
	"os"
	"path/filepath"
	"time"
)

// ---- TLS cert (self-signed) ----
func generateCert(certPath, keyPath, commandName string) error {
	var (
		err               error
		bts               []byte
		priv              *ecdsa.PrivateKey
		certFile, keyFile *os.File
	)

	if err = os.MkdirAll(filepath.Dir(certPath), 0o755); err != nil {
		return err
	}

	if priv, err = ecdsa.GenerateKey(elliptic.P256(), rand.Reader); err != nil {
		return err
	}

	tmpl := &x509.Certificate{
		SerialNumber: big.NewInt(1),
		Subject:      pkix.Name{CommonName: commandName},
		DNSNames:     []string{commandName},
		NotBefore:    time.Now().Add(-time.Minute),
		NotAfter:     time.Now().Add(365 * 24 * time.Hour),
		KeyUsage:     x509.KeyUsageDigitalSignature,
		ExtKeyUsage:  []x509.ExtKeyUsage{x509.ExtKeyUsageServerAuth},
	}

	bts, err = x509.CreateCertificate(rand.Reader, tmpl, tmpl, &priv.PublicKey, priv)
	if err != nil {
		return err
	}

	if certFile, err = os.Create(certPath); err != nil {
		return err
	}
	defer certFile.Close()

	if err = pem.Encode(certFile, &pem.Block{Type: "CERTIFICATE", Bytes: bts}); err != nil {
		return err
	}

	if keyFile, err = os.Create(keyPath); err != nil {
		return err
	}
	defer keyFile.Close()

	if bts, err = x509.MarshalECPrivateKey(priv); err != nil {
		return err
	}

	return pem.Encode(keyFile, &pem.Block{Type: "EC PRIVATE KEY", Bytes: bts})
}

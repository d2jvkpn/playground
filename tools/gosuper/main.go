package main

import (
	"flag"
	//"fmt"
	"log/slog"
	"os"
	"os/exec"
	"os/signal"
	"syscall"
)

var (
	_Logger *slog.Logger = slog.New(slog.NewJSONHandler(os.Stderr, nil))
)

func main() {
	var (
		cmd      string
		postUp   string
		postDown string
		shell    string
		err      error
		postCmd  *exec.Cmd
		mainCmd  *exec.Cmd

		sigChan chan os.Signal
		sig     os.Signal
	)

	flag.StringVar(&cmd, "cmd", "", "main command to run")
	flag.StringVar(&postUp, "postUp", "", "command to run after service starts")
	flag.StringVar(&postDown, "postDown", "", "command to run after service stops")
	flag.StringVar(&shell, "shell", "bash", "shell name")
	flag.Parse()

	if cmd == "" {
		_Logger.Error("Please specify the main command using --cmd") // ❌
		flag.Usage()
		os.Exit(1)
	}

	_Logger.Info( // 🚀
		"starting service",
		slog.String("command", cmd),
		slog.String("postUp", postUp),
		slog.String("postDown", postDown),
	)

	mainCmd = exec.Command(shell, "-c", cmd)
	mainCmd.Stdout, mainCmd.Stderr = os.Stdout, os.Stderr

	if err = mainCmd.Start(); err != nil {
		_Logger.Error("Failed to start service", slog.Any("error", err)) // ❌
		os.Exit(1)
	}

	if postUp != "" {
		_Logger.Info("run PostUp", slog.String("command", postUp)) // 👉
		postCmd = exec.Command(shell, "-c", postUp)
		postCmd.Stdout, postCmd.Stderr = os.Stdout, os.Stderr

		if err = postCmd.Run(); err == nil {
			_Logger.Info("PostUp successful")
		} else {
			_Logger.Error("PostUp failed", slog.Any("error", err))
		}
	}

	sigChan = make(chan os.Signal, 1)
	signal.Notify(sigChan, syscall.SIGINT, syscall.SIGTERM)

	go func() {
		var err error

		if err = mainCmd.Wait(); err != nil {
			_Logger.Error("Service exited with error", slog.Any("error", err)) // ⚠️
		}
		sigChan <- syscall.SIGTERM
	}()

	sig = <-sigChan
	_Logger.Warn("caught signal, preparing to shut down.", slog.String("signal", sig.String())) // 🛑

	if postDown != "" {
		_Logger.Info("run PostDown", slog.String("command", postDown))
		postCmd = exec.Command(shell, "-c", postUp) // 👉
		postCmd.Stdout, postCmd.Stderr = os.Stdout, os.Stderr

		if err = postCmd.Run(); err == nil {
			_Logger.Info("postDown successful")
		} else {
			_Logger.Error("postDown failed", slog.Any("error", err))
		}
	}

	_Logger.Info("gosuper shut down complete") // ✅
}

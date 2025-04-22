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

func main() {
	var (
		cmd, shell       string
		postUp, postDown string
		err              error
		postCmd, mainCmd *exec.Cmd
		logger           *slog.Logger
		sigChan          chan os.Signal
		sig              os.Signal
	)

	flag.StringVar(&cmd, "cmd", "", "main command to run")
	flag.StringVar(&postUp, "postUp", "", "command to run after service starts")
	flag.StringVar(&postDown, "postDown", "", "command to run after service stops")
	flag.StringVar(&shell, "shell", "bash", "shell name")
	flag.Parse()

	logger = slog.New(slog.NewJSONHandler(os.Stderr, nil))

	if cmd == "" {
		logger.Error("Please specify the main command using --cmd") // ❌
		flag.Usage()
		os.Exit(1)
	}

	logger.Info( // 🚀
		"starting service", slog.String("command", cmd),
		slog.String("postUp", postUp), slog.String("postDown", postDown),
	)

	mainCmd = exec.Command(shell, "-c", cmd)
	mainCmd.Stdout, mainCmd.Stderr = os.Stdout, os.Stderr

	if err = mainCmd.Start(); err != nil {
		logger.Error("Failed to start service", slog.Any("error", err)) // ❌
		os.Exit(1)
	}

	if postUp != "" {
		logger.Info("run postUp", slog.String("command", postUp)) // 👉
		postCmd = exec.Command(shell, "-c", postUp)
		postCmd.Stdout, postCmd.Stderr = os.Stdout, os.Stderr

		if err = postCmd.Run(); err == nil {
			logger.Info("postUp successful")
		} else {
			logger.Error("postUp failed", slog.Any("error", err))
		}
	}

	sigChan = make(chan os.Signal, 1)
	signal.Notify(sigChan, syscall.SIGINT, syscall.SIGTERM)

	go func() {
		var err error

		if err = mainCmd.Wait(); err != nil {
			logger.Error("service exited with error", slog.Any("error", err)) // ⚠️
		}
		sigChan <- syscall.SIGTERM
	}()

	sig = <-sigChan
	logger.Warn("caught signal, preparing to shut down.", slog.String("signal", sig.String())) // 🛑

	if postDown != "" {
		logger.Info("run postDown", slog.String("command", postDown))
		postCmd = exec.Command(shell, "-c", postUp) // 👉
		postCmd.Stdout, postCmd.Stderr = os.Stdout, os.Stderr

		if err = postCmd.Run(); err == nil {
			logger.Info("postDown successful")
		} else {
			logger.Error("postDown failed", slog.Any("error", err))
		}
	}

	logger.Info("gosuper shut down complete") // ✅
}

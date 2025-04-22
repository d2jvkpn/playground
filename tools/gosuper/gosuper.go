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
		mainCmd  *exec.Cmd

		sigChan chan os.Signal
		sig     os.Signal
	)

	flag.StringVar(&cmd, "cmd", "", "main command to run")
	flag.StringVar(&postUp, "postup", "", "command to run after service starts")
	flag.StringVar(&postDown, "postdown", "", "command to run after service stops")
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
		_Logger.Info("PostUp", slog.String("command", postUp))
		_ = runCommand("PostUp", shell, postUp)
	}

	sigChan = make(chan os.Signal, 1)
	signal.Notify(sigChan, syscall.SIGINT, syscall.SIGTERM)

	go func() {
		err := mainCmd.Wait()
		if err != nil {
			_Logger.Error("Service exited with error", slog.Any("error", err)) // ⚠️
		}
		sigChan <- syscall.SIGTERM
	}()

	sig = <-sigChan
	_Logger.Warn("caught signal, preparing to shut down.", slog.Any("signal", sig)) // 🛑

	if postDown != "" {
		_Logger.Info("run PostDown", slog.String("command", postDown))
		_ = runCommand("PostDown", shell, postDown)
	}

	_Logger.Info("gosuper shut down complete") // ✅
}

func runCommand(label, shell, cmdStr string) (err error) {
	var cmd *exec.Cmd

	_Logger.Info("run command", slog.String("label", label), slog.String("command", cmdStr)) // 👉
	cmd = exec.Command("bash", "-c", cmdStr)
	cmd.Stdout, cmd.Stderr = os.Stdout, os.Stderr

	if err = cmd.Run(); err == nil {
		_Logger.Info(
			"run successful",
			slog.String("label", label), slog.String("command", cmdStr),
		)
	} else {
		_Logger.Error(
			"run failed",
			slog.String("label", label), slog.String("command", cmdStr), slog.Any("error", err),
		)
	}

	return err
}

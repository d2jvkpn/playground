package main

import (
	"context"
	"log"
	"os"

	"github.com/spf13/viper"
	"google.golang.org/adk/agent"
	"google.golang.org/adk/agent/llmagent"
	"google.golang.org/adk/cmd/launcher"
	"google.golang.org/adk/cmd/launcher/full"
	"google.golang.org/adk/tool"
)

func main() {
	viper.SetConfigType("yaml")
	viper.SetConfigFile("configs/local.yaml")
	if err := viper.ReadInConfig(); err != nil {
		log.Fatalf("Failed to read config: %v", err)
	}

	// baseURL := os.ExpandEnv(viper.GetString("llm.base_url"))
	// apiKey := os.ExpandEnv(viper.GetString("llm.api_key"))
	// modelName := os.ExpandEnv(viper.GetString("llm.model"))

	ctx := context.Background()
	openaiModel, err := NewOpenAIModel(viper.Sub("llm"))
	if err != nil {
		log.Fatalf("NewOpenAIModel: %v\n", err)
	}

	a, err := llmagent.New(llmagent.Config{
		Name:        "chat agent",
		Model:       openaiModel,
		Description: "Tells the current time in a specified city.",
		Instruction: "You are a helpful assistant that tells the current time in a city.",
		Tools:       []tool.Tool{},

		SubAgents: []agent.Agent{},
	})
	if err != nil {
		log.Fatalf("Failed to create agent: %v", err)
	}

	config := &launcher.Config{
		// SessionService   session.Service
		// ArtifactService  artifact.Service
		// MemoryService    memory.Service

		AgentLoader: agent.NewSingleLoader(a),

		// A2AOptions       []a2asrv.RequestHandlerOption
		// PluginConfig     runner.PluginConfig
		// TelemetryOptions []telemetry.Option
	}

	l := full.NewLauncher()
	if err = l.Execute(ctx, config, os.Args[1:]); err != nil {
		log.Fatalf("Run failed: %v\n\n%s", err, l.CommandLineSyntax())
	}
}

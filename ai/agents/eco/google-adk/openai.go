package main

import (
	"context"
	"errors"
	"fmt"
	"io"
	"iter"
	"strings"

	openai "github.com/sashabaranov/go-openai"
	"github.com/spf13/viper"
	"google.golang.org/adk/model"
	"google.golang.org/genai"
)

type OpenAIModel struct {
	Model  string
	Client *openai.Client
}

func NewOpenAIModel(config *viper.Viper) (*OpenAIModel, error) {
	apiKey := config.GetString("api_key")
	model := config.GetString("model")

	if apiKey == "" || model == "" {
		return nil, errors.New("api_key and model must be configured")
	}

	openaiConfig := openai.DefaultConfig(apiKey)

	if v := config.GetString("base_url"); v != "" {
		openaiConfig.BaseURL = strings.TrimRight(v, "/") + "/v1"
	}

	return &OpenAIModel{
		Model:  model,
		Client: openai.NewClientWithConfig(openaiConfig),
	}, nil
}

func (o *OpenAIModel) Name() string {
	return o.Model
}

func (o *OpenAIModel) GenerateContent(ctx context.Context,
	req *model.LLMRequest, stream bool) iter.Seq2[*model.LLMResponse, error] {
	if stream {
		return o.generateStream(ctx, req)
	}

	return func(yield func(*model.LLMResponse, error) bool) {
		resp, err := o.generate(ctx, req)
		yield(resp, err)
	}
}

func (o *OpenAIModel) generate(ctx context.Context, req *model.LLMRequest) (*model.LLMResponse, error) {
	chatReq := openai.ChatCompletionRequest{
		Model:    o.modelName(req),
		Messages: openaiLlmMessages(req),
	}

	resp, err := o.Client.CreateChatCompletion(ctx, chatReq)
	if err != nil {
		return nil, fmt.Errorf("create chat completion: %w", err)
	}
	if len(resp.Choices) == 0 {
		return nil, fmt.Errorf("chat completions returned no choices")
	}

	return &model.LLMResponse{
		Content:      genai.NewContentFromText(resp.Choices[0].Message.Content, genai.RoleModel),
		FinishReason: genai.FinishReasonStop,
		TurnComplete: true,
	}, nil
}

func (o *OpenAIModel) generateStream(ctx context.Context, req *model.LLMRequest) iter.Seq2[*model.LLMResponse, error] {
	return func(yield func(*model.LLMResponse, error) bool) {
		chatReq := openai.ChatCompletionRequest{
			Model:    o.modelName(req),
			Messages: openaiLlmMessages(req),
		}

		stream, err := o.Client.CreateChatCompletionStream(ctx, chatReq)
		if err != nil {
			yield(nil, fmt.Errorf("create chat completion stream: %w", err))
			return
		}
		defer stream.Close()

		var fullText strings.Builder
		for {
			resp, err := stream.Recv()
			if err == io.EOF {
				break
			}
			if err != nil {
				yield(nil, fmt.Errorf("receive chat completion stream: %w", err))
				return
			}
			if len(resp.Choices) == 0 {
				continue
			}

			text := resp.Choices[0].Delta.Content
			if text == "" {
				continue
			}

			fullText.WriteString(text)
			if !yield(&model.LLMResponse{
				Content: genai.NewContentFromText(text, genai.RoleModel),
				Partial: true,
			}, nil) {
				return
			}
		}

		yield(&model.LLMResponse{
			Content:      genai.NewContentFromText(fullText.String(), genai.RoleModel),
			FinishReason: genai.FinishReasonStop,
			TurnComplete: true,
		}, nil)
	}
}

func (o *OpenAIModel) modelName(req *model.LLMRequest) string {
	if req != nil && req.Model != "" {
		return req.Model
	}

	return o.Model
}

func openaiLlmMessages(req *model.LLMRequest) []openai.ChatCompletionMessage {
	var messages []openai.ChatCompletionMessage
	if req != nil && req.Config != nil && req.Config.SystemInstruction != nil {
		if text := contentText(req.Config.SystemInstruction); text != "" {
			msg := openai.ChatCompletionMessage{Role: openai.ChatMessageRoleSystem, Content: text}
			messages = append(messages, msg)
		}
	}

	if req != nil {
		for _, content := range req.Contents {
			if text := contentText(content); text != "" {
				msg := openai.ChatCompletionMessage{Role: openAIRole(content.Role), Content: text}
				messages = append(messages, msg)
			}
		}
	}

	if len(messages) == 0 {
		msg := openai.ChatCompletionMessage{Role: openai.ChatMessageRoleUser, Content: "Hello"}
		messages = append(messages, msg)
	}

	return messages
}

func openAIRole(role string) string {
	switch role {
	case string(genai.RoleModel):
		return openai.ChatMessageRoleAssistant
	case string(genai.RoleUser):
		return openai.ChatMessageRoleUser
	default:
		return openai.ChatMessageRoleUser
	}
}

func contentText(content *genai.Content) string {
	if content == nil {
		return ""
	}

	var parts []string
	for _, part := range content.Parts {
		if part != nil && part.Text != "" {
			parts = append(parts, part.Text)
		}
	}

	return strings.Join(parts, "")
}

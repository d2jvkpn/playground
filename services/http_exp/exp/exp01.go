package main

import (
	"context"
	
	"github.com/google/uuid"
)

type AuthAccount struct {
	Ctx context.Context

	AccountId uuid.UUID
	Role      string
}


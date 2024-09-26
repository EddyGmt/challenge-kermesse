package main

import (
	"project/internal/initializers"
	"project/internal/models"
	"project/internal/seed"
)

func init() {
	initializers.LoadEnvVariables()
	initializers.ConnectToDatabase()
}

func main() {
	err := initializers.DB.AutoMigrate(
		&models.User{},
		&models.Kermesse{},
		&models.Stand{},
		&models.Product{},
		&models.Transaction{},
		&models.Jetons{},
		&models.History{},
	)
	seed.SeedData(initializers.DB)
	if err != nil {
		return
	}
}

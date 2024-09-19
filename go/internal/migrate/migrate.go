package main

import (
	"project/internal/initializers"
	"project/internal/models"
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
	)
	if err != nil {
		return
	}
}

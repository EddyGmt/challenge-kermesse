package main

import (
	"github.com/gin-gonic/gin"
	swaggerFiles "github.com/swaggo/files"
	ginSwagger "github.com/swaggo/gin-swagger"
	"project/api/routes"
	_ "project/docs"
	"project/internal/initializers"
)

func init() {
	initializers.LoadEnvVariables()
	initializers.ConnectToDatabase()
}

func main() {
	server := gin.Default()

	//Déclarer les routes
	routes.AuthRoutes(server)
	routes.UserRoutes(server)
	routes.KermesseRoutes(server)
	routes.StandRoutes(server)
	routes.ProductRoutes(server)
	routes.PaymentRoutes(server)
	routes.TransactionsRoutes(server)
	routes.JetonsRoutes(server)
	routes.ParentRoutes(server)
	routes.ElevesRoutes(server)

	server.GET("/swagger/*any", ginSwagger.WrapHandler(swaggerFiles.Handler))
	err := server.Run(":8080")
	if err != nil {
		return
	}
}

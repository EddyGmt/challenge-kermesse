package routes

import (
	"github.com/gin-gonic/gin"
	"project/api/controllers"
	"project/api/middlewares"
)

// Authentifications
func AuthRoutes(r *gin.Engine) {
	r.POST("/signup", controllers.Signup)
	r.POST("/login", controllers.Login)
	r.POST("/logout", controllers.Logout)
	r.GET("/profile", middlewares.CheckAuth, controllers.UserProfile)
	r.PUT("/update-profile", middlewares.CheckAuth, controllers.UpdateProfile)
}

// CRUD User
func UserRoutes(r *gin.Engine) {
	r.POST("/api/user", middlewares.CheckAuth, controllers.CreateUser)
	r.GET("/api/users", middlewares.CheckAuth, controllers.GetAllUsers)
	r.GET("/api/user/:id", middlewares.CheckAuth, controllers.GetUser)
	r.PUT("/api/user/:id", middlewares.CheckAuth, controllers.UpdateUser)
	r.DELETE("/api/user/:id", middlewares.CheckAuth, controllers.DeleteUser)
}

// CRUD Kermesse
func KermesseRoutes(r *gin.Engine) {
	r.POST("/create-kermesse", middlewares.CheckAuth, controllers.CreateKermesse)
	r.GET("/kermesses", middlewares.CheckAuth, controllers.GetAllKermesses)
	r.GET("/kermesses/:id", middlewares.CheckAuth, controllers.GetKermesseById)
	r.PUT("/kermesses/:id/update", middlewares.CheckAuth, controllers.UpdateKermesse)
	r.DELETE("/kermesses/:id/delete", middlewares.CheckAuth, controllers.DeleteKermesse)
}

// CRUD Stand
func StandRoutes(r *gin.Engine) {
	r.POST("/create-stand", middlewares.CheckAuth, controllers.CreateStand)
	r.GET("/stands", middlewares.CheckAuth, controllers.GetAllStands)
	r.GET("/stands/:id", middlewares.CheckAuth, controllers.GetStandById)
	r.PUT("/stands/:id/update", middlewares.CheckAuth, controllers.UpdateStand)
	r.DELETE("/stands/:id/delete", middlewares.CheckAuth, controllers.DeleteStand)
}

// CRUD Product
func ProductRoutes(r *gin.Engine) {
	r.POST("/create-product", middlewares.CheckAuth, controllers.CreateProduct)
	r.GET("/products", middlewares.CheckAuth, controllers.GetProducts)
	r.PUT("/products/:id/update", middlewares.CheckAuth, controllers.UpdateProduct)
	r.DELETE("/products/:id/delete", middlewares.CheckAuth, controllers.DeleteProduct)
}

func JetonsRoutes(r *gin.Engine) {
	r.POST("/create-jetons", middlewares.CheckAuth, controllers.CreateJetons)
	r.GET("/jetons", middlewares.CheckAuth, controllers.GetJetons)
	r.PUT("/jetons/:id/update", middlewares.CheckAuth, controllers.UpdateJeton)
	r.DELETE("/jetons/:id/delete", middlewares.CheckAuth, controllers.DeleteJeton)
}

func PaymentRoutes(r *gin.Engine) {
	r.POST("/payment", middlewares.CheckAuth, controllers.Payment)
}

func TransactionsRoutes(r *gin.Engine) {
	r.GET("/transactions", middlewares.CheckAuth, controllers.GetTransactions)
}

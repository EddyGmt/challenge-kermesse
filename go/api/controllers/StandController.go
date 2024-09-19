package controllers

import (
	"github.com/gin-gonic/gin"
	"net/http"
	"project/internal/models"
)

func CreateStand(c *gin.Context) {
	user, exists := c.Get("user")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}

	currentUser := user.(models.User)
	if currentUser.Role != 3 {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "You don't have permission to do that"})
		return
	}

	//standCreated := models.Stand{}
}

func GetAllStands(c *gin.Context) {

}
func GetStandById(c *gin.Context) {}
func UpdateStand(c *gin.Context)  {}
func DeleteStand(c *gin.Context)  {}

package controllers

import (
	"github.com/gin-gonic/gin"
	"net/http"
	"project/internal/models"
)

func AddChildren(c *gin.Context) {
	user, exists := c.Get("currentuser")
	if exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "User not logged in"})
	}

	currentUser := user.(models.User)
	if currentUser.Role != 4 {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "You need to have the correct Role (Parent one)"})
		return
	}

}

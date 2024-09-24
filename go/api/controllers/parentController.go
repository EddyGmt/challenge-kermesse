package controllers

import (
	"github.com/gin-gonic/gin"
	"net/http"
	"project/api/requests"
	"project/internal/initializers"
	"project/internal/models"
)

// @Summary Créer une relation parents/enfants
// @Description Permet de créer une relation entre les parents et les enfant
// @Tags Parent
// @Accept json
// @Produce json
// @Security Bearer
// @Param Authorization header string true "Insert your access token" default(Bearer Add access token here)
// @Param parent body requests.AddChildrenRequest true "Ajouter un ou plusieurs enfants"
// @Success 200 {object} models.User
// @Failure 500 {object} gin.H "Erreur serveur interne"
// @Router /add-children [post]
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

	var req requests.AddChildrenRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if len(req.ChildrenIDs) == 0 {
		c.JSON(http.StatusBadRequest, gin.H{"error": "children ids is empty"})
		return
	}

	var children []models.User
	if err := initializers.DB.Where("id IN ?", req.ChildrenIDs).Find(&children).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Erreur lors de la récupération des enfants"})
		return
	}

	if len(children) == 0 {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Aucun enfant trouvé pour les IDs donnés"})
		return
	}

	if err := initializers.DB.Model(&currentUser).Association("Enfants").Append(children); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Erreur lors de l'ajout des enfants"})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message":  "Enfants ajoutés avec succès",
		"children": children,
	})
}

func GiveCoins(c *gin.Context) {
	// Récupérer l'utilisateur connecté
	user, exists := c.Get("currentUser")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "User not logged in"})
		return
	}

	currentUser := user.(models.User)

	if currentUser.Role > 4 {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "You do not have permission to give coins"})
		return
	}

	// Récupérer l'ID de l'enfant depuis les paramètres ou le corps de la requête
	var input struct {
		EnfantID uint `json:"enfant_id"`
		Jetons   uint `json:"jetons"`
	}
	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request"})
		return
	}

	// Vérifier que l'enfant est bien lié au parent
	var enfant models.User
	if err := initializers.DB.Where("id = ?", input.EnfantID).First(&enfant).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Child not found"})
		return
	}

	// Vérifier que l'enfant est bien dans la liste des enfants du parent
	isChildLinked := false
	for _, child := range currentUser.Enfants {
		if child.ID == enfant.ID {
			isChildLinked = true
			break
		}
	}

	if !isChildLinked {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "You are not authorized to give coins to this child"})
		return
	}

	// Vérifier si le parent a suffisamment de jetons
	if currentUser.Jetons < input.Jetons {
		c.JSON(http.StatusBadRequest, gin.H{"error": "You do not have enough coins"})
		return
	}

	// Déduire les jetons du parent et les ajouter à l'enfant
	currentUser.Jetons -= input.Jetons
	enfant.Jetons += input.Jetons

	// Sauvegarder les modifications dans la base de données
	if err := initializers.DB.Save(&currentUser).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Could not update parent's coins"})
		return
	}

	if err := initializers.DB.Save(&enfant).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Could not update child's coins"})
		return
	}

	// Retourner une réponse réussie
	c.JSON(http.StatusOK, gin.H{
		"message":      "Coins successfully transferred",
		"parent_coins": currentUser.Jetons,
		"child_coins":  enfant.Jetons,
	})
}

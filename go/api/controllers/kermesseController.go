package controllers

import (
	"github.com/gin-gonic/gin"
	"net/http"
	"project/api/requests"
	"project/internal/initializers"
	"project/internal/models"
)

// @Summary Créé une kermesse
// @Description Permet aux user de créé un groupe de groupeVoyage
// @Tags Kermesse
// @Accept json
// @Produce json
// @Security Bearer
// @Param Authorization header string true "Insert your access token" default(Bearer Add access token here)
// @Param group body requests.KermeseRequest true "Données du groupe"
// @Success 200 {object} gin.H "Groupe créé"
// @Failure 400 {object} gin.H "Bad request"
// @Failure 401 {object} gin.H "Unauthorized"
// @Failure 404 {object} gin.H "Voyage non trouvé"
// @Failure 409 {object} gin.H "Conflict"
// @Failure 500 {object} gin.H "Internal server error"
// @Router /create-kermesse [post]
func CreateKermesse(c *gin.Context) {
	user, exists := c.Get("currentUser")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "User not logged"})
		return
	}

	currentUser := user.(models.User)
	if currentUser.Role != 1 || currentUser.Role != 2 {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "You do not have permission to do that"})
		return
	}

	var kermesseData requests.KermeseRequest
	kermesse := models.Kermesse{
		Name:   kermesseData.Name,
		UserID: currentUser.ID,
	}

	if err := c.ShouldBind(&kermesse); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message":  "Kermesse créée avec succès",
		"kermesse": kermesse,
	})

}

// @Summary Get all Kermesses based on user role
// @Description Fetches kermesses for admin, organizers, and participants
// @Tags Kermesse
// @Accept json
// @Produce json
// @Security Bearer
// @Param Authorization header string true "Insert your access token" default(Bearer Add access token here)
// @Success 200 {object} []models.Kermesse "List of kermesses"
// @Failure 401 {object} gin.H "User not logged"
// @Failure 500 {object} gin.H "Internal server error"
// @Router /kermesses [get]
func GetAllKermesses(c *gin.Context) {
	user, exists := c.Get("currentUser")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "User not logged"})
		return
	}

	var kermesses []models.Kermesse
	currentUser := user.(models.User)

	// Si l'utilisateur est un administrateur (Role 1), il peut voir toutes les kermesses
	if currentUser.Role == 1 {
		if err := initializers.DB.Preload("Organisateurs").Preload("Participants").Preload("Stands").Find(&kermesses).Error; err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}
		c.JSON(http.StatusOK, gin.H{"kermesses": kermesses})
		return
	}

	// Si l'utilisateur est un organisateur (Role 2), il peut voir ses propres kermesses et celles où il est ajouté
	if currentUser.Role == 2 {
		// Récupérer les kermesses créées par l'organisateur
		if err := initializers.DB.Preload("Organisateurs").Preload("Participants").Preload("Stands").
			Where("user_id = ?", currentUser.ID).Or("id IN (SELECT kermesse_id FROM kermesse_organisateurs WHERE user_id = ?)", currentUser.ID).
			Find(&kermesses).Error; err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}
		c.JSON(http.StatusOK, gin.H{"kermesses": kermesses})
		return
	}

	// Si l'utilisateur est un participant (Role 3 ou 4 ou autre), il peut voir les kermesses où il a été ajouté
	if currentUser.Role >= 3 {
		if err := initializers.DB.Preload("Organisateurs").Preload("Participants").Preload("Stands").
			Where("id IN (SELECT kermesse_id FROM kermesse_participants WHERE user_id = ?)", currentUser.ID).
			Find(&kermesses).Error; err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}
		c.JSON(http.StatusOK, gin.H{"kermesses": kermesses})
	}
}

// @Summary Get a Kermesse by its ID
// @Description Fetch a kermesse by its ID if the user has permission
// @Tags Kermesse
// @Accept json
// @Produce json
// @Security Bearer
// @Param Authorization header string true "Insert your access token" default(Bearer Add access token here)
// @Param id path int true "Kermesse ID"
// @Success 200 {object} models.Kermesse "Kermesse found"
// @Failure 401 {object} gin.H "User not logged"
// @Failure 403 {object} gin.H "Forbidden"
// @Failure 404 {object} gin.H "Kermesse not found"
// @Router /kermesses/{id} [get]
func GetKermesseById(c *gin.Context) {
	user, exists := c.Get("currentUser")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "User not logged"})
		return
	}

	var kermesse models.Kermesse
	id := c.Param("id")

	// Récupérer la kermesse par ID
	if err := initializers.DB.Preload("Organisateurs").Preload("Participants").Preload("Stands").
		Where("id = ?", id).First(&kermesse).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Kermesse not found"})
		return
	}

	currentUser := user.(models.User)

	// Vérifier les permissions
	if currentUser.Role == 1 || // Admin
		kermesse.UserID == currentUser.ID || // Créateur de la kermesse
		initializers.DB.Model(&kermesse).Where("id IN (SELECT kermesse_id FROM kermesse_organisateurs WHERE user_id = ?)", currentUser.ID).RowsAffected > 0 || // Organisateur
		initializers.DB.Model(&kermesse).Where("id IN (SELECT kermesse_id FROM kermesse_participants WHERE user_id = ?)", currentUser.ID).RowsAffected > 0 { // Participant
		c.JSON(http.StatusOK, gin.H{"kermesse": kermesse})
	} else {
		c.JSON(http.StatusForbidden, gin.H{"error": "You don't have access to this kermesse"})
	}
}

// @Summary Update a Kermesse
// @Description Allows an admin or the creator to update a Kermesse
// @Tags Kermesse
// @Accept json
// @Produce json
// @Security Bearer
// @Param Authorization header string true "Insert your access token" default(Bearer Add access token here)
// @Param id path int true "Kermesse ID"
// @Param kermesse body models.Kermesse true "Kermesse data"
// @Success 200 {object} models.Kermesse "Kermesse updated"
// @Failure 401 {object} gin.H "User not logged"
// @Failure 403 {object} gin.H "Forbidden"
// @Failure 404 {object} gin.H "Kermesse not found"
// @Failure 500 {object} gin.H "Internal server error"
// @Router /kermesses/{id}/update [put]
func UpdateKermesse(c *gin.Context) {
	user, exists := c.Get("currentUser")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "User not logged"})
		return
	}

	currentUser := user.(models.User)
	kermesseID := c.Param("id")

	// Rechercher la kermesse à mettre à jour
	var kermesse models.Kermesse
	if err := initializers.DB.Where("id = ?", kermesseID).First(&kermesse).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Kermesse not found"})
		return
	}

	// Vérifier si l'utilisateur est admin (Role 1) ou le créateur de la kermesse
	if currentUser.Role != 1 && kermesse.UserID != currentUser.ID {
		c.JSON(http.StatusForbidden, gin.H{"error": "You don't have permission to update this kermesse"})
		return
	}

	if err := c.ShouldBindJSON(&kermesse); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if err := initializers.DB.Save(&kermesse).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Could not update kermesse"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"kermesse": kermesse})
}

// @Summary Delete a Kermesse
// @Description Allows an admin or the creator to update a Kermesse
// @Tags Kermesse
// @Accept json
// @Produce json
// @Security Bearer
// @Param Authorization header string true "Insert your access token" default(Bearer Add access token here)
// @Param id path int true "Kermesse ID"
// @Param kermesse body models.Kermesse true "Kermesse data"
// @Success 200 {object} models.Kermesse "Kermesse updated"
// @Failure 401 {object} gin.H "User not logged"
// @Failure 403 {object} gin.H "Forbidden"
// @Failure 404 {object} gin.H "Kermesse not found"
// @Failure 500 {object} gin.H "Internal server error"
// @Router /kermesses/{id}/delete [delete]
func DeleteKermesse(c *gin.Context) {
	user, exists := c.Get("currentUser")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "User not logged"})
		return
	}

	currentUser := user.(models.User)
	kermesseID := c.Param("id")

	// Rechercher la kermesse à mettre à jour
	var kermesse models.Kermesse
	if err := initializers.DB.Where("id = ?", kermesseID).First(&kermesse).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Kermesse not found"})
		return
	}

	// Vérifier si l'utilisateur est admin (Role 1) ou le créateur de la kermesse
	if currentUser.Role != 1 && kermesse.UserID != currentUser.ID {
		c.JSON(http.StatusForbidden, gin.H{"error": "You don't have permission to delete this kermesse"})
		return
	}

	if err := c.ShouldBindJSON(&kermesse); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if err := initializers.DB.Delete(&kermesse).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Could not update kermesse"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "kermesse succefully deleted"})
}

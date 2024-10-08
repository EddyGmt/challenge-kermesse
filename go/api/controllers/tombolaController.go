package controllers

import (
	"github.com/gin-gonic/gin"
	"math/rand"
	"net/http"
	"project/internal/initializers"
	"project/internal/models"
	"time"
)

func CreateTombola(c *gin.Context) {}

// @Summary Tire un gagnant pour chaque lot d'une tombola
// @Description Permet de tirer au sort les gagnants pour une tombola spécifique d'une kermesse
// @Tags Tombola
// @Accept json
// @Produce json
// @Param kermesseId path int true "Kermesse ID"
// @Param tombolaId path int true "Tombola ID"
// @Security Bearer
// @Param Authorization header string true "Insert your access token" default(Bearer Add access token here)
// @Success 200 {object} gin.H "Liste des gagnants par lot"
// @Failure 400 {object} gin.H "Bad request"
// @Failure 401 {object} gin.H "Unauthorized"
// @Failure 404 {object} gin.H "Tombola non trouvée ou pas de tickets"
// @Failure 500 {object} gin.H "Internal server error"
// @Router /kermesses/{kermesseId}/tombola/{tombolaId}/draw-winner [post]
func DrawWinner(c *gin.Context) {
	var tickets []models.Ticket
	var lots []models.Lot
	var gagnants []models.User

	// Récupère les paramètres kermesseId et tombolaId depuis la route
	//kermesseId := c.Param("kermesseId")
	tombolaId := c.Param("tombolaId")

	// Vérification de l'utilisateur connecté
	user, exists := c.Get("currentUser")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Utilisateur non connecté"})
		return
	}

	// Cast de l'utilisateur en modèle User
	currentUser := user.(models.User)

	// Vérification des permissions, par exemple si l'utilisateur est administrateur ou organisateur (rôle 1 ou 2)
	if currentUser.Role != 1 && currentUser.Role != 2 {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Vous n'avez pas les permissions pour effectuer cette action"})
		return
	}

	// Récupération des tickets associés à la tombola
	if err := initializers.DB.Where("tombola_id = ?", tombolaId).Find(&tickets).Error; err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Erreur lors de la récupération des tickets"})
		return
	}

	// Vérification s'il y a des tickets dans cette tombola
	if len(tickets) == 0 {
		c.JSON(http.StatusNotFound, gin.H{"error": "Aucun ticket trouvé pour cette tombola"})
		return
	}

	// Récupération des lots associés à la tombola
	if err := initializers.DB.Where("tombola_id = ?", tombolaId).Find(&lots).Error; err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Erreur lors de la récupération des lots"})
		return
	}

	// Vérification s'il y a des lots dans cette tombola
	if len(lots) == 0 {
		c.JSON(http.StatusNotFound, gin.H{"error": "Aucun lot trouvé pour cette tombola"})
		return
	}

	// Mélange aléatoire des tickets (tirage aléatoire)
	rand.Seed(time.Now().UnixNano())
	rand.Shuffle(len(tickets), func(i, j int) {
		tickets[i], tickets[j] = tickets[j], tickets[i]
	})

	// Tirage des gagnants pour chaque lot
	for i, lot := range lots {
		if i < len(tickets) {
			gagnantTicket := tickets[i]
			var gagnant models.User

			// Récupération de l'utilisateur gagnant
			if err := initializers.DB.Where("id = ?", gagnantTicket.UserID).First(&gagnant).Error; err != nil {
				c.JSON(http.StatusInternalServerError, gin.H{"error": "Erreur lors de la récupération de l'utilisateur gagnant"})
				return
			}

			// Assignation du gagnant au lot
			lot.WinnerID = &gagnant.ID
			if err := initializers.DB.Save(&lot).Error; err != nil {
				c.JSON(http.StatusInternalServerError, gin.H{"error": "Erreur lors de l'enregistrement du gagnant pour le lot"})
				return
			}

			// Ajout du gagnant à la liste des gagnants
			gagnants = append(gagnants, gagnant)
		}
	}

	// Réponse avec la liste des gagnants
	c.JSON(http.StatusOK, gin.H{
		"message":  "Tirage effectué avec succès",
		"gagnants": gagnants,
	})
}

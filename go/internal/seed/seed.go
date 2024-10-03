package seed

import (
	"fmt"
	"gorm.io/gorm"
	"log"
	"project/internal/models"
)

func SeedData(DB *gorm.DB) {
	// Vérifier si les données existent déjà
	var count int64
	if err := DB.Model(&models.Jetons{}).Count(&count).Error; err != nil {
		log.Fatalf("Erreur lors du comptage des jetons : %v", err)
		return
	}
	if count > 0 {
		log.Println("Les données sont déjà insérées dans la base de données")
		return
	}

	jetons := []models.Jetons{
		{
			NbJetons: 15,
			Price:    10,
		},
		{
			NbJetons: 32,
			Price:    18,
		},
		{
			NbJetons: 65,
			Price:    25,
		},
		{
			NbJetons: 80,
			Price:    37,
		},
		{
			NbJetons: 110,
			Price:    50,
		},
		{
			NbJetons: 150,
			Price:    70,
		},
	}

	// Enregistrer les instances dans la base de données
	for _, jeton := range jetons {
		if err := DB.Create(&jeton).Error; err != nil { // Corrigé ici
			log.Fatalf("Erreur lors de l'insertion du jeton %v : %v", jeton, err)
		}
	}
	fmt.Println("Seeding completed.")
}

package models

import "time"

type Transaction struct {
	ID              uint      `gorm:"primary_key; not null; autoIncrement" json:"id"`
	Type            string    `gorm:"not null" json:"type"`
	DateTransaction time.Time `gorm:"not null" json:"date_transaction"`
	Price           float32   `gorm:"default:0; not null;" json:"price"`
	Quantity        uint      `gorm:"default:0; not null" json:"Quantity"`

	// Relations avec l'utilisateur
	UserID uint `gorm:"not null" json:"user_id"`       // Clé étrangère
	User   User `gorm:"foreignKey:UserID" json:"user"` // Association avec l'utilisateur
}

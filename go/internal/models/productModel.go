package models

type Product struct {
	ID           uint   `gorm:"primary_key; not null; autoIncrement" json:"id"`
	Name         string `gorm:"size:64; not null" json:"name"`
	Picture      string `gorm:"size:100;" json:"picture"`
	Type         string `gorm:"size:100; not null" json:"type"`
	JetonsRequis int    `gorm:"default: 0; not null" json:"jetons_requis"`
	Nb_Products  int    `gorm:"default:0; not null" json:"nb_products"`
	StandID      int    `gorm:"not null" json:"stand_id"` // Clé étrangère vers le stand
}

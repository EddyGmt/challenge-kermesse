package models

type Stand struct {
	ID          uint      `gorm:"primary_key; not null; autoIncrement " json:"id"`
	Name        string    `gorm:"size:64; not null" json:"name"`
	Type        string    `gorm:"size:64; not null" json:"type"`
	Stock       []Product `gorm:"foreignKey:StandID" json:"stocks"` // Clé étrangère vers Product
	Pts_Donnees uint      `gorm:"default:0; not null" json:"pts_donnees"`
	Conso       uint      `gorm:"default:0; not null" json:"conso"`

	// Relations avec la kermesse et le gestionnaire du stand (User)
	KermesseID uint     `gorm:"not null" json:"kermesse_id"`
	Kermesse   Kermesse `gorm:"foreignKey:KermesseID" json:"kermesse"`

	UserID uint `gorm:"not null" json:"user_id"`
	User   User `gorm:"foreignKey:UserID" json:"user"`
}

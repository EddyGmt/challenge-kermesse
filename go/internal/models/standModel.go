package models

type Stand struct {
	ID           uint      `gorm:"primary_key; not null; autoIncrement " json:"id"`
	Name         string    `gorm:"size:64; not null" json:"name"`
	Type         string    `gorm:"size:64; not null" json:"type"`
	Description  string    `gorm:"size:255;" json:"description"`
	Stock        []Product `gorm:"foreignKey:StandID" json:"stocks"` // Clé étrangère vers Product
	Pts_Donnees  int       `gorm:"not null" json:"pts_donnees"`
	Conso        int       `gorm:"not null" json:"conso"`
	JetonsRequis int       `gorm:"not null" json:"jetons_requis"`

	Kermesses []Kermesse `gorm:"many2many:kermesse_stands;" json:"kermesses"`

	UserID uint `gorm:"not null" json:"user_id"`
	User   User `gorm:"foreignKey:UserID" json:"user"`
}

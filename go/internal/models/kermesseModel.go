package models

type Kermesse struct {
	ID   uint   `gorm:"primary_key; not null; autoIncrement" json:"id"`
	Name string `gorm:"size:64; not null" json:"name"`

	// Relations One-to-Many : Une kermesse a plusieurs stands
	Stands []Stand `gorm:"foreignKey:KermesseID" json:"stands"`

	// Relations Many-to-Many : Organisateurs et participants de la kermesse
	Organisateurs []User `gorm:"many2many:kermesse_organisateurs;" json:"organisateurs"`
	Participants  []User `gorm:"many2many:kermesse_participants;" json:"participants"`

	// Relation Many-to-One : L'utilisateur qui crée la kermesse
	UserID uint `gorm:"not null" json:"user_id"`
	User   User `gorm:"foreignKey:UserID" json:"user"`
}

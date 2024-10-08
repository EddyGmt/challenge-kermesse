package models

type Tombola struct {
	ID         uint     `gorm:"primary_key; autoIncrement; not null" json:"id"`
	Name       string   `gorm:"not null" json:"name"`
	KermesseID uint     `gorm:"not null" json:"kermesse_id"`
	Lots       []Lot    `gorm:"foreignKey:TombolaID" json:"lots"`
	Tickets    []Ticket `gorm:"foreignKey:TombolaID" json:"tickets"`
}

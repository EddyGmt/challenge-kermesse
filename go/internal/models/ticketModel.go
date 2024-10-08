package models

type Ticket struct {
	ID        uint `gorm:"primary_key; autoIncrement; not null" json:"id"`
	TombolaID uint `gorm:"not null" json:"tombola_id"`
	UserID    uint `gorm:"not null" json:"user_id"`
}

package models

type Lot struct {
	ID        uint   `gorm:"primary_key; auto_increment" json:"id"`
	Name      string `gorm:"not null" json:"name"`
	Picture   string `gorm:"" json:"picture"`
	TombolaID uint   `gorm:"not null" json:"tombola_id"`
	WinnerID  *uint  `json:"winner_id"`
}

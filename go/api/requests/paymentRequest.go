package requests

type PaymentRequest struct {
	Type      string  `json:"type" binding:"required"`
	Quantity  int     `json:"quantity" binding:"required"`
	Price     float32 `json:"price" binding:"required"`
	TombolaID uint    `json:"tombola_id"`
}

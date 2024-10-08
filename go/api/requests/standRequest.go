package requests

type StandRequest struct {
	Name         string `json:"name" binding:"required"`
	Type         string `son:"type" binding:"required"`
	Description  string `son:"description"`
	JetonsRequis int    `json:"jetons_requis" binding:"required"`
}

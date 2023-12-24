extends PanelContainer

@onready var texture_tect = $TextureRect

#Drag and drops TextureRect, returns texture_rect as drag data
func drag_data(at_position):
	return texture_tect

#Check if data from drag_data can be dropped
func drop_data(_pos, data):
	return data is TextureRect

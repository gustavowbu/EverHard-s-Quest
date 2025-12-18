extends Control
class_name DragItem

# Este será o item visual que segue o mouse
@onready var sprite: Sprite2D = $Sprite2D

func setup(texture: Texture2D):
	sprite.texture = texture

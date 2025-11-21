extends CanvasLayer

@export var transition_texture: Texture2D
@export var show_time: float = 0.3   # time image stays before the new scene loads

@onready var rect: TextureRect = $TextureRect

func _ready():
	rect.visible = false
	if transition_texture:
		rect.texture = transition_texture


func show_image_and_change_scene(target_scene: String) -> void:
	# show overlay
	rect.visible = true
	rect.modulate = Color.WHITE

	# allow it to draw for 1 frame
	await get_tree().process_frame

	# optional pause before loading
	if show_time > 0:
		await get_tree().create_timer(show_time).timeout

	# load scene
	get_tree().change_scene_to_file(target_scene)

	# allow new scene to render 1 frame
	await get_tree().process_frame

	# hide overlay
	rect.visible = false

extends Area2D

@export var target_position: Vector2 = Vector2.ZERO
@export var overlay_texture: Texture2D
@export var overlay_show_time: float = 0.35  # seconds to show overlay before teleport
@export var hide_after_teleport: bool = true  # hide overlay after teleport

# nodes
@onready var overlay_rect: TextureRect = $CanvasLayer/TextureRect

func _ready() -> void:
	# ensure overlay exists and is hidden
	if overlay_rect:
		overlay_rect.visible = false
		if overlay_texture:
			overlay_rect.texture = overlay_texture

func _on_body_entered(body: Node) -> void:
	if not body or not body.is_in_group("player"):
		return

	# prevent repeated triggers while transition running
	set_monitoring(false)

	# show overlay immediately
	if overlay_rect:
		if overlay_texture:
			overlay_rect.texture = overlay_texture
		overlay_rect.visible = true

	# allow one frame so overlay actually appears on screen
	await get_tree().process_frame

	# optional: small wait so player sees the image
	if overlay_show_time > 0.0:
		await get_tree().create_timer(overlay_show_time).timeout

	# teleport the player
	# for typical CharacterBody2D just set global_position
	if "global_position" in body:
		body.global_position = target_position
	else:
		# fallback: try set position if present
		if "position" in body:
			body.position = target_position

	# allow one frame for camera to snap (if camera follows player)
	await get_tree().process_frame

	if hide_after_teleport and overlay_rect:
		overlay_rect.visible = false

	# re-enable monitoring so door can be used again
	set_monitoring(true)

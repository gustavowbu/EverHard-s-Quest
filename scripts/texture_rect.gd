extends TextureRect

var next_scene_path: String

func start_transition(next_scene: String):
	next_scene_path = next_scene
	self.visible = true
	await get_tree().create_timer(0.6).timeout
	get_tree().change_scene_to_file(next_scene_path)

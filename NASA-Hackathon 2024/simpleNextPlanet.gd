extends XRController3D


# Called when the node enters the scene tree for the first time.
func button_pressed(name: String) -> void:
	if(name == "ax_button"):
		get_tree().reload_current_scene()
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

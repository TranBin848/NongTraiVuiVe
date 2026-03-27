extends BuildingState
class_name BuildingIdleState


func enter(_previous_state: String, _data: Dictionary = {}) -> void:
	# Building is fully constructed - show at full opacity
	if building_behaviour and building_behaviour.sprite:
		building_behaviour.sprite.modulate.a = 1.0

	# Hide progress bar if exists
	if building_behaviour and building_behaviour.progress_bar:
		building_behaviour.progress_bar.visible = false


func exit() -> void:
	pass


func update(_delta: float) -> void:
	pass


func physics_update(_delta: float) -> void:
	pass

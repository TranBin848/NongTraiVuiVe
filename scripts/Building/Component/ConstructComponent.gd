extends Node2D
class_name ConstructComponent

signal sig_construct_complete()
signal sig_construct_progress_changed(progress: float)

@export var construct_config: ConstructConfig
var construct_data: ConstructData


var _current_construct_health: float:
	get:
		return construct_data.current_construct_health


var _max_construct_health: float:
	get:
		return construct_config.max_construct_health


func set_construct_data(_construct_data: ConstructData) -> void:
	construct_data = _construct_data
	assert(construct_data != null, "ConstructData is null")


func add_construct_progress(amount: float) -> void:
	construct_data.current_construct_health = clamp(
		_current_construct_health + amount,
		0,
		_max_construct_health
	)
	sig_construct_progress_changed.emit(get_progress_percent())

	if is_construct_complete():
		sig_construct_complete.emit()
		GlobalSignal.building_construct_complete.emit(get_parent())


func is_construct_complete() -> bool:
	return _current_construct_health >= _max_construct_health


func get_progress_percent() -> float:
	if _max_construct_health <= 0:
		return 1.0
	return _current_construct_health / _max_construct_health

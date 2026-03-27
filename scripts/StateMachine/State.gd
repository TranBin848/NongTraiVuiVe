extends Node2D
class_name State

@warning_ignore("unused_signal")
signal state_changed(next_state: String, data: Dictionary)

var state_machine: BaseStateMachine


func set_state_machine(_state_machine: BaseStateMachine) -> void:
	state_machine = _state_machine


func enter(_previous_state: String, _data: Dictionary = {}) -> void:
	pass


func exit() -> void:
	pass


func update(_delta: float) -> void:
	pass


func physics_update(_delta: float) -> void:
	pass


func is_this_current_state() -> bool:
	if state_machine:
		return state_machine.current_state == self
	return false

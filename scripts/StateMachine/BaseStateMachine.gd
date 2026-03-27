extends Node2D
class_name BaseStateMachine

var current_state: State


func start_machine() -> void:
	set_up_component()
	current_state = get_child(0)
	if current_state:
		current_state.enter("")


func set_up_component() -> void:
	for state: Node2D in get_children():
		if state is State:
			state.set_state_machine(self)
			state.state_changed.connect(transition_to_next_state)


func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)


func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)


func transition_to_next_state(next_state: String, data: Dictionary = {}) -> void:
	if not has_node(next_state):
		push_warning("State not found: " + next_state)
		return

	var previous_state: String = current_state.name
	current_state.exit()
	current_state = get_node(next_state)
	current_state.enter(previous_state, data)

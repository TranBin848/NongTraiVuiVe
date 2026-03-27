extends BuildingState
class_name BuildingConstructState

const CONSTRUCT_ALPHA: float = 0.4
const PROGRESS_PER_CLICK: float = 10.0


func enter(_previous_state: String, _data: Dictionary = {}) -> void:
	# Show semi-transparent sprite during construction
	if building_behaviour and building_behaviour.sprite:
		building_behaviour.sprite.modulate.a = CONSTRUCT_ALPHA

	# Show progress bar
	if building_behaviour and building_behaviour.progress_bar:
		building_behaviour.progress_bar.visible = true
		building_behaviour.progress_bar.value = building_behaviour.construct_component.get_progress_percent() * 100

	# Connect to construct complete signal
	if building_behaviour and building_behaviour.construct_component:
		if not building_behaviour.construct_component.sig_construct_complete.is_connected(_on_construct_complete):
			building_behaviour.construct_component.sig_construct_complete.connect(_on_construct_complete)
		if not building_behaviour.construct_component.sig_construct_progress_changed.is_connected(_on_progress_changed):
			building_behaviour.construct_component.sig_construct_progress_changed.connect(_on_progress_changed)

	# Connect click area
	if building_behaviour and building_behaviour.click_area:
		if not building_behaviour.click_area.input_event.is_connected(_on_click_area_input_event):
			building_behaviour.click_area.input_event.connect(_on_click_area_input_event)

	GlobalSignal.building_construct_started.emit(building_behaviour)


func exit() -> void:
	# Disconnect signals
	if building_behaviour and building_behaviour.construct_component:
		if building_behaviour.construct_component.sig_construct_complete.is_connected(_on_construct_complete):
			building_behaviour.construct_component.sig_construct_complete.disconnect(_on_construct_complete)
		if building_behaviour.construct_component.sig_construct_progress_changed.is_connected(_on_progress_changed):
			building_behaviour.construct_component.sig_construct_progress_changed.disconnect(_on_progress_changed)

	if building_behaviour and building_behaviour.click_area:
		if building_behaviour.click_area.input_event.is_connected(_on_click_area_input_event):
			building_behaviour.click_area.input_event.disconnect(_on_click_area_input_event)


func update(_delta: float) -> void:
	pass


func physics_update(_delta: float) -> void:
	pass


func _on_construct_complete() -> void:
	# Transition to idle state
	state_changed.emit(EnumType.BuildingStateName[EnumType.BuildingState.IDLE])


func _on_progress_changed(progress: float) -> void:
	if building_behaviour and building_behaviour.progress_bar:
		building_behaviour.progress_bar.value = progress * 100


func _on_click_area_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		# Add construction progress on click
		if building_behaviour and building_behaviour.construct_component:
			building_behaviour.construct_component.add_construct_progress(PROGRESS_PER_CLICK)

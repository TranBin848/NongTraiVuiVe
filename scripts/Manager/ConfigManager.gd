extends Node

var building_configs: Array[BuildingConfig] = []


func _ready() -> void:
	_load_building_configs()


func _load_building_configs() -> void:
	# Load all building configs from resources folder
	var config_dir := "res://resources/Configs/BuildingConfigs/"
	var dir := DirAccess.open(config_dir)

	if dir:
		dir.list_dir_begin()
		var file_name := dir.get_next()
		while file_name != "":
			if file_name.ends_with(".tres"):
				var config_path := config_dir + file_name
				var config := load(config_path) as BuildingConfig
				if config:
					building_configs.append(config)
					print("Loaded BuildingConfig: ", config.name)
			file_name = dir.get_next()
		dir.list_dir_end()
	else:
		push_warning("Could not open config directory: " + config_dir)


func get_building_config(building_id: EnumType.Building) -> BuildingConfig:
	for config in building_configs:
		if config.building_id == building_id:
			return config
	return null


func get_all_building_configs() -> Array[BuildingConfig]:
	return building_configs

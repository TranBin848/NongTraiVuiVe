extends Node

## Building signals
@warning_ignore("unused_signal")
signal building_placed(building_behaviour)

@warning_ignore("unused_signal")
signal building_construct_started(building_behaviour)

@warning_ignore("unused_signal")
signal building_construct_complete(building_behaviour)

@warning_ignore("unused_signal")
signal building_clicked(building_behaviour)

@warning_ignore("unused_signal")
signal building_destroyed(building_behaviour)

## Save/Load signals
@warning_ignore("unused_signal")
signal save_data()

@warning_ignore("unused_signal")
signal load_data()

@warning_ignore("unused_signal")
signal done_load_data()

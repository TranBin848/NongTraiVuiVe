class_name EnumType

## Building Types
enum Building {
	NONE = 0,
	HOUSE_1 = 1,
	HOUSE_2 = 2,
	HOUSE_3 = 3,
	TOWER = 4,
	CASTLE = 5,
	ARCHERY = 6,
	BARRACKS = 7,
}

## Building States
enum BuildingState {
	NONE = 0,
	IDLE = 1,
	CONSTRUCT = 2,
	DRAGGING = 3,
}

## State name lookup dictionary for transitions
const BuildingStateName: Dictionary = {
	BuildingState.IDLE: "BuildingIdleState",
	BuildingState.CONSTRUCT: "BuildingConstructState",
	BuildingState.DRAGGING: "BuildingDraggingState",
}

## Building color variants (matches Tiny Swords asset pack)
enum BuildingColor {
	BLUE = 0,
	RED = 1,
	YELLOW = 2,
	PURPLE = 3,
	BLACK = 4,
}

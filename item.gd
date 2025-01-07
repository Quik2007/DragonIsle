extends Node

class_name Item

enum ItemType {FLOWER, DRAGON, EGG_NEST}

var type: ItemType = -1
var level = 0

func from_cell_data(cell: TileData) -> Item:
	type = cell.get_custom_data("item_type")
	level = cell.get_custom_data("item_level")

	return self

# Constructor
func _init(type: ItemType, level: int = 0):
	type = type
	level = level

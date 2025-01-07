extends TileMapLayer

enum Tiles {BLUE, RED, GREEN, WHITE, BLACK}
const source_id = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for y in range(10):
		for x in range(10):
			set_cell(Vector2i(2+x,2+y), source_id, Vector2i(0,Tiles.BLUE))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

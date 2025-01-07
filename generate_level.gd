extends TileMapLayer

const CellTypes = {FOG = Vector2i(3,0), ALIVE = Vector2i(2,0), DEAD = Vector2i(4,0)}
enum Goals {HEAL_ALL_LAND, FLOWER_LEVEL, STATUES}

func maximum_flower_merge_combination(flowers: Array[int]) -> Array[int]:
	for i in len(flowers):
		while flowers[i]>=3:
			if len(flowers) == i+1:
				flowers.append(0)
			flowers[i+1] += 1
			flowers[i] -= 3
			if flowers[i] >= 2:
				flowers[i+1] += 1
				flowers[i] -= 2
				
	return flowers
	
func get_empty_item_cells(item_map: TileMapLayer) -> Array[Vector2i]:
	var res: Array[Vector2i] = []
	var used_item_cells = item_map.get_used_cells()
	for coord in get_used_cells():
		if not used_item_cells.has(coord):
			res.append(coord)
	return res

func get_alive_cells(cells: Array[Vector2i]) -> Array[Vector2i]:
	var res = []
	for coord in cells:
		var cell = get_cell_tile_data(coord)
		if cell == null or cell.get_custom_data_by_layer_id(0) != "alive":
			continue
		res.append(cell)
	return res
		

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var rng := RandomNumberGenerator.new()
	
	var height := rng.randi_range(3,5)
	var width := rng.randi_range(5,10)
	var num_cells := 0
	
	for y in range(height):
		for x in range(width):
			set_cell(Vector2i(x, y), 02, Vector2i(0,0))
			num_cells += 1
	
	var remove_corners = rng.randi_range(0, 3)
	match remove_corners:
		1:
			set_cell(Vector2i(width-1, height-1))
			set_cell(Vector2i(0, 0))
			num_cells -= 2
		2:
			set_cell(Vector2i(0, height-1))
			set_cell(Vector2i(width-1, 0))
			num_cells -= 2
		3:
			set_cell(Vector2i(0, height-1))
			set_cell(Vector2i(width-1, 0))
			set_cell(Vector2i(width-1, height-1))
			set_cell(Vector2i(0, 0))
			num_cells -= 2
	
	var num_alive_cells: int = max(4, int(num_cells / randi_range(8, 13)))
	var potential_cells = get_used_cells()
	var coord = potential_cells.pick_random()
	var alive_cells = []
	for i in range(num_alive_cells):
		while get_cell_tile_data(coord).get_custom_data_by_layer_id(1) == "alive":
			coord = get_surrounding_cells(coord).pick_random()
		alive_cells.append(coord)
		print(alive_cells)
		set_cell(coord, 1, Vector2i(0,0))
		get_cell_tile_data(coord).set_custom_data_by_layer_id(1, "alive")
		coord = get_surrounding_cells(coord).filter(func(cell): return get_cell_tile_data(cell) != null).pick_random()
		
	var item_map: TileMapLayer = get_parent().get_node("ItemMapLayer")
	
	var goal = rng.randi_range(0, 2)
	
	goal = Goals.HEAL_ALL_LAND
	if goal == Goals.HEAL_ALL_LAND:
		# minium three flower level 0
		var life_required = width * height - remove_corners * 2 - num_alive_cells
		var life_available = 0
		
		var dragon := rng.randf() < 0.75
		
		if dragon:
			var flowers: Array[int] = [0,0,0]
			var weigths = PackedFloat32Array([0.3*9, 0.8*3, 0.25])
			
			flowers = [0,0,0]
			var maximum_merge = maximum_flower_merge_combination(flowers)
			while len(maximum_merge) < 3 or maximum_merge[2] < 1:
				flowers[rng.rand_weighted(weigths)] += 1
				maximum_merge = maximum_flower_merge_combination(flowers.duplicate())
			
			
			var surrounding_dead_cells: Array[Vector2i] = []
			for cell in alive_cells:
				for cell_2 in get_surrounding_cells(cell):
					if cell_2 not in surrounding_dead_cells:
						surrounding_dead_cells.append(cell_2)
			
					
		
			var empty_item_cells = get_empty_item_cells(item_map)
			empty_item_cells.shuffle()
			
			var remaining_alive_cells = num_alive_cells - 1
			potential_cells = alive_cells.duplicate()
			potential_cells.shuffle()
			for lvl in range(len(flowers)):
				var num = flowers[lvl]
				var on_alive_land = rng.randi_range(1, min(remaining_alive_cells, num))
				remaining_alive_cells -= on_alive_land
				
				for i in range(on_alive_land):
					coord = potential_cells.pop_back()
					item_map.set_cell(coord, lvl, Vector2i(0,0))
					print("Placing flower Level ", lvl, " at ", coord)
				
				
					
		else:
			pass
		
		
		
		
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

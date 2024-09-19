extends TileMap

signal add_item(item)

func assert_chance(chance):
	return (randi() % 100) > (100 - chance)

func set_tile_matrix(matrix, rows, cols):
	# Clear layer 1 containing the borders and layer 2 containing details
	clear_layer(1)
	clear_layer(2)

	# Clear added items
	for child in get_parent().get_children():
		if child.has_method('item_pickable'):
			child.queue_free()
	
	# Set tiles
	for x in range(0,cols):
		for y in range(0,rows):
			var type = int(matrix[y][x])
			var borders = []
			
			for key in Maps.border_directions:
				var dir = Maps.border_directions[key]
				var nx = x + dir.x;
				var ny = y + dir.y;
					
				# Check if neighbor on this direction is within bounds and of a type higher than the neighbour 
				var is_neighbour_in_bounds = y >= 0 && x < cols-1 && y >= 0 && y < rows-1
				if (is_neighbour_in_bounds && matrix[ny][nx] < type):
					borders.append(key)
			
			_set_tile(Vector2(x, y), type, borders)

func _set_tile(coords, type, borders):
	var tile_data = Maps.tile_type_map[type]
	
	# Render borders for tile_data
	if borders.size() && tile_data.borders.size():
		if [Enums.TileType.FLOOR].has(type):
			_set_tile_wall(tile_data, coords, borders)
		else:
			_set_tile_border(tile_data, coords, borders)
	# 25% chance to render a random tile
	elif (tile_data.random.size() && assert_chance(25)):
		_set_tile_random(tile_data, coords)
	else: 
		_set_tile_default(tile_data, coords)
		
	# 5% chance to render a detail or item if not on a border tile
	if !borders.size() && tile_data.details.size():
		if assert_chance(5):
			if assert_chance(50):
				_set_tile_detail(tile_data, coords)
			else:
				emit_signal("add_item", coords)

func _set_tile_default(tile_data, coords):
	var tile = tile_data.default	
	set_cell(0, coords, 0, Vector2(tile[0],tile[1]))
	
func _set_tile_random(tile_data, coords):
	var random_index = randi() % tile_data.random.size()
	var tile = tile_data.random[random_index]
	
	set_cell(0, coords, 0, Vector2(tile[0],tile[1]))

func _set_tile_border(tile_data, coords, borders):
	var tile = null
	var tile_transform = Enums.TileTransform.Rotate0
	var border_size = borders.size()
	
	match border_size:
		1:
			# The enum value multiplied by 90 deg results in the correct clockwise rotation
			var key = str(borders[0])
			tile = tile_data.borders[0]
			tile_transform = Maps.border_map[border_size][key]
		2:
			# Joined border enum values determine the property for the correct bordered tile
			var key = "".join(borders)
			tile = tile_data.borders[1]
			tile_transform = Maps.border_map[border_size][key]
		3:
			tile = tile_data.default
			tile_transform = Enums.TileTransform.Rotate0
		4:
			tile = tile_data.default
			tile_transform = Enums.TileTransform.Rotate0
			
	set_cell(0, coords, 0, Vector2(tile[0],tile[1]), tile_transform)
			
func _set_tile_wall(tile_data, coords, borders):
	var key = "".join(borders)
	var index = Maps.tile_wall_border_index_map[key]
	var tile = tile_data.borders[index]
	
	set_cell(1, coords, 0, Vector2(tile[0],tile[1]))
	
func _set_tile_detail(tile_data, coords):
	var random_index = randi() % tile_data.details.size()
	var tile = tile_data.details[random_index]
	
	set_cell(2, coords, 0, Vector2(tile[0],tile[1]))

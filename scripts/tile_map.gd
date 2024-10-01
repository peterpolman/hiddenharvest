extends TileMap

signal add_item(item)

const item_pickable = preload("res://scenes/item_pickable.tscn")
const BORDER_NODES = ["BorderNorth", "BorderSouth", "BorderWest", "BorderEast"]

@onready var player = $"../Camera2D/Player"
@onready var hash_label = $"../UI/HashLabel"
@onready var is_loading_label = $"../UI/IsLoadingLabel"

var longitude = 4.843112
var latitude = 52.367066
var bounds = null
var is_loading = false

func _ready():
	player.teleport_to_tile(Vector2(7,5))
	
	_get_tile_matrix(longitude, latitude)

	for border_name in BORDER_NODES:
		get_node(border_name).update_matrix.connect(Callable(self, "_on_update_matrix"))

	add_item.connect(Callable(self, '_on_add_item'))
	player.place_item.connect(Callable(self, '_on_place_item'))
	
func _process(delta):
	is_loading_label.visible = is_loading
	if is_loading:
		player.set_state(Enums.State.IDLE)

func _on_place_item(inventory_item, coords):
	var item = item_pickable.instantiate()
	item.position = map_to_local(coords)
	add_child(item)
	item.create(inventory_item)
	
func _on_add_item(coords: Vector2):
	var type = randi() % Enums.ItemType.size()
	var resource = Maps.item_map[type]
	var item = item_pickable.instantiate()
	item.position = map_to_local(coords)
	add_child(item)
	item.create(resource)
	
#func assert_chance(chance):
	#return (randi() % 100) > (100 - chance)

func set_tile_matrix(matrix, rows, cols):
	# Clear added items
	for child in get_parent().get_children():
		if child.has_method('item_pickable'):
			child.queue_free()
	
	# Render terrain map
	var terrain_set = 0
	var cells = {}
	
	# Define cells dict for every tile type
	for type in Enums.TileType.values():
		clear_layer(type)
		cells[type] = []
	
					
	for x in range(0,cols):
		for y in range(0,rows):
			var cell_pos = Vector2i(x, y)
			var type = int(matrix[y][x])
			var tile = Maps.tile_type_map[type]
		
			cells[type].append(cell_pos)
			
	# Populate dict with cell positions for every tile type
	for x in range(0,cols):
		for y in range(0,rows):
			var cell_pos = Vector2i(x, y)
			# Set bg tile
			set_cell(0, cell_pos, 3, Vector2i(0,4))
			
			# Check and adjust neighbors
			var type = int(matrix[y][x])
			var neighbors = get_valid_neighbors(x, y, cols, rows)
			var tile = Maps.tile_type_map[type].default
						
			for neighbor in neighbors:
				var neighbor_type = int(matrix[neighbor.y][neighbor.x])
				set_cell(0, Vector2i(neighbor.x, neighbor.y), 3, Vector2i(tile[0], tile[1]))
					
	# Render cells for every terrain in set
	for type in cells:
		set_cells_terrain_connect(type, cells[type], terrain_set, type)
	
# Function to get valid neighbors
func get_valid_neighbors(x, y, cols, rows):
	var neighbors = []
	for dir in [Vector2i.UP, Vector2i.RIGHT, Vector2i.DOWN, Vector2i.LEFT]:
		var nx = x + dir.x
		var ny = y + dir.y
		if nx >= 0 and nx < cols and ny >= 0 and ny < rows:
			neighbors.append(Vector2i(nx, ny))
	return neighbors

func _on_update_matrix(data):
	# Match direction and load
	match data.direction:
		Vector2.UP:
			latitude = bounds.maxLat + 0.0001
		Vector2.RIGHT:
			longitude = bounds.maxLon + 0.0001
		Vector2.DOWN:
			latitude = bounds.minLat - 0.0001
		Vector2.LEFT:
			longitude = bounds.minLon - 0.0001
	
	_get_tile_matrix(longitude, latitude)
	
	var target_tile = _flip_position(data.tile)
	player.teleport_to_tile(target_tile)
	
	
func _flip_position(current_tile: Vector2) -> Vector2:
	var matrix_size = Vector2(18, 10)
	var target_tile = current_tile
	
	# Wrap x-coordinate
	if current_tile.x < 0:
		target_tile.x = matrix_size.x - 1
	elif current_tile.x >= matrix_size.x:
		target_tile.x = 0
	
	# Wrap y-coordinate
	if current_tile.y < 0:
		target_tile.y = matrix_size.y - 1
	elif current_tile.y >= matrix_size.y:
		target_tile.y = 0
	
	return target_tile
	
func _get_tile_matrix(lon, lat):
	is_loading = true
	
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(self._http_request_completed)

	var error = http_request.request("http://localhost:3001/tiles", ["Content-Type: application/json"], HTTPClient.METHOD_POST, JSON.stringify([lon,lat]))
	if error != OK:
		print("An error occurred while making the request: ", error)

func _http_request_completed(result, response_code, headers, body):
	var json_str = body.get_string_from_utf8()
	var response = JSON.parse_string(json_str)
	
	is_loading = false
	
	if response_code == 200 && response.size() > 0:
		hash_label.text = response[0].hash
		
		bounds = response[0].bounds
		
		# Render current hash
		var matrix = response[0].matrix
		var cols = matrix[0].size()
		var rows = matrix.size()
		
		set_tile_matrix(matrix, rows, cols)
			
	else:
		print("Failed fetch tile matrix")

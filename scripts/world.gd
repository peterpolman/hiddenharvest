extends Node2D

const BORDER_NODES = ["BorderNorth", "BorderSouth", "BorderWest", "BorderEast"]
const item_pickable = preload("res://scenes/item_pickable.tscn")

@onready var player = $Camera2D/Player
@onready var tile_map = $TileMap
@onready var hash_label = $UI/HashLabel
@onready var is_loading_label = $UI/IsLoadingLabel

var longitude = 4.843112
var latitude = 52.367066
var bounds = null
var is_loading = false

func _ready():
	player.teleport_to_tile(Vector2(7,5))
	
	_get_tile_matrix(longitude, latitude)

	for border_name in BORDER_NODES:
		get_node(border_name).update_matrix.connect(Callable(self, "_on_update_matrix"))

	tile_map.add_item.connect(Callable(self, '_on_add_item'))
	player.place_item.connect(Callable(self, '_on_place_item'))
	
func _process(delta):
	is_loading_label.visible = is_loading
	if is_loading:
		player.set_state(Enums.State.IDLE)

func _on_place_item(inventory_item, coords):
	var item = item_pickable.instantiate()
	item.position = tile_map.map_to_local(coords)
	add_child(item)
	item.create(inventory_item)
	
func _on_add_item(coords: Vector2):
	var type = randi() % Enums.ItemType.size()
	var resource = Maps.item_map[type]
	var item = item_pickable.instantiate()
	item.position = tile_map.map_to_local(coords)
	add_child(item)
	item.create(resource)

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
		
		tile_map.set_tile_matrix(matrix, rows, cols)
			
	else:
		print("Failed fetch tile matrix")

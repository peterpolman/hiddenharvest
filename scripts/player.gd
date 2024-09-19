extends CharacterBody2D

signal place_item(item)

const TILE_SIZE = 16
const speed = 75

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var ray_cast_2d = $RayCast2D
@onready var tile_highlight = $TileHighlight
@onready var progress = $Progress
@onready var game_manager = %GameManager

@export var tile_map: TileMap
@export var inventory: Inventory

var state = Enums.State.IDLE
var target_position = Vector2(128 + (TILE_SIZE / 2), 80 + (TILE_SIZE / 2))

func player():
	pass
	
func _physics_process(delta):
	if [Enums.State.WALKING].has(state):
		position = position.move_toward(target_position, speed * delta)
			
		if position == target_position:
			set_state(Enums.State.IDLE)
	
	if [Enums.State.SELECTING_TILE].has(state):
		if Input.is_action_just_pressed("cancel"):
			tile_highlight.visible = false
			set_state(Enums.State.IDLE)
	
		# Interact with selection
		if Input.is_action_just_pressed("interact"):
			# Use selected item
			var slot = inventory.get_selected_slot()
			if slot.item:
				_use_item(slot)
		
		# Handle tile selection
		if Input.is_action_just_pressed("select_up"):
			_select_tile(Vector2.UP)
		elif Input.is_action_just_pressed("select_right"):
			_select_tile(Vector2.RIGHT)
		elif Input.is_action_just_pressed("select_down"):
			_select_tile(Vector2.DOWN)
		elif Input.is_action_just_pressed("select_left"):
			_select_tile(Vector2.LEFT)		
				
	# Walk in direction
	#if [Enums.State.IDLE, Enums.State.WALKING].has(state):
	if Input.is_action_pressed("right"):
		_move_to_tile(Vector2.RIGHT, delta)
	if Input.is_action_pressed("down"):
		_move_to_tile(Vector2.DOWN, delta)
	if Input.is_action_pressed("left"):
		_move_to_tile(Vector2.LEFT, delta)
	if Input.is_action_pressed("up"):
		_move_to_tile(Vector2.UP, delta)

func _use_item(slot: InventorySlot):
	# Place the item_pickable on the map
	var target_tile = tile_map.local_to_map(tile_highlight.global_position + Vector2(8,8))
	tile_map.set_cell(2, target_tile, 0, Vector2(1,15))		
	emit_signal("place_item", slot.item, target_tile)
	
	# Start timer for callback
	inventory.activate()
	progress.timeout_signal.connect(Callable(self, '_on_timeout_progress').bind(slot))
	progress.start(slot.item.duration)
	
func _on_timeout_progress(slot: InventorySlot):
	if !slot.item:
		return
	
	slot.item.use(player)
	inventory.remove(slot.item, 1)
	slot.clear()

func set_state(_state: Enums.State):
	if state != _state: 
		print('New state: ', state)
	
	state = _state
	
	match state:
		Enums.State.IDLE:
			animated_sprite_2d.play("idle")
		Enums.State.WALKING:
			tile_highlight.visible = false
			animated_sprite_2d.play("walk")
		Enums.State.SELECTING_TILE:
			_select_tile(Vector2.UP)

func teleport_to_tile(target_tile: Vector2):
	position = tile_map.map_to_local(target_tile)

func _select_tile(direction):
	var pos = Vector2(
		(direction.x * TILE_SIZE) - 8,
		(direction.y * TILE_SIZE) - 8,
	)
	tile_highlight.visible = true
	tile_highlight.position = pos
	
func _move_to_tile(direction: Vector2, delta):
	set_state(Enums.State.WALKING)
		
	var current_tile = tile_map.local_to_map(global_position)
	var target_tile = Vector2i(current_tile.x + direction.x, current_tile.y + direction.y)
	
	ray_cast_2d.target_position = direction * TILE_SIZE
	ray_cast_2d.force_raycast_update()
	
	match direction:
		Vector2.LEFT:
			animated_sprite_2d.flip_h = true
		Vector2.RIGHT:
			animated_sprite_2d.flip_h = false	
	
	if ray_cast_2d.is_colliding():
		return

	target_position = tile_map.map_to_local(target_tile)

extends CanvasLayer

@onready var player = $"../Camera2D/Player"
@onready var tile_map = $"../TileMap"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Select an item in inventory
	if ![Enums.State.SELECTING_TILE].has(player.state):
		if Input.is_action_just_pressed("cancel"):
			player.set_state(Enums.State.IDLE)
		
		if Input.is_action_just_pressed("interact"):
			var slot = player.inventory.get_selected_slot()
			if slot.item:
				player.set_state(Enums.State.SELECTING_TILE)
				
		if Input.is_action_just_pressed("select_left"):
			player.inventory.select_item(Vector2.LEFT)
		elif Input.is_action_just_pressed("select_right"):
			player.inventory.select_item(Vector2.RIGHT)

extends Area2D

@export var tile_map: TileMap
@export var player: CharacterBody2D

signal update_matrix(data)

func _on_body_entered(body):
	var current_tile = tile_map.local_to_map(player.global_position)
	if (current_tile.y <= 0):
		emit_signal("update_matrix", {
			"direction": Vector2.UP,
			"tile": current_tile,
		})
	if (current_tile.y >= 9):
		emit_signal("update_matrix", {
			"direction": Vector2.DOWN,
			"tile": current_tile,
		})
	if (current_tile.x >= 16):
		emit_signal("update_matrix", {
			"direction": Vector2.RIGHT,
			"tile": current_tile,
		})
	if (current_tile.x <= 0):
		emit_signal("update_matrix", {
			"direction": Vector2.LEFT,
			"tile": current_tile,
		})

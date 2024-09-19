extends Area2D

@onready var sprite_2d = $Sprite2D

var item = null

func item_pickable():
	pass

func create(_item: InventoryItem):
	item = _item
	sprite_2d.texture = item.texture
	
func _on_body_entered(body):
	if !body.has_method("player"):
		return

	body.inventory.insert(item)
	queue_free()

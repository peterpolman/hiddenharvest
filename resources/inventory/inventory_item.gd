extends Resource

class_name InventoryItem

@export var name: String = ""
@export var texture: AtlasTexture
@export var amount: int = 1
@export var duration: float = 3.0
@export var heal_amount: int = 100

func use(player):
	print('Use: ', name)

func place():
	pass

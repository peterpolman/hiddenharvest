extends Resource

class_name InventorySlot

@export var item: InventoryItem
@export var amount: int
@export var is_selected: bool = false
@export var is_active: bool = false

func activate():
	is_active = true

func select():
	is_selected = true
	
func clear():
	is_selected = false
	is_active = false

extends Panel

@onready var item_background = $ItemBackground
@onready var item_display = $ItemDisplay
@onready var item_amount = $ItemAmount

func update(slot: InventorySlot):	
	if slot.item:
		item_display.visible = true
		item_display.texture = slot.item.texture
		item_amount.visible = slot.amount > 1
		item_amount.text = str(slot.amount)
	else:
		item_display.visible = false
		item_amount.visible = false
		
	if slot.is_active:
		item_background.color = Color(0, 1, 0, .5)
	elif slot.is_selected:
		item_background.color = Color(1, 1, 1, .5)
	else:
		item_background.color = Color(0, 0, 0, .5)

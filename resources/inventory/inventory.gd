extends Resource

class_name Inventory

signal activate_signal
signal update_signal
signal select_signal(index)

@export var slots: Array[InventorySlot]

var selected_slot_index = 0

func activate():
	emit_signal("activate_signal", selected_slot_index)

func select_item(dir):
	# Increase index
	selected_slot_index += dir.x
	if selected_slot_index >= slots.size():
		selected_slot_index = slots.size() - 1
	if selected_slot_index < 0:
		selected_slot_index = 0
	
	emit_signal("select_signal", selected_slot_index)

func remove(item: InventoryItem, amount: int):
	var item_slots = slots.filter(func(slot): return slot.item == item)
	if !item_slots.is_empty():
		item_slots[0].amount -= amount
		if !item_slots[0].amount:
			item_slots[0].item = null	

	emit_signal("update_signal")
	
func insert(item: InventoryItem):
	var item_slots = slots.filter(func(slot): return slot.item == item)
	
	if !item_slots.is_empty():
		item_slots[0].amount += item.amount
	else:
		var empty_slots = slots.filter(func(slot): return slot.item == null)
		if !empty_slots.is_empty():
			empty_slots[0].item = item
			empty_slots[0].amount = item.amount
	
	emit_signal("update_signal")

func get_selected_slot():
	return slots[selected_slot_index]

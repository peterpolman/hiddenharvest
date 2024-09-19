extends Control

@onready var inventory = preload("res://resources/inventory/inventory_player.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()

func _ready():
	inventory.activate_signal.connect(Callable(self, '_on_activate'))
	inventory.select_signal.connect(Callable(self, '_on_select'))
	inventory.update_signal.connect(Callable(self, '_on_update'))

	_update_slots_ui()
	
func _on_update():
	_update_slots_ui()
	
func _on_activate(index: int):
	inventory.slots[index].activate()
	_update_slots_ui()

func _on_select(index: int):
	# Deselect all slots
	for i in range(min(inventory.slots.size(), slots.size())):
		inventory.slots[i].clear()
			
	# Select slot
	if slots[index]:
		inventory.slots[index].select()
	
	# Update UI
	_update_slots_ui()
					
func _update_slots_ui():
	for i in range(min(inventory.slots.size(), slots.size())):
		slots[i].update(inventory.slots[i])

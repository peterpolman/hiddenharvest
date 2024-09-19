extends Node

@onready var player = $Camera2D/Player

var timer_place = Timer.new()
var timer_use = Timer.new()

func _ready():
	add_child(timer_place)
	add_child(timer_use)
	
	timer_place.timeout.connect(Callable(self, "_on_place_callback"))
	timer_use.connect("timeout", Callable(self, "_on_use_callback"))
	
	timer_place.wait_time = 3
	timer_place.start()
	
func wait_for_place(duration: float):
	timer_place.wait_time = duration
	timer_place.start()
	
func wait_for_use(duration: float):
	timer_use.wait_time = duration
	timer_use.start()

func _on_place_callback(item):
	var slot = player.inventory.get_selected_slot()
	print(slot.item)
	print('place timer')
	
func _on_use_callback():
	var slot = player.inventory.get_selected_slot()
	print(slot.item)
	print('use timer')

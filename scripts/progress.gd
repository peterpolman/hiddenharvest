extends ColorRect

signal timeout_signal

@onready var progress_bar = $ProgressBar

func _ready():
	visible = false
	progress_bar.scale = Vector2(0, 1)

func start(duration):
	visible = true
	print('tween start')
	var tween = create_tween()
	tween.connect("finished", Callable(self, "_on_tween_finished"))
	tween.tween_property(progress_bar, "scale", Vector2(1, 1), duration)

func _on_tween_finished():
	print('tween finished')
	visible = false
	progress_bar.scale = Vector2(0, 1)
	emit_signal('timeout_signal')
	
